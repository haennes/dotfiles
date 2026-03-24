{ lib, config, ... }:
let
  inherit (lib) mergeAttrsList map;
  inherit (lib.my) age_obtain_user_password;
  obtain_user_passwords =
    names: mergeAttrsList (map (name: age_obtain_user_password name config) names);
  gen_user = name: {
    "${name}" = {
      isNormalUser = true;
      description = name;
      home = "/home/${name}";
    };
  };
in
{
  users.users = {
    "hannses" = {
      isNormalUser = true;
      description = "hannses";
      extraGroups = [
        # keep-sorted start
        "docker"
        "family"
        "libvirtd"
        "networkmanager"
        "video"
        "wheel"
        # keep-sorted end
      ];
    };
  }
  // (gen_user "mum")
  // (gen_user "dad");

  users.extraGroups.vboxusers.members = [ "hannses" ];
  users.groups = {
    "family".members = [
      # keep-sorted start
      "dad"
      "hannses"
      "mum"
      # keep-sorted end
    ];
  };
}
// (obtain_user_passwords [
  # keep-sorted start
  "dad"
  "hannses"
  "mum"
  # keep-sorted end
])
