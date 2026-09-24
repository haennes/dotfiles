{ lib, config, ... }@inputs:
let
  inherit (lib.attrsets) mapAttrs removeAttrs;
  inherit (lib)
    optional
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
  options.my.office.comms.mail = {
    enable = mkEnableOption "email" // {
      default = config.my.office.comms.enable;
    };
    autostart = {
      enable = mkEnableOption "autostart" // {
        default = true;
      };
    };
  };
  config = mkIf config.my.office.comms.mail.enable {
    programs.thunderbird = {
      enable = true;
      profiles.${mainProfile}.isDefault = true;
    };
    my.office.comms.specialWorkspace.autostart.autostart = (
      optional config.my.office.comms.mail.autostart.enable config.programs.thunderbird.package
    );
  };
}
