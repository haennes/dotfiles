{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nix-output-monitor # better visualization of nix-shell and nix-build
    nixfmt # formatting nix files
    fastfetch # display system information
    restic
    fd # better version of find

    nmap
    wget
    zellij # terminal multiplexer
    tmux # backrground terminals
    pv # util
    dig # dns lookup
    tcpdump

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
