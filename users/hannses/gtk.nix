{pkgs, theme, ...}: {
  gtk = {
    enable = true;

    font = {
         name = "${theme.font}";
    };

    iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders.override {
            flavor = "mocha";
            accent = "lavender";
        };
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
}
