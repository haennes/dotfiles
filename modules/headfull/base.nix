{ config, pkgs, ... }:
let
  secrets = import ../../lib { };
  gen_user = name: {
    "${name}" = {
      isNormalUser = true;
      description = name;
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

  security.pam.services.swaylock = { };

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

  programs.hyprland.enable = true;

} // (secrets.age_obtain_user_password "hannses")
// (secrets.age_obtain_user_password "mum")
// (secrets.age_obtain_user_password "dad")
