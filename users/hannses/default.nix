{ config, osConfig, lib, pkgs, permit_pkgs, addons, nixvim, nixpkgs-unstable
, overlays, inputs, ... }: {
  imports = [
    ./wpaperd.nix
    ./fonts.nix
    ./gnome_config.nix
    ./hyprland.nix
    ./gtk.nix # (hopefully) just dark mode
    ./mime.nix # setup default programs
    ./waybar.nix
    ./cliphist.nix
    ./zsh.nix
    ./atuin.nix
    ./dunst.nix
    ./rofi.nix
    ./pqiv.nix # images
    #update broke ./vimiv.nix # images
    ./vim.nix
    ./yazi
    ./firefox
    ./ssh.nix
    ./virtualization.nix
    ./newsboat.nix
    #./manix.nix
    #(import ./firefox.nix{pkgs=pkgs; config=config; addons=addons;})
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "hannses";
  home.homeDirectory = "/home/hannses";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  nixpkgs.overlays = overlays;

  home.packages = with pkgs; [
    permit_pkgs.update-apply-cycle
    permit_pkgs.signal-whisper-large-v3-q5_0
    vim
    gdb
    keepassxc
    git-crypt # should be obsolete
    gnupg
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
    jetbrains.clion # fix debugging c in vim at some point
    #    anki
    #    texmaker
    musescore
    yubikey-manager-qt
    lorien
    platformio
    rust-analyzer
    gitui
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
    lemurs # TODO fix
    ripdrag

    fend
    gnomeExtensions.dash-to-dock
    gnomeExtensions.user-themes
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      mkhl.direnv
      #matklad.rust-analyzer
      #rust-lang.rust-analyzer
      serayuzgur.crates
      tamasfe.even-better-toml
      usernamehw.errorlens
      gruntfuggly.todo-tree
      asvetliakov.vscode-neovim
    ];
  };
  programs.zathura.enable = true;
  programs.helix = {
    enable = true;
    #defaultEditor = true; # leave nvim for now
    languages = {
      language-server = {
        rust-analyzer = {
          config.check.command = "clippy";
          command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        };
        nil = { command = "${pkgs.nil}/bin/nil"; };
        ruff-lsp.command = "${pkgs.ruff}/bin/ruff";
      };
      language = [
        {
          name = "rust";
          auto-format = true;
        }
        {
          name = "nix";
          formatter = { command = "nixpkgs-fmt"; };
          auto-format = true;
        }
        {
          name = "python";
          language-servers = [ "ruff-lsp" ];

          # In case you'd like to use ruff alongside black for code formatting:
          formatter = {
            command = "black";
            args = [ "--quiet" "-" ];
          };
          auto-format = true;
        }
      ];
    };
  };
  # Environment
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "haennes";
    userEmail = "hannes.hofmuth@gmail.com";
    signing = {
      key = null;
      signByDefault = true;
    };
    extraConfig = {
      init = { defaultBranch = "main"; };
      push.autoSetupRemote = true;
    };
  };

  services.udiskie.enable = osConfig.services.udisks2.enable;
  #programs.gitui.enable = true; #conflicts with following line
  home.file.".config/gitui/key_bindings.ron".text =
    builtins.readFile ../../ext_configs/gitui_keybindings.ron;
  home.file.".config/iamb/config.json".text =
    builtins.readFile ../../ext_configs/iamb/config.json;

  programs.starship.enable = true;
  xdg.desktopEntries.zellij = {
    name = "ZelliJ";
    genericName = "Terminal";
    exec = "alacritty -e zellij";
    icon = ../../ext_configs/icons/zellij.ico;
    terminal = false;
  };

  programs.gpg = { enable = true; };
  services.gpg-agent = {
    pinentryPackage = pkgs.pinentry-tty;
    enable = true;
  };
}
