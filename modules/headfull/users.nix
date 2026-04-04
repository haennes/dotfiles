{ lib, config, ... }:
let
  inherit (lib) mergeAttrsList map;
  inherit (lib.my) ageObtainUserPassword genUser;
  obtain_user_passwords = names: mergeAttrsList (map (name: ageObtainUserPassword name config) names);
in
{
  users.users = {
    "hannses" = {
      isNormalUser = true;
      description = "hannses";
      extraGroups = [
        # keep-sorted start sticky_comments=no block=yes
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
  // (genUser "mum")
  // (genUser "dad");

  users.extraGroups.vboxusers.members = [ "hannses" ];
  users.groups = {
    "family".members = [
      # keep-sorted start sticky_comments=no block=yes
      "dad"
      "hannses"
      "mum"
      # keep-sorted end
    ];
  };
}
// (obtain_user_passwords [
  # keep-sorted start sticky_comments=no block=yes
  "dad"
  "hannses"
  "mum"
  # keep-sorted end
])
