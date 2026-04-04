{ lib, config, ... }:
let
  inherit (lib) mergeAttrsList map;
  inherit (lib.my) ageObtainUserPassword genUser;
  obtain_user_passwords = names: mergeAttrsList (map (name: ageObtainUserPassword name config) names);
in
{
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
