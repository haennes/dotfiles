{ lib, ... }:
{
  ipCIDR = ip: "${ip}/32";
  subnetCIDR =
    ip:
    let
      inherit (lib) concatStringsSep take splitString;
      __subnet = ip: (concatStringsSep "." (take 3 (splitString "." ip)));
      subnet = (__subnet ip);
    in
    "${subnet}.0/24";
}
