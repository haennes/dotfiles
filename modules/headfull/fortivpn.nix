{config, pkgs, ...}:{
   age.secrets."openfortivpn.age" = {
     file = ../../secrets/openfortivpn.age;
     owner = "root";
     group = "root";
   };


  environment = {
    etc = {
      "openfortivpn/config".source = config.age.secrets."openfortivpn.age".path ;

    };
    systemPackages = with pkgs; [
      openfortivpn
    ];
  };
}
