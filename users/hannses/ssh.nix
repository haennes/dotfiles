{ips, ...}:
let
ports_noports = {default_ports ? true, user ? "root", name ? hostname, hostname, proxyJump ? null, localForwards ? []}:
  let
    common = {inherit user hostname;} // (if proxyJump == null then {} else {inherit proxyJump;}); 
    common_ports = common // {inherit localForwards;};
  in {
    "${name}_noports" = common;
    "${name}_ports" = common_ports;
    "${name}" = (if default_ports then common_ports else common);
  };  

# l -> local ip
# m -> welt -> server only do this if we have a wg ip
# g  = "" -> welt -> porta -> server
local_global = {default_ports ? true, user ? "root", name, local_ip, wg_ip ? null, localForwards ? []}:
 ports_noports{inherit default_ports user localForwards; name = "l_${name}"; hostname = local_ip;}
 // ports_noports{inherit default_ports user localForwards; proxyJump = "porta"; name = "g_${name}";hostname = local_ip;}
 // ports_noports{inherit default_ports user name localForwards; proxyJump = "porta"; hostname = local_ip;}
 // (if wg_ip == null then {} else (
	ports_noports{inherit default_ports user localForwards; proxyJump = "welt"; name = "m_${name}"; hostname = wg_ip;}
	)
    )
;

simple_forwards = ports: (builtins.map(port: (simple_forward port)) ports);
simple_forward = port: {
  bind.port = port; 
  host.port = port; 
  host.address = "127.0.0.1";
};
in with ips; {
programs.ssh = {
  enable = true;
  matchBlocks = {
    "welt" = {
      user = "root"; 
      hostname = "hannses.de";
    };
    # can not replace with local_global as different hostnames
    "porta_local" = {
      user = "root";
      hostname = porta.ens18;
    };
    "porta" = {
      user = "root";
      hostname = porta.wg0;
      proxyJump = "welt";
    };
  }
  // local_global{name = "pve"; local_ip = pve.vmbr0; localForwards = [(simple_forward 8006)];}
  // local_global{
      name = "syncschlawiner";
      local_ip = syncschlawiner.ens0;
      wg_ip = syncschlawiner.wg0;
      localForwards = [
	#TODO: determine allowed ports
        {
          bind.port = 8385;
          host.port = 8384;
          host.address = "127.0.0.1";
        }
	{
          bind.port = 8386;
          host.port = 80;
          host.address = "127.0.0.1";
        }
	{
          bind.port = 8387;
          host.port = 443;
          host.address = "127.0.0.1";
        }
	];
     }
   // local_global{
     name = "tabula";
     local_ip = tabula.ens0;
     wg_ip =  tabula.wg0; 
     localForwards = [
     {
	bind.port = 8388;
	host.port = 8384;
	host.address = "127.0.0.1";
     }
     {
	bind.port = 8389;
	host.port = 443;
	host.address = "127.0.0.1";
     }
     {
	bind.port = 8390;
	host.port = 80;
	host.address = "127.0.0.1";
     }
     ];
   }
   // local_global{
     name = "grapheum";
     local_ip = grapheum.ens0;
     #wg_ip =  grapheum.wg0; 
   }
   ;
  };
}
