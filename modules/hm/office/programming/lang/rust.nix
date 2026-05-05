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
  options.my.office.programming.lang.rust.enable = mkEnableOption "rust" // {
    default = config.my.office.programming.lang.enable;
  };
  config = mkIf config.my.office.programming.lang.rust.enable {
    home.packages = with pkgs; [
      rust-analyzer
      # TODO move system wide here
      # rust-bin.nightly.latest.default
      # # cargo-generate
    ];
  };
}
