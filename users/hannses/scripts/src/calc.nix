{ pkgs, lib, inputs, hm-config, ... }: ''
  ${inputs.menu-calc.packages.x86_64-linux.menucalc-fend}/bin/= --dmenu='${hm-config.programs.rofi.finalPackage}/bin/rofi -dmenu -lines 3'
''
