{ inputs, pkgs, lib, config, sshkeys, all_modules, ... }:
let
  hports = config.ports.ports.curr_ports;
  ips = config.ips.ips.ips.default;
  user_group = config.services.freshrss.user;
  dataDir = "/persist/minecraft";
in {

  imports = [
    ../../../modules/microvm_guest.nix
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  services.wireguard-wrapper.enable = true;

  networking.hostName = "ludus";

  networking.firewall.allowedTCPPorts = [ 443 80 ];
  networking.firewall.interfaces.wg1.allowedTCPPorts = [ 25565 ];
  networking.firewall.interfaces.wg1.allowedUDPPorts = [ 25565 ];
  networking.firewall.interfaces.wg0.allowedTCPPorts = [ 25565 ];
  networking.firewall.interfaces.wg0.allowedUDPPorts = [ 25565 ];

  microvm.shares = [{
    source = "/minecraft";
    mountPoint = dataDir;
    tag = "git-${config.networking.hostName}";
    proto = "virtiofs";
  }];
  microvm.mem = 6000;
  microvm.vcpu = 4;
  services.minecraft-servers = {
    enable = true;
    eula = true;
    dataDir = "/persist/minecraft";
    servers.ftb-ininity-evolved = {
      enable = true;
      package = pkgs.writeShellApplication {
        name = "start";
        text = ''
          #!/usr/bin/env sh
          exec "${pkgs.jre8}/bin/java" -jar -Dlog4j.configurationFile=.patches/log4j2_17-111.xml forge-1.7.10-10.13.4.1614-1.7.10-universal.jar \$@ nogui
        '';
      };
      jvmOpts = "-Xmx4G -Xms4G";
      managementSystem.tmux.enable = true;
    };
  };
  programs.tmux.enable = true;

}
