{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    restic
    fd # better version of find

    zellij # terminal multiplexer
    tmux # backrground terminals
    pv # util

  ];
}
