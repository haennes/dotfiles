let 
  __subnet = lib: ip: (builtins.concatStringsSep "." (lib.lists.take 3 (lib.strings.splitString "." ip)));
in
{
  ip_cidr = ip: "${ip}/32";
  subnet_cidr = lib: ip: let subnet = (__subnet lib ip); in "${subnet}.0/24"; 

  
  pve = {
    vmbr0 = "192.168.0.13";
  };
  welt = {
    ens3 = "57.129.6.13";
    wg0 = "192.168.1.3";
  };
  porta = {
    ens18 = "192.168.0.15";
    wg0 = "192.168.1.4";
  };
  syncschlawiner = {
    wg0 = "192.168.1.5";
    ens0 = "192.168.0.23";
  };
  thinkpad.wg0 = "192.168.1.6";
  handy_hannses.wg0 = "192.168.1.7";
  tabula = {
    wg0 = "192.168.1.8";
    ens0 = "192.168.0.25";
  };
  grapheum =  {
    ens0 = "192.168.0.26";
  };
}
