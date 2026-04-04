{ ... }:
{
  ageWireguardPrivDef =
    {
      hostname,
      interface ? "wg0",
      ...
    }:
    {

      secrets.${"wireguard_${hostname}_${interface}_private"} = {
        file = ../${"secrets/wireguard/${hostname}/${interface}/priv.age"};
        owner = "root";
        group = "root";
      };
    };
  obtainWireguardPub =
    {
      hostname,
      interface ? "wg0",
      base_folder ? "secrets/wireguard",
      ...
    }:
    {
      key = (import ../${"${base_folder}/${hostname}/${interface}/pub.nix"}).key;
    };

}
