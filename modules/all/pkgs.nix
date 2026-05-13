{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    restic
    fd # better version of find

    zellij # terminal multiplexer
    pv # util

  ];
}
