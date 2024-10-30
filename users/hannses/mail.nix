{ lib, ... }:
let
  inherit (lib.attrsets) mapAttrs;
  mainProfile = "mainProfile";
  enableThunderbirdForMailbox = {
    thunderbird.enable = true;
    thunderbird.profiles = [ mainProfile ];
  };
  rawMailboxes = import ../../secrets/not_so_secret/mail.nix;
  mailboxesWithThunderbird =
    mapAttrs (n: v: v // enableThunderbirdForMailbox) rawMailboxes;
in {
  accounts.email.accounts = mailboxesWithThunderbird;

  programs.thunderbird = {
    enable = true;
    settings = { "privacy.donottrackheader.enabled" = true; };
    profiles.${mainProfile}.isDefault = true;
  };
}
