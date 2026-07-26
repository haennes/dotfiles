{lib, ...}:
let
  inherit (lib) mkOption types;
in
{
  options.my.desktop.monitors.builtin = mkOption {
    type = types.str;
  };
}
