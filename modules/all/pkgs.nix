{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    restic
    fd # better version of find

    pv # util

  ];
}
