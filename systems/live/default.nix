{ lib, ... }: {
  networking.hostName = "live";
  networking.networkmanager.enable = lib.mkForce false;
}
