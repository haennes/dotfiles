{ config, pkgs, addons, nixvim, nixpkgs-unstable, ... }:
{
  imports = [
    ./gnome_config.nix
    ./zsh.nix
    ./vim.nix
    ./firefox.nix
    ./ssh.nix
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


  home.packages = with pkgs; [
    vim
    keepassxc
    git-crypt #should be obsolete
    gnupg
    vscodium
    signal-desktop
    gnome.dconf-editor
    poppler_utils
    shortwave
    anki
    fritzing
    fontforge-gtk
    lapce
#    anki
#    texmaker
    musescore
    yubikey-manager-qt
    prismlauncher-qt5
    lorien
    platformio
    rust-analyzer
    gitui
    feh #for dticket cmd
    iamb
    element-desktop

    # doesnt work atm
    #sweet


    gnomeExtensions.dash-to-dock
    gnomeExtensions.user-themes
  ];

  programs.vscode = {
    enable = true;
  package = pkgs.vscodium;
  extensions = with pkgs.vscode-extensions; [
    mkhl.direnv
    matklad.rust-analyzer
    serayuzgur.crates
    tamasfe.even-better-toml
    usernamehw.errorlens
    gruntfuggly.todo-tree
  ];
  };
  programs.helix = {
     enable = true;
     #defaultEditor = true; # leave nvim for now
     languages = {
         language-server = {
	    rust-analyzer = {
                config.check.command = "clippy";
		command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
	    };
	    nil = {
	        command = "${pkgs.nil}/bin/nil";
	    };
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
                 formatter = { command = "black"; args = ["--quiet" "-"]; };
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
    userName = "hannses";
    userEmail = "example.com";
  };
  #programs.gitui.enable = true; #conflicts with following line
  home.file.".config/gitui/key_bindings.ron".text = builtins.readFile ../../ext_configs/gitui_keybindings.ron;
  home.file.".config/iamb/config.json".text = builtins.readFile ../../ext_configs/iamb/config.json;
     
  programs.starship.enable = true;
  xdg.desktopEntries.zellij = {
     name = "ZelliJ";
     genericName = "Terminal";
     exec = "alacritty -e zellij";
     terminal = false;
  };
  home.file.".face".source = ./.face;
  home.file = {
    ".config/autostart/com.nextcloud.desktopclient.nextcloud.desktop" = {text = ''
      [Desktop Entry]
      Name=Nextcloud
      GenericName=File Synchronizer
      Exec=nextcloud --background
      Terminal=false
      Icon=Nextcloud
      Categories=Network
      Type=Application
      StartupNotify=false
      X-GNOME-Autostart-enabled=true
      X-GNOME-Autostart-Delay=10
    '';
    force = true;
    };
  };

  #programs.gpg = {
    #enable = true;
#};
  #services.gpg-agent = {
    #enable = true;
#};
}
