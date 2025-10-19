{ pkgs, config, inputs, ... }: {
  imports = [
    inputs.esw-machines.nixosModules.default
    ./wifi.nix
    ./hardware-configuration.nix
  ];
  users.users.root.initialPassword = "root";
  networking = {
    hostName = "fabulinus";
    useDHCP = false;
    interfaces = {
      wlan0.useDHCP = true;
      eth0.useDHCP = true;
    };
  };
  boot.initrd.availableKernelModules =
    [ "nvme" "pcie-brcmstb" "usbhid" "usb_storage" "vc4" ];
  networking.networkmanager.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.wireguard-wrapper.enable = true;

  users.users.${config.services.cage.user}.isNormalUser = true;

  # services.cage = {
  #   enable = true;
  #   program = "${pkgs.firefox}/bin/firefox --kiosk http://ecosia.org";
  #   user = "fabulinus";
  # };

  # wait for network and DNS
  # systemd.services."cage-tty1".after =
  #   [ "network-online.target" "systemd-resolved.service" ];

  networking.firewall.allowedTCPPorts = [ config.ports.ports.curr_ports.esw ];

  services.syncthing-wrapper = { enable = true; };

  services.esw-machines = {
    enable = true;
    port = config.ports.ports.curr_ports.esw;
    domain = "0.0.0.0";
    user = config.services.syncthing.user;
    dataFilePath = "${
        config.services.syncthing.settings.folders."esw-machine__esw-machines".path
      }/esw";
  };
}
