{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ./vms.nix ];
  networking.hostName = "thinknew"; # Define your hostname.

  services.syncthing-wrapper = { enable = true; };
  services.syncthing = { dataDir = "/syncthing"; };
  virtualisation.docker.enable = true;
  services.wireguard-wrapper.enable = true;
  microvmHost.extInterface = "enp0s25";

  services.wordpress.sites."localhost" = {
    languages = [ pkgs.wordpressPackages.languages.de_DE ];
    settings = {
      WPLANG = "de_DE";
      WP_MAIL_FROM = "noreply@localhost";
    };
    plugins = {
      inherit (pkgs.wordpressPackages.plugins)
        static-mail-sender-configurator
        #wordpress-seo
        webp-express jetpack merge-minify-refresh disable-xml-rpc
        #simple-login-captcha
      ;
    };
    #extraConfig = ''
    #    // Enable the plugin
    #    if ( !defined('ABSPATH') )
    #      define('ABSPATH', dirname(__FILE__) . '/');
    #    require_once(ABSPATH . 'wp-settings.php');
    #    require_once ABSPATH . 'wp-admin/includes/plugin.php';
    #    activate_plugin( 'disable-xml-rpc/disable-xml-rpc.php' );
    #    activate_plugin( 'simple-login-captcha/simple-login-captcha.php' );
    #    ini_set( 'error_log', '/var/lib/wordpress/localhost/debug.log' );
    #'';
  };
  has_battery = false;
  nixpkgs.overlays = [
    (self: super: {
      wordpress = super.wordpress.overrideAttrs (oldAttrs: rec {
        installPhase = oldAttrs.installPhase + ''
          ln -s /var/lib/wordpress/localhost/webp-express $out/share/wordpress/wp-content/webp-express
        '' + ''
          ln -s /var/lib/wordpress/example.org/mmr $out/share/wordpress/wp-content/mmr
        '';
      });
    })
  ];

  systemd.tmpfiles.rules = [
    "d '/var/lib/wordpress/localhost/webp-express' 0750 wordpress wwwrun - -"
    "d '/var/lib/wordpress/localhost/mmr ' 0750 wordpress wwwrun - -"
  ];
}
