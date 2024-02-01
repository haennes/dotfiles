{config, pkgs, ...}:
let
  secrets = import ../../lib{};
in
{
  users.users = {
    mum_dad = {
      isNormalUser = true;
      description = "Eltern";
    };
    hannses = {
      isNormalUser = true;
      description = "hannses";
      extraGroups = [ "networkmanager" "wheel" ];
      
    };
  };
  hardware.bluetooth.enable = true;


  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;
  #services.pipewire = {
  #  enable = true;
  #  alsa.enable = true;
  #  alsa.support32Bit = true;
  #};

} // (secrets.age_obtain_user_password "hannses")
// (secrets.age_obtain_user_password "mum_dad")
