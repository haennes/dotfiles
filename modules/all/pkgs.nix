{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    nix-output-monitor
    nixfmt-classic
    nil
    neofetch
    home-manager
    restic
    ripgrep-all
    fd
    eza
    lf
    ncdu
    nmap
    lsof
    #TODO remove this after using syncthingd
    syncthing
    wget
    zellij

    tldr
    bc
    usbutils
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
