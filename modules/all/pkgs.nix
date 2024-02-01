{pkgs, ...}:{
  environment.systemPackages = with pkgs; [
    nix-output-monitor
    nil
    neofetch
    home-manager
    restic
    ripgrep-all
    eza
    nmap
    #TODO remove this after using syncthingd
    syncthing
    wget
    zellij
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
