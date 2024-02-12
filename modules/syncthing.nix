{config, lib, ...}:
let 
    dev_name = config.services.syncthing_wrap.dev_name;
    ids = import ./syncthing.key.nix;
    versioning = {
        type = "simple";
        params.keep = "10";
    };
    default_versioning = versioning;
    all_pcs = {
       thinkpad = { id = ids.thinkpad;};
       mainpc = { id = ids.mainpc;};
    };
    all_handys = {
       handyHannes = {id = ids.handyHannes;};
       handyAlexandra = {id = ids.handyMum;};
       handyThomas = {id = ids.handyThomas;};
       tablet = { id = ids.tablet;};
    };
    servers = { 
      syncschlawiner = {id = ids.syncschlawiner ;};
    };
    all_servers = {
      tabula = {id = ids.tabula;};
    };
    folders_list =  with all_handys all_pcs servers; (
      create_folder "3d_printing" (all_pcs // servers)
   // create_folder "Documents" (all_pcs // servers)
   // create_folder "Notes" (all_pcs // servers)
   // create_folder "Downloads" (all_pcs // servers)
   // create_folder_adv {
        name = "Family";
	devices = (all_pcs // servers);
	paths = {
	  "mainpc" = "/home/Family";
	  "thinkpad" = "/home/Family";
	};

   }
   // create_folder "Music" (all_pcs //  servers)
   // create_folder_adv{
        name = "Passwords";
	devices = (all_pcs // all_handys // servers);
	versioning = {
          type = "simple";
          params.keep = "100";
        };
   }
   // create_folder "Pictures" (all_pcs // servers)
   // create_folder "Templates" (all_pcs // servers)
   // create_folder "Videos" (all_pcs // servers)
   // create_folder "game_servers" (all_pcs // servers)
   // create_folder "programming" (all_pcs // servers)
   // create_folder "AegisBak" (all_pcs // servers // { inherit handyHannes;})
   // create_folder "SignalBackup" (all_pcs // servers // { inherit handyHannes;})
   // create_folder "DownloadHandyH" (all_pcs // servers // { inherit handyHannes;})
   // create_folder "HannesKamera" (all_pcs // servers // {inherit handyHannes;})
   // create_folder "HannesGalerie" (all_pcs // servers // {inherit handyHannes;})
   // create_folder "AlexandraKamera" (servers // {inherit handyAlexandra;})
   // create_folder "AlexandraGalerie" (servers // {inherit  handyAlexandra;})
   // create_folder "ThomasKamera" (servers)
   // create_folder "ThomasGalerie" (servers)
   // create_folder "website" (all_pcs // {inherit tabula;})
   );
   create_folder_adv = {name, devices, versioning ? default_versioning, paths ? {}, default_path ? config.services.syncthing_wrap.dataDir + "/" + name}:
   {
     "${name}" = {  
       inherit versioning;
       path = (if paths ? "${dev_name}" then paths."${dev_name}" else default_path);
       devices = (builtins.attrNames devices);
     };
   };
   create_folder = name: devices: create_folder_adv{inherit name devices versioning;};
   devices = all_pcs // all_handys // servers // all_servers;
   devices_but_me = removeAttrs devices [dev_name];
in with lib;{
  options.services.syncthing_wrap = {
    enable = mkEnableOption "syncting_wrap";
    dataDir = mkOption{
      type = types.str;
    };
    dev_name = mkOption{
      type =  types.str;
      default = config.networking.hostName;
    };
    usr = mkOption{
      type = types.str;
      default = "hannses";
    };
  };
  config = mkIf config.services.syncthing_wrap.enable {
    age.secrets.${"syncthing_key_${dev_name}"} = {
      owner = config.services.syncthing_wrap.usr;
      file = ../secrets/syncthing/${dev_name}/key.age;
    };
    age.secrets.${"syncthing_cert_${dev_name}"} = {
      owner = config.services.syncthing_wrap.usr;
      file = ../secrets/syncthing/${dev_name}/cert.age;
    };
    #TODO determine wether the other keys/certs should be set
    services.syncthing = {
        enable = true;
        overrideDevices = true;
        overrideFolders = true;
	openDefaultPorts = true;
	key = config.age.secrets."syncthing_key_${dev_name}".path;
	cert = config.age.secrets."syncthing_cert_${dev_name}".path;
        dataDir = config.services.syncthing_wrap.dataDir;
        # dont set configDir as it is automatically set to a subdir... 
	user = config.services.syncthing_wrap.usr;
	settings = {
          inherit devices;
	  folders = lib.filterAttrs (n: v: builtins.elem dev_name v.devices) folders_list;
          #folders = ( builtins.listToAttrs ( 
          #    builtins.map (name_devices: {
          #        name = name_devices.name;
          #        value = {
	  #	    inherit versioning;
	  #	    path = config.services.syncthing_wrap.dataDir + "/" + name_devices.name;
	  #	    # always sync to server
	  #          devices = builtins.attrNames name_devices.devices;
          #          #devices = removeAttrs ( builtins.attrNames name_devices.devices  ) dev_name;
          #        };
          #    })
	  #    folders_list
          #));
          options = {
	     urAccepted = -1; # do not send reports
	     relaysEnabled = true;
	  };

	#  
        };
      };
   # Syncthing ports: 8384 for remote access to GUI
   # 22000 TCP and/or UDP for sync traffic
   # 21027/UDP for discovery
   # source: https://docs.syncthing.net/users/firewall.html
   networking.firewall.allowedTCPPorts = [ 8384 22000 ]; networking.firewall.allowedUDPPorts = [ 22000 21027 ];

   #TODO
   #services.syncthing.extraOptions.gui = {
   #    user = "username";
   #    password = "password";
   #};
   };

}
