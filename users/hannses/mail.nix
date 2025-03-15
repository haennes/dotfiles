{ lib, config, ... }@inputs:
let
  inherit (lib.attrsets) mapAttrs removeAttrs;
  inherit (lib) listToAttrs genList;
  mainProfile = "mainProfile";
  enableThunderbirdForMailbox = {
    thunderbird.enable = true;
    thunderbird.profiles = [ mainProfile ];
  };
  rawMailboxes = import ../../secrets/not_so_secret/mail.nix inputs;
  mailboxesWithThunderbird = mapAttrs
    (n: v: (removeAttrs v [ "ldap_domain" ]) // enableThunderbirdForMailbox)
    rawMailboxes;
  homeDir = config.home.homeDirectory;
in {
  programs.thunderbird = {
    enable = true;
    profiles.${mainProfile}.isDefault = true;
  };
}
