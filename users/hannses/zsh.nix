{config, pkgs, ...}:{
    home.packages = with pkgs; [nom];
    programs.zsh = {
       enable = true;
       shellAliases = {
           dticket = "feh -F /home/hannses/Documents/DeutschlandTicket.jpg";
           ticket = "dticket";
	   db = "dticket";
	   
	   #nix = "nom";
	   nix-build = "nom-build";
	   nix-shell = "nom-shell";

           vim = "nvim";
           vi = "nvim";

	   #exa is installed systemwide
           ls = "exa -lh";
           la = "exa -Alh"; #replace this with eza at some point (i want columns)
	   "..." = "cd  ../../"; # dont want to enable prezto
	   "...." = "cd  ../../../"; # dont want to enable prezto
	   "....." = "cd  ../../../../"; # dont want to enable prezto
	   "......" = "cd  ../../../../../"; # dont want to enable prezto

           ":q" = "exit";
	   #TODO add a mkcdir or similar
	   # ...... seems more than enough
       };
       initExtra = ''
       mkcdir ()
         {
           mkdir -p -- "$1" &&
           cd -P -- "$1"
         }
       '';

       autocd = true;
       enableAutosuggestions = true;
       defaultKeymap = "vicmd";
       history = {
           expireDuplicatesFirst = true;
	   ignoreDups = true;
           share = true;
	   size = 10000;
       };
    };
}
