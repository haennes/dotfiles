{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    nix-output-monitor # better visualization of nix-shell and nix-build
    nixfmt-classic # formatting nix files
    neofetch # display system information
    restic
    ripgrep-all # ripgrep but for more formats
    fd # better version of find
    eza
    lf # tui file manager
    ncdu # disk usage
    nmap
    lsof # list open files (I use it for local port monitoring)
    wget
    zellij # terminal multiplexer
    tmux # backrground terminals
    pv # util
    dig # dns lookup

    tldr # man alternative
    usbutils
    git
    sshfs
    deploy-rs
    wireguard-tools
    btop # process and system monitor
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = false;
    #  dont set default editor here as we may want to use helix
  };
}
