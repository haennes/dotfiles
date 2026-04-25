{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.utils.tldr.enable = mkEnableOption "tldr" // {
    default = config.my.utils.enable;
  };
  config = mkIf config.my.utils.tldr.enable {
    environment.systemPackages = with pkgs; [
      tldr
    ];
  };

}
