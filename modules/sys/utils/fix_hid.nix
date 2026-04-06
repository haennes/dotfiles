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
  options.my.utils.fix_hid.enable = mkEnableOption "fix_hid be reloading util" // {
    default = config.my.utils.enable;
  };

  config = mkIf config.my.utils.fix_hid.enable {
    environment.systemPackages =
      let
        modprobe = lib.getExe' pkgs.kmod "modprobe";
      in
      [
        (pkgs.writeShellScriptBin "fix_hid" ''
          ${modprobe} -r hid_multitouch
          ${modprobe} hid_multitouch
        '')
      ];
  };

}
