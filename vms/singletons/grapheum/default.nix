{ ... }:
{
  imports = [ ../../../modules/sys ];

  is_server = true;
  is_client = false;
  is_microvm = true;

  services.onlyoffice.enable = true;

  networking.hostName = "grapheum"; # Define your hostname.
  networking.firewall.allowedTCPPorts = [
    22
    8000
  ];
}
