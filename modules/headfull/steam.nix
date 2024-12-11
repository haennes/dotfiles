{ pkgs, ... }: {
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraPkgs = (pkgs: [ pkgs.corefonts pkgs.vistafonts ]);
    };
  };
}
