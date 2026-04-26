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
    ./anki.nix
    ./atuin.nix
    ./bookmarks.nix
    ./carapace.nix
    ./cliphist.nix
    ./codium.nix
    ./direnv.nix
    ./firefox
    ./git.nix
    ./gnome_config.nix
    ./helix.nix
    ./kitty.nix
    ./mail.nix
    ./mime.nix # setup default programs
    ./pqiv.nix # images
    ./shell.nix
    ./ssh.nix
    ./starship.nix
    ./tasks.nix
    ./television.nix
    ./tmux.nix
    ./vim.nix
    ./virtualization.nix
    ./wezterm.nix
    ./zathura.nix
    ./zoxide.nix
    ./zsh.nix
    # keep-sorted end
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "hannses";
  home.homeDirectory = lib.mkDefault "/home/hannses";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    comma
    kdePackages.kcachegrind
    # signal-whisper-large-v3-q5_0
    vim
    gdb
    signal-desktop
    scli # signal tui FIXME replace with gurk-rs as soon as upstream fixed
    signal-cli
    shortwave
    inputs.typ2anki.packages.${system}.default
    license-cli # license texts on the command line
    #fritzing
    lapce
    #jetbrains.clion # fix debugging c in vim at some point
    musescore
    lorien
    platformio
    rust-analyzer
    feh # for dticket cmd
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

    fend
    glow
    portfolio
  ];

  # Environment
  home.sessionVariables = {
    EDITOR = "hx";
    BROWSER = "firefox";
    TERMINAL = "wezterm";
  };
}
