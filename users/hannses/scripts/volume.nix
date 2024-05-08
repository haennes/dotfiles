{ pkgs, globals, ... }: {
  volume = pkgs.pkgs.writeShellScript "volume" ''
          DMENU="${globals.dmenu}"

          outputs=$(pactl list sinks | grep -E "device.profile.description|State" | sed 'N;s/\n/ /g' | sed 's/\s*State: \(\S*\)\s*device.* = "\(.*\)"/\2 (\1)/')
          output_indexes=($(pactl list sinks short | awk '{print $1}'))

          inputs=$(pactl list sources | grep -E "Source #|device.profile.description|State|Active Port:" | sed 'N;N;N;s/\n/ /g' | grep "Active Port: \[In\]")
          input_indexes=($(echo "$inputs" | awk '{print $2}' | grep -oP "\d+"))
          inputs=$(echo "$inputs" | sed 's/.*State: \(\S*\)\s*device.* = "\(.*\)".*/\2 (\1)/')
    # TODO
          active_inputs=($())

          applications=$(pactl list sink-inputs | grep -E "media.name|Corked" | sed 'N;s/\n//g' | sed 's/\s*Corked: \(\S*\)\s*media.* = "\(.*\)"$/\2 (\1)/' | sed 's/no)$/RUNNING)/' | sed 's/yes)$/PAUSED)/')
          application_indexes=($(pactl list sink-inputs | grep "Sink Input" | grep -oP "\d+$"))
          active_sinks=($(pactl list sink-inputs | grep -E "Sink:|Corked:" | sed 'N;s/\n//g' | grep "Corked: no" | awk '{print $2}' | sort -u))

          set_app_output () {
    # app-index, output
    	  pactl move-sink-input "$i" "$2"
          }

      set_app_vol () {
    # app-index, vol
          pactl set-sink-input-volume "$i" "$2%"
      }

      toggle_app () {
    # app-index
          pactl set-sink-input-mute "$i" toggle
      }

      get_app_vol () {
    # app-index
          pactl list sink-inputs | sed -n -e "/Sink Input #$1/,/Volume/ p" | grep -oP "\d+%" | head -n 1
      }

      get_app_muted () {
          muted=$(pactl list sink-inputs | sed -n -e "/Client: $1/,/Mute: / p" | grep "Mute: " | sed 's/.*Mute: //')
    	  if [ $muted = "yes" ]; then
    	      echo 1
    	  else
    	      echo 0
    		  fi
      }

      set_output_vol () {
    # output, volume
          pactl set-sink-volume "$i" "$2%"
      }

      toggle_output () {
    # output
          pactl set-sink-mute "$i" toggle
      }

      get_output_vol () {
          pactl get-sink-volume "$1" | grep -oP "\d+%" | head -n 1
      }

      get_output_muted () {
          if [ $(pactl get-sink-mute "$1" | sed 's/.* //') = "yes" ]; then
    	  echo 1
          else
    	  echo 0
    	      fi
      }

      set_mic_vol () {
    # mic-index, vol
          pactl set-source-volume "$i" "$2"
      }

      toggle_mic () {
    	# mic-index
          pactl set-source-mute "$i" toggle
      }

      get_mic_vol () {
    	#mic-index
          pactl get-source-volume "$1" | grep -oP "\d+%" | head -n 1
      }

      get_mic_muted () {
          if [ $(pactl get-source-mute "$1" | sed 's/.* //') = "yes" ]; then
    	  echo 1
          else
    	  echo 0
    	      fi
      }

      get_output () {
          index=$(echo -e "DEFAULT\n$outputs" | $DMENU -format 'i')

    	  if [ -z "$index" ]; then 
    	      output="" 
    		  elif (( "$index" < 0 )); then
    		  output=""
    		  elif [ "$index" = 0 ]; then
    		  output="@DEFAULT_SINK@"
    	  else
    	      output="''${output_indexes[$index - 1]}"
    		  fi
    		  echo "$output"
      }

      get_app () {
          index=$(echo "$applications" | $DMENU -format 'i')

    	  if [ -z "$index" ]; then 
    	      app="" 
    		  elif (( "$index" < 0 )); then
    		  app=""
    	  else
    	      app="''${application_indexes[$index]}"
    		  fi
    		  echo "$app"
      }

      get_mic () {
          index=$(echo -e "default\n$inputs" | $DMENU -format 'i')

    	  if [ -z "$index" ]; then 
    	      mic="" 
    		  elif (( "$index" < 0 )); then
    		  mic=""
    		  elif [ "$index" = 0 ]; then
    		  mic="@DEFAULT_SOURCE@"
    	  else
    	      mic="''${input_indexes[$index - 1]}"
    		  fi
    		  echo "$mic"
      }

      get_sel_vol () {
    # current volume
          echo -e "toggle\n5\n15\n50\n70\n99" | $DMENU -window-title " $1 "
      }

    # use currently playing output instead of default if there are any
      if [ -z "$active_sinks" ]; then
          output="@DEFAULT_SINK@"
      else
          output=("''${active_sinks[@]}")
    	  fi

    	  if [ -z "$active_inputs" ]; then
    	      input="@DEFAULT_SOURCE@"
    	  else
    	      input=("''${active_inputs[@]}")
    		  fi

    		  getopts "vacidtmlus:" flag
        case "''${flag}" in
    # getters have undefined behaviour when playing on more then one output at once (always takes first index)
    		  v) #volume
    		      get_output_vol "''${output[0]}"
    		      ;;
    		  a) # volume active (muted)
    		      get_output_muted "''${output[0]}"
    		      ;;
    		  b) # mic volume
    		      get_mic_vol "''${input[0]}"
    		      ;;
    		  c) # check mic (muted)
    		      get_mic_muted "''${input[0]}"
    		      ;;

    		  i) #increase
    		      for i in "''${output[@]}"; do
    			  set_output_vol "$i" "+5"
    			      done
    			      ;;
    		  d) #decrease
    		      for i in "''${output[@]}"; do
    			  set_output_vol "$i" "-5"
    			      done
    			      ;;
    		  t) #toggle
    		      for i in "''${output[@]}"; do
    			  toggle_output "$i"
    			      done
    			      ;;
    		  m) #toggle mute
    		      for i in "''${input[@]}"; do
    			  toggle_mic "$i"
    			      done
    			      ;;
    		  l) #mic decrease
    		      for i in "''${input[@]}"; do
    			  set_mic_vol "$i" "-5"
    			      done
    			      ;;
    		  u) #mic increase
    		      for i in "''${input[@]}"; do
    			  set_mic_vol "$i" "-5"
    			      done
    			      ;;
    		  s) #set
    		      for i in "''${output[@]}"; do
    			  set_output_vol "$i" "$OPTARG"
    			      done
    			      ;;
    		  :)
    		      value=$(echo "$levels" | $DMENU -window-title " $current ")
    		      for i in "''${output[@]}"; do
    			  set_output_vol "$i" "$value"
    			      done
    			      ;;
    		  esac

    		      if [ "$flag" = "?" ]; then
        case $(echo -e "output volume\napp volume\napp output\nmic volume\nset default output" | $DMENU) in 
    			  "output volume")
    			      output=$(get_output)
    			      if [ -z "$output" ]; then exit; fi
    				  vol=$(get_sel_vol $(get_output_vol "$output"))
    				      if [ -z "$vol" ]; then 
    					  exit
    					      elif [ "$vol" = "toggle" ]; then
    					      toggle_output "$output"
    				      else
    					  set_output_vol "$output" "$vol"
    					      fi
    					      ;;
    			  "app volume")
    			      app=$(get_app)
    			      if [ -z "$app" ]; then exit; fi
    				  vol=$(get_sel_vol $(get_app_vol "$app"))
    				      if [ -z "$vol" ]; then 
    					  exit
    					      elif [ "$vol" = "toggle" ]; then
    					      toggle_app "$output"
    				      else
    					  set_app_vol "$app" "$vol"
    					      fi
    					      ;;
    			  "app output")
    			      app=$(get_app)
    			      if [ -z "$app" ]; then exit; fi
    				  output=$(get_output)
    				      if [ -z "$output" ]; then exit; fi
    					  set_app_output "$app" "$output"
    					      ;;
    			  "mic volume")
    			      mic=$(get_mic)
    			      if [ -z "$mic" ]; then exit; fi
    				  vol=$(get_sel_vol $(get_mic_vol "$mic"))
    				      if [ -z "$vol" ]; then 
    					  exit
    					      elif [ "$vol" = "toggle" ]; then
    					      toggle_mic "$mic"
    				      else
    					  set_mic_vol "$mic" "$vol"
    					      fi
    					      ;;
    			  "set default output")
    			      list_arr=($(pactl list sinks | grep "Name: " | sed 's/.*Name: //'))
    			      search=$(pactl get-default-sink)
    			      index=""
    			      for i in "''${!list_arr[@]}"; do
    				  if [[ "''${list_arr[$i]}" = "''${search}" ]]; then
    				      index=$i
    					  break
    					  fi
    					  done
    					  if [ -z $index ]; then exit; fi
    					      output=$(get_output)
    						  if [ -z "$output" ]; then exit; fi
    						      pactl set-default-sink "$output"
    							  ;;
    			  *)
    			      ;;
    			  esac
    			      fi
    			      '';
}
