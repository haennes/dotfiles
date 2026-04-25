{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nix-output-monitor # better visualization of nix-shell and nix-build
    nixfmt # formatting nix files
    restic
    fd # better version of find

    zellij # terminal multiplexer
    tmux # backrground terminals
    pv # util

  ];
  programs.neovim = {
    enable = true;
    defaultEditor = false;
    #  dont set default editor here as we may want to use helix
  };
}
