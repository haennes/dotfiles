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
  options.my.office.gaming.minecraft.enable = mkEnableOption "minecraft" // {
    default = config.my.office.gaming.enable;
  };
  config = mkIf config.my.office.gaming.minecraft.enable {
    environment = {
      systemPackages = with pkgs; [
        atlauncher # minecraft launcher with mod support
        portablemc # minecraft launcher cmd
        prismlauncher
      ];

      etc = {
        "minecraft_deps/jre8".source = pkgs.jre8.outPath;
      };
    };
  };
}
