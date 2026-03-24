{
  lib,
  pkgs,
  inputs,
  scripts,
  ...
}:
{
  imports = [
    # keep-sorted start
    ./atuin.nix
    ./bookmarks.nix
    ./btop.nix
    ./carapace.nix
    ./cliphist.nix
    #update broke ./vimiv.nix # images
    ./codium.nix
    ./direnv.nix
    ./dunst.nix
    ./firefox
    ./fonts.nix
    ./git.nix
    ./gnome_config.nix
    ./gpg.nix
    ./gtk.nix # (hopefully) just dark mode
    ./helix.nix
    ./hyprland.nix
    ./hyprpaper.nix
    ./idle.nix
    ./kitty.nix
    ./mail.nix
    ./mime.nix # setup default programs
    ./nix-search.nix
    ./nix.nix
    ./power.nix
    ./pqiv.nix # images
    ./rofi.nix
    ./rss.nix
    ./shell.nix
    ./ssh.nix
    ./starship.nix
    ./tasks.nix
    ./television.nix
    ./tmux.nix
    ./udiskie.nix
    ./vicinae.nix
    ./vim.nix
    ./virtualization.nix
    ./waybar.nix
    ./wezterm.nix
    ./yazi.nix
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
    update-apply-cycle
    # signal-whisper-large-v3-q5_0
    vim
    gdb
    nix-diff
    nix-tree
    icdiff
    inputs.nix-inspect.packages.${system}.default
    keepassxc
    signal-desktop
    scli # signal tui FIXME replace with gurk-rs as soon as upstream fixed
    signal-cli
    dconf-editor
    poppler-utils
    pdftk
    diff-pdf
    shortwave
    anki
    inputs.typ2anki.packages.${system}.default
    license-cli # license texts on the command line
    #fritzing
    fontforge-gtk
    lapce
    #jetbrains.clion # fix debugging c in vim at some point
    musescore
    lorien
    platformio
    rust-analyzer
    feh # for dticket cmd
    element-desktop
    # openai-whisper-cpp
    ffmpeg
    sqlite

    # doesnt work atm
    #sweet

    xdg-desktop-portal-hyprland # maybe replace with home manager (not hyprland)
    wl-clipboard
    playerctl
    libnotify
    pavucontrol

    # DESKTOP ENV PROGRAMS
    grim
    grimblast
    slurp
    swww
    wlr-randr
    wdisplays # gui display positioning
    swaylock-effects
    #swaynotificationcenter
    #lemurs # TODO fix
    ripdrag

    fend
    glow
    portfolio
    scripts.disable_ext_monitors
  ];

  # Environment
  home.sessionVariables = {
    EDITOR = "hx";
    BROWSER = "firefox";
    TERMINAL = "wezterm";
  };

  #programs.gitui.enable = true; #conflicts with following line
  home.file.".config/gitui/key_bindings.ron".source = ../../ext_configs/gitui_keybindings.ron;

  xdg.desktopEntries.zellij = {
    name = "ZelliJ";
    genericName = "Terminal";
    exec = "alacritty -e zellij";
    icon = ../../ext_configs/icons/zellij.ico;
    terminal = false;
  };
}
