{ pkgs, globals, ... }:
{
  file_selector = pkgs.pkgs.writeShellScript "file_selector" ''
    DMENU="${globals.dmenu}"

    getdir=false
    while getopts "dp:h" args; do
        case "''${args}" in
            d)
                getdir=true
                ;;
            p)
                # starting directory
                cd "''${OPTARG}"
                ;;
            h)
                # help menu
                echo "\
                    -d | get a directory instead of a file
                                    -p | set a starting path, will use current if not set
                                    -h | get this help menu \
                                        "
                  exit
                  ;;
              *)
                  # wrong option
                  exit
                  ;;
          esac
      done

    loop=1
    while [ "$loop" ]; do
      if $getdir; then
      # only list directories
      # ls will throw an error if there are no more directories. This is fine and will still echo .
        file=$(echo -e ".\n$(\ls -1 --group-directories-first -a -d */)" | $DMENU )
      else
        file=$(\ls -1 --group-directories-first | $DMENU )
      fi
      if [ "$file" = "" ]; then
    # pressed ESC
        exit
      fi

      if [ -e "$file" ]; then
        owd=$(pwd)
        if $getdir && [ "$file" = "." ]; then
          # select directory
          echo "$owd"
          unset loop
        elif [ -d "$file" ]; then
          # move to directory
          cd "$file"
        else [ -f "$file" ]
          # select file
          echo "$owd/$file"
          unset loop
        fi
      fi
    done
  '';
}
