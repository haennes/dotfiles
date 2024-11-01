{
  age_obtain_wireguard_priv = { hostname, interface ? "wg0", ... }: {

    age.secrets.${"wireguard_${hostname}_${interface}_private"} = {
      file = ../${"secrets/wireguard/${hostname}/${interface}/priv.age"};
      owner = "root";
      group = "root";
    };
  };
  obtain_wireguard_pub =
    { hostname, interface ? "wg0", base_folder ? "secrets/wireguard", ... }: {
      key =
        (import ../${"${base_folder}/${hostname}/${interface}/pub.nix"}).key;
    };

  age_generate_wireguard_keypair = { hostname, publicKeys, interface ? "wg0"
    , base_folder ? "wireguard", ... }: {
      "${base_folder}/${hostname}/${interface}/priv.age".publicKeys =
        publicKeys;
    };

}
