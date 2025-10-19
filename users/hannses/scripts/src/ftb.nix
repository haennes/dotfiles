{ lib, pkgs, ... }: ''
  ${
    lib.getExe pkgs.atlauncher
  } --launch "FTB Infinity Evolved Skyblock" --no-console true --no-launcher-update false
''
