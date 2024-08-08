{ ips, ports, sshkeys, outer_config, lib, ... }:
let
  hostname = outer_config.networking.hostName;
  ssh_ports = ports."${hostname}".ssh;
  ports_noports = { default_ports ? true, user ? "root", name ? hostname
    , hostname, proxyJump ? null, localForwards ? [ ], additionalOpts ? {} }:
    let
      common = {
        inherit user hostname;
      } // (if proxyJump == null then { } else { inherit proxyJump; }) // additionalOpts;
      common_ports = common // { inherit localForwards; };
    in {
      "${name}_noports" = common;
      "${name}_ports" = common_ports;
      "${name}" = (if default_ports then common_ports else common);
    };

  # l -> local ip
  # m -> welt -> server only do this if we have a wg ip
  # g  = "" -> welt -> porta -> server
  local_global = { default_ports ? true, user ? "root", name, local_ip
    , wg_ip ? null, localForwards ? [ ], forward_user ? false }:
    ports_noports {
      inherit default_ports user localForwards;
      name = "l_${name}";
      hostname = local_ip;
    }
    // ports_noports {
      inherit default_ports user localForwards;
      proxyJump = "porta";
      name = "g_${name}";
      hostname = local_ip;
    }
    // ports_noports {
      inherit default_ports user name localForwards;
      proxyJump = "porta";
      hostname = local_ip;
    }
    // (if wg_ip == null then
      { }
    else
      (ports_noports {
        inherit default_ports user localForwards;
        proxyJump = "welt";
        name = "m_${name}";
        hostname = wg_ip;
      }))
    // (if !forward_user then {} else (
    ports_noports{
      inherit default_ports localForwards;
      user = "forward";
      name = "forward_g_${name}";
      proxyJump = "forward_porta";
      hostname = local_ip;
      additionalOpts = {
      identitiesOnly = true;
      identityFile = [sshkeys.forward_path];
      };
    } //
    ports_noports{
      inherit default_ports localForwards;
      user = "forward";
      name = "forward_m_${name}";
      proxyJump = "forward_welt";
      hostname = wg_ip;
      additionalOpts = {
        identitiesOnly = true;
        identityFile = [sshkeys.forward_path];
      };
    }


    ));

  simple_forwards = ports: (builtins.map (port: (simple_forward port)) ports);
  simple_forward = port:
  {
    bind.port = port;
    host.port = port;
    host.address = "127.0.0.1";
  };
in with ips; {
  services.ssh-agent.enable = true;
  programs.ssh = {
    addKeysToAgent = "1h";
    enable = true;
    matchBlocks = {
      "fs_main" = {
        user = "hoh47200";
        hostname = "cloud.fsim-ev.de";
      };
      "pve_tabula" = {
        user = "root";
        hostname = ips.pve.vmbr0;
        proxyJump = "m_tabula";
        localForwards = [ (simple_forward (ports."${hostname}".ssh.proxmox.gui)) ];
      };
      "welt" = {
        user = "root";
        hostname = "hannses.de";
      };
      "forward_welt" = {
        user = "forward";
        hostname = "hannses.de";
        identitiesOnly = true;
        identityFile = [sshkeys.forward_path];
      };
      # can not replace with local_global as different hostnames
      "porta_local" = {
        user = "root";
        hostname = ips.porta.ens3;
      };
      "porta" = {
        user = "root";
        hostname = ips.porta.wg0;
        proxyJump = "welt";
      };
      "forward_porta" = {
        user = "forward";
        hostname = ips.porta.wg0;
        proxyJump = "forward_welt";
        identitiesOnly = true;
        identityFile = [sshkeys.forward_path];
      };
    } // local_global {
      forward_user = true;
      name = "pve";
      local_ip = ips.pve.vmbr0;
      localForwards = [ (simple_forward (ports."${hostname}".ssh.proxmox.gui)) ];
    } // local_global {
      forward_user = true;
      name = "syncschlawiner";
      local_ip = ips.syncschlawiner.ens3;
      wg_ip = ips.syncschlawiner.wg0;
      localForwards = [
        #TODO: determine allowed ports
        {
          #bind.port = 8385;
          bind.port = ssh_ports.syncschlawiner.syncthing.gui;
          host.port = ports.syncschlawiner.syncthing.gui;
          host.address = "127.0.0.1";
        }
        {
          bind.port = ssh_ports.syncschlawiner."80";
          host.port = 80; # See note in ports.nix
          host.address = "127.0.0.1";
        }
        {
          bind.port = ssh_ports.syncschlawiner."443";
          host.port = 443;
          host.address = "127.0.0.1";
        }
        {
          bind.port = ssh_ports.syncschlawiner."8081";
          host.port = 8081;
          host.address = "127.0.0.1";
        }
      ];
    } // local_global {
      name = "syncschlawiner_mkhh";
      local_ip = ips.syncschlawiner_mkhh.ens3;
      wg_ip = ips.syncschlawiner_mkhh.wg0;
    } // local_global {
      name = "tabula";
      local_ip = ips.tabula.ens3;
      wg_ip = ips.tabula.wg0;
      localForwards = [
        {
          bind.port = ssh_ports.tabula.syncthing.gui;
          host.port = ports.tabula.syncthing.gui;
          host.address = "127.0.0.1";
        }
        {
          bind.port = ssh_ports.tabula."443";
          host.port = 443;
          host.address = "127.0.0.1";
        }
        {
          bind.port = ssh_ports.tabula."80";
          host.port = 80;
          host.address = "127.0.0.1";
        }
      ];
    } // local_global {
      name = "grapheum";
      local_ip = ips.grapheum.ens3;
      #wg_ip =  grapheum.wg0;
    };
  };
}
