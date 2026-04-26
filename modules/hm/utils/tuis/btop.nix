{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.utils.tuis.btop.enable = mkEnableOption "btop" // {
    default = config.my.utils.tuis.enable;
  };
  config = mkIf config.my.utils.tuis.btop.enable {
    programs.btop = {
      enable = true;
      settings = {
        vim_keys = true;
        swap_disk = false;
      };
    };
  };
}
