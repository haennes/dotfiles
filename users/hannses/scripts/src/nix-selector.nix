{ self, globals, pkgs, scripts, lib, config, ... }:
let
  inherit (lib) concatLines attrNames;
  tmuxSession = "nix";
  headfull_hostnames = [ "yoga" ];
  headless_hostnames = [ "dea" "welt" ];
  all_hostnames = headless_hostnames ++ headfull_hostnames;
  run_in_tmux = { command, windowname, hostnames, ... }: ''
           command="${command}"
           windowname="${windowname}"
           hostname=$(echo -e "${concatLines hostnames}" | $DMENU repl)
           command="${pkgs.nh}/bin/nh $command .?submodules=1 -H $hostname "
           tmux has-session -t ${tmuxSession}  2>/dev/null
           if [ $? != 0 ]; then
             tmux new-session -d -s ${tmuxSession}
           fi
           if tmux list-windows -t ${tmuxSession} -F "#{window_name}" | grep -q "$windowname"; then
             action=$(echo -e "attach
    restart
             " | $DMENU "alredy exists")
             windows=$(tmux list-windows -t ${tmuxSession} -F "#{window_name} #{window_id}")
             window_id=$(echo $windows | grep $windowname | cut -d ' ' -f 2)
             case $action in
               attach)
                 ${pkgs.alacritty}/bin/alacritty -e ${pkgs.tmux}/bin/tmux attach -t $window_id
                 return 0
               ;;
               restart)
                 tmux kill-window -t $window_id
               ;;
             esac
           fi
           tmux new-window -t ${tmuxSession} -n $windowname
           tmux send-keys -t ${tmuxSession}:$windowname "cd ${globals.dotfiles_path}" C-m
           tmux send-keys -t ${tmuxSession}:$windowname "sh -c \"$command\"" C-m
           ${pkgs.alacritty}/bin/alacritty -e ${pkgs.tmux}/bin/tmux attach -t $window_id
  '';
in ''

  DMENU="${globals.dmenu} -window-title"
  action=$(
    echo -e "${concatLines [ "repl" "build" "switch" "search" "nop" "clean" ]}"\
    | $DMENU nix
  )
  case $action in
    repl)
       ${
         run_in_tmux {
           windowname = "repl-$hostname";
           command = "os repl";
           hostnames = all_hostnames;
         }
       }
    ;;
    build)
       ${
         run_in_tmux {
           windowname = "build-$hostname";
           command = "os build";
           hostnames = all_hostnames;
         }
       }
    ;;
    switch)
       ${
         run_in_tmux {
           windowname = "switch-$hostname";
           command = "os switch -a";
           hostnames = headfull_hostnames;
         }
       }
  esac
''
