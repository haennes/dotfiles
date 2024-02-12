# IMPORTANT
# always add ROOT SSH-keys to the secrets. wireguard cant decrypt it otherwise
let 
  sshkeys = import ./sshkeys.nix ;
  users = with sshkeys; [ hannses restic ];
  syncthing_users = with sshkeys; [hannses root_thinkpad syncschlawiner root_syncschlawiner root_tabula tabula];


  systems = with sshkeys; [ thinkpad ];
 age_generate_wireguard_keypair = {hostname, publicKeys, interface ? "wg0", base_folder ? "wireguard", ...}:{
    "${base_folder}/${hostname}/${interface}/priv.age".publicKeys = publicKeys;
    #"${base_folder}/${hostname}/${interface}/pub.age".publicKeys = publicKeys;
    #	wireguard.${hostname}.${interface}.pub = import "${base_folder}/${hostname}/${interface}/pub.nix".key;
  };
 age_generate_syncthing_keypair = {hostname, publicKeys}:{
   "syncthing/${hostname}/id.age".publicKeys = syncthing_users;
   "syncthing/${hostname}/key.age".publicKeys = publicKeys;
   "syncthing/${hostname}/cert.age".publicKeys = publicKeys;
   "syncthing/${hostname}/https-cert.age".publicKeys = publicKeys;
   "syncthing/${hostname}/https-key.age".publicKeys = publicKeys;
 };
 age_generate_user_password = {username, publicKeys}:{
   "user_passwords/${username}.age".publicKeys = publicKeys;
 };
in
with sshkeys; 
{
  #publicKeys is an OR-List -> either key is enough to decrypt it

  "restic_passwords".publicKeys = [ hannses restic ];

  "nextcloud/adminpass.age".publicKeys = [hannses syncschlawiner root_syncschlawiner];
  "nextcloud_mkhh/adminpass.age".publicKeys = [hannses syncschlawiner_mkhh root_syncschlawiner_mkhh];

  "kehl_login.age".publicKeys = [hannses welt root_welt root_tabula tabula];
}
// age_generate_wireguard_keypair{hostname = "mainpc"; publicKeys = [hannses mainpc];} 
// age_generate_wireguard_keypair{hostname = "thinkpad"; publicKeys = [hannses thinkpad root_thinkpad ];} 
// age_generate_wireguard_keypair{hostname = "porta"; publicKeys = [hannses porta root_porta];} 
// age_generate_wireguard_keypair{hostname = "welt"; publicKeys = [hannses welt root_welt];} 
// age_generate_wireguard_keypair{hostname = "syncschlawiner"; publicKeys = [hannses syncschlawiner root_syncschlawiner];} 
// age_generate_wireguard_keypair{hostname = "syncschlawiner_mkhh"; publicKeys = [hannses syncschlawiner_mkhh root_syncschlawiner_mkhh];} 
// age_generate_wireguard_keypair{hostname = "tabula"; publicKeys = [hannses tabula root_tabula];} 

// age_generate_syncthing_keypair{hostname = "thinkpad"; publicKeys = [hannses thinkpad root_thinkpad];}
// age_generate_syncthing_keypair{hostname = "syncschlawiner"; publicKeys = [hannses root_thinkpad syncschlawiner root_syncschlawiner];}
// age_generate_syncthing_keypair{hostname = "tabula"; publicKeys = [hannses root_tabula tabula];}
// age_generate_syncthing_keypair{hostname = "mainpc"; publicKeys = [hannses root_mainpc mainpc];}

// age_generate_user_password{username = "hannses"; publicKeys = [hannses thinkpad mainpc];}
// age_generate_user_password{username = "mum"; publicKeys = [hannses thinkpad mainpc];}
// age_generate_user_password{username = "dad"; publicKeys = [hannses thinkpad mainpc];}
