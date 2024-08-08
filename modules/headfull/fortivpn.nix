{config, pkgs, ...}:{
   age.secrets."openfortivpn.age" = {
     file = ../../secrets/openfortivpn.age;
     owner = "root";
     group = "root";
   };


  environment = {
    etc = {
      openfortivpnconfig.source = config.age.secrets."openfortivpn.age".path ;
      openfortivpn.source = ./openfortivpn;

    };
    systemPackages = with pkgs; [
      openfortivpn
    ];
  };
}
