{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
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
