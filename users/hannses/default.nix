{ config, osConfig, lib, pkgs, inputs, ... }: {
  imports = [
    ./wpaperd.nix
    ./fonts.nix
    ./gnome_config.nix
    ./hyprland.nix
    ./idle.nix
    ./gtk.nix # (hopefully) just dark mode
    ./mime.nix # setup default programs
    ./waybar.nix
    ./cliphist.nix
    ./zsh.nix
    ./carapace.nix
    ./atuin.nix
    ./dunst.nix
    ./rofi.nix
    ./pqiv.nix # images
    ./udiskie.nix
    ./power.nix
    #update broke ./vimiv.nix # images
    ./codium.nix
    ./vim.nix
    ./helix.nix
    ./yazi.nix
    ./zathura.nix
    ./firefox
    ./rss.nix
    ./mail.nix
    ./ssh.nix
    ./git.nix
    ./gpg.nix
    ./virtualization.nix
    ./manix.nix
    ./kitty.nix
    ./nix.nix
    ./tmux.nix
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
    update-apply-cycle
    signal-whisper-large-v3-q5_0
    vim
    gdb
    nix-diff
    icdiff
    inputs.nix-inspect.packages.${system}.default
    keepassxc
    signal-desktop
    scli # signal tui FIXME replace with gurk-rs as soon as upstream fixed
    signal-cli
    dconf-editor
    poppler_utils
    pdftk
    diff-pdf
    shortwave
    anki
    fritzing
    fontforge-gtk
    lapce
    #jetbrains.clion # fix debugging c in vim at some point
    musescore
    lorien
    platformio
    rust-analyzer
    feh # for dticket cmd
    iamb
    element-desktop
    openai-whisper-cpp
    ffmpeg

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
  ];

  # Environment
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };

  #programs.gitui.enable = true; #conflicts with following line
  home.file.".config/gitui/key_bindings.ron".text =
    builtins.readFile ../../ext_configs/gitui_keybindings.ron;
  home.file.".config/iamb/config.json".text =
    builtins.readFile ../../ext_configs/iamb/config.json;

  xdg.desktopEntries.zellij = {
    name = "ZelliJ";
    genericName = "Terminal";
    exec = "alacritty -e zellij";
    icon = ../../ext_configs/icons/zellij.ico;
    terminal = false;
  };
}
