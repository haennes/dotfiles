{pkgs, ...}:{
  environment.systemPackages = with pkgs; [
    nix-output-monitor
    nixfmt
    nil
    neofetch
    home-manager
    restic
    ripgrep-all
    fd
    eza
    lf
    nmap
    #TODO remove this after using syncthingd
    syncthing
    wget
    zellij

    arduino
    arduinoOTA

    git
    sshfs
    deploy-rs
    wireguard-tools
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    #  dont set default editor here as we may want to use helix
  };
}
