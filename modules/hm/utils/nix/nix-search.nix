{
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.utils.nix.nix-search.enable = mkEnableOption "nix-search" // {
    default = config.my.utils.nix.enable;
  };
  imports = [ inputs.nix-search-tv.homeManagerModules.nixpkgs-sh ];
  config = mkIf config.my.utils.nix.nix-search.enable {
    programs.nix-search-tv = {
      enable = true;
      enableTelevisionIntegration = true;
    };
    programs.nix-search-tv-script = {
      enable = true;
      settings = {
        indexes = {
          real = {
            "nixpkgs" = "ctrl-j";
            "home-manager" = "ctrl-h";
          };
          pseudo = {
            "all" = "ctrl-a";
          };
        };
        keys = {
          searchSnippet = "ctrl-g";
          openSource = "ctrl-s";
          openHomepage = "ctrl-o";
          nixShell = "ctrl-t";
          printPreview = "ctrl-d";
        };
        noogleEnable = true;
      };
    };
  };
}
