{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.office.dictionaries.enable = mkEnableOption "dictionaries" // {
    default = config.is_client;
  };

  config = mkIf config.my.office.dictionaries.enable {
    environment.systemPackages = with pkgs; [
      hunspell
      hunspellDicts.de_DE
      hunspellDicts.en_US
    ];
  };
}
