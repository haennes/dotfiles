{ ... }:
{

  imports = [ ../../../modules/sys ];
  is_server = true;
  is_client = false;
  is_microvm = true;

  networking.hostName = "porta"; # Define your hostname.

  services.wireguard-wrapper.enable = true;

}
