{ pkgs, scripts, lib, ... }: ''
  a=$1
  b=''${a%\.*}
  ${pkgs.gcc}/bin/g++ $@ -Wall --std=c++23 -o $b
''
