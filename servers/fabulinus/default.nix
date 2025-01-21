{ pkgs, config, inputs, ... }: {
  imports = [ inputs.esw-machines.nixosModules.default ];
  users.users.root.initialPassword = "root";
  networking = {
    hostName = "fabulinus";
    useDHCP = false;
    interfaces = {
      wlan0.useDHCP = true;
      eth0.useDHCP = true;
    };
  };
  raspberry-pi-nix.board = "bcm2711";
  hardware = {
    raspberry-pi = {
      config = {
        all = {
          base-dt-params = {
            BOOT_UART = {
              value = 1;
              enable = true;
            };
            uart_2ndstage = {
              value = 1;
              enable = true;
            };
          };
          dt-overlays = {
            disable-bt = {
              enable = true;
              params = { };
            };
          };
        };
      };
    };
  };
  #hardware.raspberry-pi."4".fkms-3d.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.wireguard-wrapper.enable = true;

  users.users.${config.services.cage.user}.isNormalUser = true;

  services.cage = {
    enable = true;
    program = "${pkgs.firefox}/bin/firefox --kiosk http://ecosia.org";
    #program = "${pkgs.alacritty}/bin/alacritty";
    user = "fabulinus";
  };

  # wait for network and DNS
  systemd.services."cage-tty1".after =
    [ "network-online.target" "systemd-resolved.service" ];

  networking.firewall.allowedTCPPorts = [ config.ports.ports.curr_ports.esw ];

  services.syncthing_wrapper = { enable = true; };

  services.esw-machines = {
    enable = true;
    port = config.ports.ports.curr_ports.esw;
    domain = "0.0.0.0";
    user = config.services.syncthing.user;
    dataFilePath =
      "${config.services.syncthing.settings.folders.esw-machines.path}/esw";
  };
}
