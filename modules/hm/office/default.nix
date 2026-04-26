{ lib, osConfig, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.my.office.enable = mkEnableOption "office" // {
    default = osConfig.is_client;
  };
  import = [
    ./files
  ];
}
