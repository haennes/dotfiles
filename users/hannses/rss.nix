{ ... }: {
  programs.newsboat = {
    enable = true;
    autoReload = true;
    extraConfig = ''
      urls-source "freshrss"
      freshrss-url "http://rss.localhost/api/greader.php"
      freshrss-login "hannses"
      freshrss-password "secret2"
    '';
  };
}
