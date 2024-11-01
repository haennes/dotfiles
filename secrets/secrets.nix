# IMPORTANT
# always add ROOT SSH-keys to the secrets. wireguard cant decrypt it otherwise
let
  sshkeys = import ./sshkeys.nix;
  users = with sshkeys; [ hannses restic ];
  syncthing_users = with sshkeys; [
    hannses
    root_thinkpad
    syncschlawiner
    root_syncschlawiner
    root_tabula
    tabula
  ];

  systems_headfull = with sshkeys; [ thinkpad yoga ];
  wg_simple = hostname: publicKeys:
    wireguard_keypair { inherit hostname publicKeys; };
  wireguard_keypair = { hostname, publicKeys, interface ? "wg0"
    , base_folder ? "wireguard", ... }: {
      "${base_folder}/${hostname}/${interface}/priv.age".publicKeys =
        publicKeys;
      #"${base_folder}/${hostname}/${interface}/pub.age".publicKeys = publicKeys;
      #	wireguard.${hostname}.${interface}.pub = import "${base_folder}/${hostname}/${interface}/pub.nix".key;
    };
  syncthing_keypair = hostname: publicKeys: {
    "syncthing/${hostname}/key.age".publicKeys = publicKeys;
    "syncthing/${hostname}/cert.age".publicKeys = publicKeys;
  };
  user_password = username: publicKeys: {
    "user_passwords/${username}.age".publicKeys = publicKeys;
  };
in with sshkeys;
{
  #publicKeys is an OR-List -> either key is enough to decrypt it

  "restic_passwords".publicKeys = [ hannses restic ];

  "nextcloud/adminpass.age".publicKeys =
    [ hannses syncschlawiner root_syncschlawiner ];
  "nextcloud_mkhh/adminpass.age".publicKeys =
    [ hannses syncschlawiner_mkhh root_syncschlawiner_mkhh ];
  "openfortivpn.age".publicKeys = systems_headfull ++ [ hannses ];

  "kehl_login.age".publicKeys = [ hannses welt root_welt root_tabula tabula ];
  "atuin/key.age".publicKeys = systems_headfull ++ [ hannses ];
  "atuin/session.age".publicKeys = systems_headfull ++ [ hannses ];
  "wifihotspot.age".publicKeys = systems_headfull ++ [ hannses ];
  "hydra/users/hannses.age".publicKeys = [ root_deus deus ];
  "ankisync/pwhannses.age".publicKeys = [ root_minerva ];

} // wg_simple "deus" [ hannses deus ]
// wg_simple "thinkpad" [ hannses thinkpad root_thinkpad ]
// wg_simple "yoga" [ hannses yoga root_yoga ]
// wg_simple "porta" [ hannses porta root_porta ]
// wg_simple "welt" [ hannses welt root_welt ]
// wg_simple "syncschlawiner" [ hannses syncschlawiner root_syncschlawiner ]
// wg_simple "syncschlawiner_mkhh" [
  hannses
  syncschlawiner_mkhh
  root_syncschlawiner_mkhh
] // wg_simple "tabula" [ hannses tabula root_tabula ]
// wg_simple "hermes" [ hannses hermes root_hermes ]
// wg_simple "historia" [ hannses root_historia ]
// wg_simple "fons" [ hannses root_fons ]
// wg_simple "minerva" [ hannses root_minerva ]
// wg_simple "vertumnus" [ hannses root_vertumnus ]

// syncthing_keypair "thinkpad" [ hannses thinkpad root_thinkpad ]
// syncthing_keypair "yoga" [ hannses yoga root_yoga ]
// syncthing_keypair "syncschlawiner" [
  hannses
  syncschlawiner
  root_syncschlawiner
] // syncthing_keypair "tabula" [ hannses root_tabula tabula ]
// syncthing_keypair "fons" [ hannses root_fons ]
// syncthing_keypair "deus" [ hannses root_deus deus ]

// user_password "hannses" [ hannses thinkpad yoga deus ]
// user_password "mum" [ hannses thinkpad yoga deus ]
// user_password "dad" [ hannses thinkpad yoga deus ]

