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
  options.my.office.files.bookmarks.enable = mkEnableOption "fs bookmarks" // {
    default = config.my.office.files.enable;
  };
  imports = [ inputs.fs-bookmarks.homeManagerModules.default ];
  config = mkIf config.my.office.files.bookmarks.enable {
    fs-bookmarks = {
      enable = true;
      useToplevelShellAliases = false; # default to false
      useDirectoryStack = true;
      set = {
        shell = {
          ion = true;
          bash = true;
          fish = true;
          nushell = true;
          zsh = true;
        };
        # yazi.yamb = true;
        yazi.whoosh = true;
      };
    };
  };
}
