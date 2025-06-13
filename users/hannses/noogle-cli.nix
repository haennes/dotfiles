{ inputs, pkgs, ... }: {
  home.packages = [ inputs.noogle-cli.packages.${pkgs.system}.noogle-cli ];
}
