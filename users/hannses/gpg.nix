{ pkgs, ... }: {
  home.packages = with pkgs; [ gnupg ];
  programs.gpg = { enable = true; };
  services.gpg-agent = {
    pinentry.package = pkgs.pinentry-tty;
    enable = true;
  };
}
