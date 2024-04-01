{config, pkgs, ...}:
let
  secrets = import ../../lib{};
  gen_user = name: {
    "${name}" = { isNormalUser = true; description = name;};
  };
in
{
  users.users = 
    {
      "hannses" = {
        isNormalUser = true;
	description = "hannses";
	extraGroups = [ "networkmanager" "wheel" "family"];
      };
    }
    //(gen_user "mum")
    //(gen_user "dad");

  users.groups = {
    "family".members = ["mum" "dad" "hannses"];
  };
  hardware.bluetooth.enable = true;


  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;
  #services.pipewire = {
  #  enable = true;
  #  pulse.enable = true;
  #  jack.enable = true;
  #  alsa.enable = true;
  #  alsa.support32Bit = true;
  #};

} // (secrets.age_obtain_user_password "hannses")
// (secrets.age_obtain_user_password "mum")
// (secrets.age_obtain_user_password "dad")
