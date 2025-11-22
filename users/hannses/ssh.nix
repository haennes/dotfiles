{ sshkeys, osConfig, lib, ... }:
let
  inherit (lib)
    optionalAttrs mapAttrsRecursive attrsToList removeAttrs listToAttrs flatten
    getAttrFromPath collect isList optionals elem;
  inherit (lib.my) mapAttrsFlattened;
  forwards = [ "pve" "syncschlawiner" ];
  ports = osConfig.ports.ports.ports;
  ssh_ports = osConfig.ports.ports.curr_ports.ssh;
  ips = osConfig.ips.ips.ips.default;
  curr_ports = osConfig.ports.ports.curr_ports;
  ports_noports = { default_ports ? false, user ? "root", name ? hostname
    , hostname, base_name, proxyJump ? null, localForwards ? [ ]
    , extraArgs ? { } }:
    let
      common = {
        inherit user hostname;
        port = ports.${base_name}.sshd;
      } // (if proxyJump == null then { } else { inherit proxyJump; })
        // extraArgs;
      common_ports = common // { inherit localForwards; };
    in (if hostname == null then
      { }
    else {
      "${name}_noports" = common;
      "${name}_ports" = common_ports;
      "${name}" = (if default_ports then common_ports else common);
    });

  # l = local ip
  # w = directly using wireguard
  # m = pons -> server only do this if we have a wg ip
  # g  = pons -> porta -> server
  local_global = inputs@{ default_ports ? true, user ? "root", name
    , hostname ? name, localForwards ? [ ], forward_user ? false
    , extraArgs ? { } }:
    let
      base_name = hostname;
      this_ip = ips.${hostname};
      wg_ip = if this_ip ? wg0 then this_ip.wg0 else null;
      local_ip = if this_ip ? "ens3" then
        this_ip.ens3
      else if this_ip ? "eth0" then
        this_ip.eth0
      else if this_ip ? "vmbr0" then
        this_ip.vmbr0
      else if this_ip ? "br0" && hostname != "vm-host" then
        this_ip.br0
      else if this_ip ? "enp37s0" then
        this_ip.enp37s0
      else
        null; # dont generate
      porta_prefix = if (user == "forward") then "forward_" else "";

      wg_variants = (optionalAttrs (wg_ip != null) (ports_noports {
        inherit default_ports user localForwards base_name extraArgs;
        name = "w_${name}";
        hostname = wg_ip;
      } // ports_noports {
        inherit default_ports user localForwards base_name extraArgs;
        proxyJump = "pons";
        name = "m_${name}";
        hostname = wg_ip;
      }));
      local_variants = (if local_ip != null then
        (ports_noports {
          inherit default_ports user localForwards base_name extraArgs;
          name = "l_${name}";
          hostname = local_ip;
        } // ports_noports {
          inherit default_ports user localForwards base_name extraArgs;
          proxyJump = "${porta_prefix}dea";
          name = "g_${name}";
          hostname = local_ip;
        })
      else # this is a microvm TODO add jump over the host
        { });
      forward_variants = (optionalAttrs forward_user (local_global (inputs // {
        user = "forward";
        name = "forward_${inputs.name}";
        forward_user = false;
        extraArgs = { identityFile = [ sshkeys.forward_path ]; } // extraArgs;
      })));
      plain_variant = (if wg_variants != { } then
        wg_variants."w_${name}"
      else if local_variants != { } then
        local_variants."g_${name}"
      else
        null);
      plain_variant_noports = (if wg_variants != { } then
        wg_variants."w_${name}_noports"
      else if local_variants != { } then
        local_variants."g_${name}_noports"
      else
        null);
    in wg_variants // local_variants // forward_variants
    // (optionalAttrs (plain_variant != null) {
      ${name} = plain_variant;
      "${name}_ports" = plain_variant;
    }) // optionalAttrs (plain_variant_noports != null) {
      "${name}_noports" = plain_variant_noports;
    };

in {
  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    matchBlocks = rec {
      "*".addKeysToAgent = "1h";
      "fs_main" = {
        user = "hoh47200";
        hostname = "cloud.fsim-ev.de";
      };
      "fs_main_jmp" = {
        user = "hoh47200";
        hostname = "ole.blue";
        port = 2222;
      };
      "fs_bak_jmp" = {
        user = "hannes";
        hostname = "10.24.1.2";
        proxyJump = "fs_main_jmp";
      };
      "fs_apollo_jmp" = {
        user = "hoh47200";
        hostname = "apollo";
        proxyJump = "fs_bak_jmp";
      };
      "welt" = {
        user = "root";
        port = ports.welt.sshd;
        hostname = "hannses.de";
      };
      "pons" = {
        user = "root";
        port = ports.pons.sshd;
        hostname = ips.pons.ens6;
        # hostname = "hannses.de";
      };
      "forward_pons" = {
        user = "forward";
        hostname = "hannses.de";
        port = ports.pons.sshd;
        identitiesOnly = true;
        identityFile = [ sshkeys.forward_path ];
      };
      # can not replace with local_global as different hostnames
      "l_porta" = porta_local;
      "porta_local" = {
        user = "root";
        hostname = ips.porta.ens3;
      };
      "porta" = {
        user = "root";
        hostname = ips.porta.wg0;
        proxyJump = "pons";
      };
      "forward_porta" = {
        user = "forward";
        hostname = ips.porta.wg0;
        proxyJump = "forward_pons";
        identitiesOnly = true;
        identityFile = [ sshkeys.forward_path ];
      };
      "l_thinkpad" = {
        user = "root";
        hostname = "thinkpad.fritz.box";
      };
    } // listToAttrs (flatten (map (tuple:
      attrsToList (local_global rec {
        inherit (tuple) name;
        hostname = tuple.name;
        forward_user = (elem name forwards);
        localForwards = optionals (curr_ports.ssh ? "${name}") (flatten
          (collect isList (mapAttrsRecursive (path: value: [{
            host.address = "127.0.0.1";
            host.port = getAttrFromPath path ports.${name};
            bind.port = value;
          }]) curr_ports.ssh.${name})));
      })

    ) (attrsToList
      (removeAttrs ips [ "welt" "pons" "porta" "handy_hannses" ]))));
  };
}
