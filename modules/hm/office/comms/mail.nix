{ lib, config, ... }@inputs:
let
  inherit (lib.attrsets) mapAttrs removeAttrs;
  inherit (lib)
    listToAttrs
    genList
    mkEnableOption
    mkIf
    ;
  mainProfile = "mainProfile";
  enableThunderbirdForMailbox = {
    thunderbird.enable = true;
    thunderbird.profiles = [ mainProfile ];
  };
  rawMailboxes = import ../../secrets/not_so_secret/mail.nix inputs;
  mailboxesWithThunderbird = mapAttrs (
    n: v: (removeAttrs v [ "ldap_domain" ]) // enableThunderbirdForMailbox
  ) rawMailboxes;
  homeDir = config.home.homeDirectory;
in
{
  options.my.office.comms.mail.enable = mkEnableOption "email" // {
    default = config.my.office.comms.enable;
  };
  config = mkIf config.my.office.comms.mail.enable {
    programs.thunderbird = {
      enable = true;
      profiles.${mainProfile}.isDefault = true;
    };
  };
}
