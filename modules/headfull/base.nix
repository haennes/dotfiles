{ lib, config, pkgs, ... }:
let
  gen_user = name: {
    "${name}" = {
      isNormalUser = true;
      description = name;
      home = "/home/${name}";
    };
  };
in {
  users.users = {
    "hannses" = {
      isNormalUser = true;
      description = "hannses";
      extraGroups =
        [ "networkmanager" "wheel" "family" "video" "libvirtd" "docker" ];
    };
  } // (gen_user "mum") // (gen_user "dad");

  users.extraGroups.vboxusers.members = [ "hannses" ];
  users.groups = { "family".members = [ "mum" "dad" "hannses" ]; };
  hardware.bluetooth.enable = true;
  networking.networkmanager.enable = true;

  security.pam.services.swaylock = { };
  boot.kernelPackages =
    if (lib.any (v: v.fsType == "zfs") (lib.attrValues config.fileSystems)) then
      config.boot.zfs.package.latestCompatibleLinuxPackages
    else
      pkgs.linuxPackages_latest;
  # Enable sound with pipewire.
  hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;
  services.logind.powerKey = "suspend";
  services.pipewire = {
    enable = false;
    #  pulse.enable = true;
    #  jack.enable = true;
    #  alsa.enable = true;
    #  alsa.support32Bit = true;
  };

  services.udisks2.enable = true;
  programs.hyprland.enable = true;

} // (lib.my.age_obtain_user_password "hannses" config)
// (lib.my.age_obtain_user_password "mum" config)
// (lib.my.age_obtain_user_password "dad" config)
