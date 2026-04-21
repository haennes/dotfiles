{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.my.utils.rg.enable = lib.mkEnableOption "pdf utils" // {
    default = config.my.utils.enable;
  };
  config = lib.mkIf config.my.utils.rg.enable {
    environment.systemPackages = with pkgs; [
      ripgrep-all
      ripgrep
    ];
  };
}
