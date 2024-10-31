{ lib, ... }:
let
  inherit (lib.attrsets) mapAttrs removeAttrs;
  mainProfile = "mainProfile";
  enableThunderbirdForMailbox = {
    thunderbird.enable = true;
    thunderbird.profiles = [ mainProfile ];
  };
  rawMailboxes = import ../../secrets/not_so_secret/mail.nix;
  mailboxesWithThunderbird = mapAttrs
    (n: v: (removeAttrs v [ "ldap_domain" ]) // enableThunderbirdForMailbox)
    rawMailboxes;
in {
  accounts.email.accounts = mailboxesWithThunderbird;
  #https://rzwww.oth-regensburg.de/supportwiki/doku.php?id=public:email:exchange:thunderbirduser#adressbuch
  #https://wiki.mozilla.org/Thunderbird:Help_Documentation:Connecting_to_an_LDAP_address_book
  programs.thunderbird = {
    enable = true;
    settings = let
      ldap_server = "OTHExchange";
      user_id = rawMailboxes.oth.userName;
      ldap_domain = rawMailboxes.oth.ldap_domain;
    in {
      "privacy.donottrackheader.enabled" = true;
      "ldap_2.autoComplete.directoryServer" = "ldap_2.servers.${ldap_server}";
      "ldap_2.autoComplete.useDirectory" = true;
      "ldap_2.servers.${ldap_server}.auth.dn" = "${user_id}@${ldap_domain}";
      "ldap_2.servers.${ldap_server}.description" = ldap_server;
      "ldap_2.servers.${ldap_server}.maxHits" = 1000;
      "ldap_2.servers.${ldap_server}.uri" =
        "ldap://localhost:1389/ou=people??sub?(objectclass=*)";

    };
    profiles.${mainProfile}.isDefault = true;
  };
}
