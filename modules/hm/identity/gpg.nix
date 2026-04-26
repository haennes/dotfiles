{
  lib,
  config,
  pkgs,
  inputs,
  system,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.identity.gpg.enable = mkEnableOption "gpg" // {
    default = config.my.identity.enable;
  };
  config = mkIf config.my.identity.gpg.enable {
    home.packages = with pkgs; [ gnupg ];
    programs.gpg = {
      enable = true;
    };
    services.gpg-agent = {
      pinentry.package = inputs.pinentry-keepassxc.packages.${system}.default;
      enable = true;
    };
  };
}
