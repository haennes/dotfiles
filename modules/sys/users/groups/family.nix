{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkEnableOption
    intersectLists
    attrNames
    ;
in
{
  options.my.groups.family.enable = mkEnableOption "add group family" // {
    default = config.is_client;
  };
  config = mkIf config.my.groups.family.enable {
    users.groups = {
      "family".members = intersectLists (attrNames config.users.users) [
        # keep-sorted start sticky_comments=no block=yes
        "dad"
        "hannses"
        "mum"
        # keep-sorted end
      ];
    };
  };

}
