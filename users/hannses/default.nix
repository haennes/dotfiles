{
  lib,
  pkgs,
  inputs,
  scripts,
  ...
}:
{
  imports = [
    # keep-sorted start sticky_comments=no block=yes
    #update broke ./vimiv.nix # images
    ../../modules/hm/default.nix
    ./bookmarks.nix
    ./gnome_config.nix
    # keep-sorted end
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "hannses";
  home.homeDirectory = lib.mkDefault "/home/hannses";

  my.office.media.mpv.enable = false;

  home.packages = with pkgs; [
    comma
    # signal-whisper-large-v3-q5_0
    vim
    #fritzing
    lapce
    #jetbrains.clion # fix debugging c in vim at some point
    element-desktop
    # openai-whisper-cpp
    sqlite

    # doesnt work atm
    #sweet

    libnotify

    # DESKTOP ENV PROGRAMS
    #swaynotificationcenter
    #lemurs # TODO fix
    ripdrag

    glow
  ];

  # Environment
  home.sessionVariables = {
    EDITOR = "hx";
    BROWSER = "firefox";
  };
}
