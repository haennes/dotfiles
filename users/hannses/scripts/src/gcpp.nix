{ pkgs, scripts, lib, ... }: ''
  a=$1
  b=''${a%\.*}
  ${pkgs.gcc}/bin/g++ $@ -Wall -o $b
''
