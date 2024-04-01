{config, pkgs, ...}:
let 
dotfiles_path = "/home/hannses/.dotfiles";
in
{
    home.packages = with pkgs; [nom eza];
    programs.zsh = {
       enable = true;
       shellAliases = rec {
           dticket = "feh -F /home/hannses/Documents/DeutschlandTicket.jpg";
           ticket = dticket;
           db = dticket;
           
           #nix = "nom";
           nix-build = "nom-build";
           nix-shell = "nom-shell";

           vim = "nvim";
           vi = "nvim";

           ls = "eza -lh";
           la = "eza -Alh"; 
           # path cds
           dotfiles = "cd ${dotfiles_path}";
           dotf = dotfiles;

           oth = "cd /home/hannses/Documents/Studium/Semster1";

           "..." = "cd  ../../"; # dont want to enable prezto
           "...." = "cd  ../../../"; # dont want to enable prezto
           "....." = "cd  ../../../../"; # dont want to enable prezto
           "......" = "cd  ../../../../../"; # dont want to enable prezto
           # ...... seems more than enough

           # config apply & build
           cfg_apply = "${dotfiles_path}/apply";
           cfg_build = "${dotfiles_path}/build";
           cfg_repl = "${dotfiles_path}/repl";

           # vim keybindings
           ":q" = "exit";
       };
       initExtra = ''
       mkcdir ()
         {
           mkdir -p -- "$1" &&
           cd -P -- "$1"
         }
       '';

       autocd = true;
       autosuggestion.enable = true;
       defaultKeymap = "vicmd";
       history = {
           expireDuplicatesFirst = true;
	   ignoreDups = true;
           share = true;
	   size = 10000;
       };
    };
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv = {
        enable = true;
      };
    };
}
