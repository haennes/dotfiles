{ pkgs, osConfig, ... }:
{
  services.batsignal = {
    enable = osConfig.has_battery;
    package = pkgs.batsignal.overrideAttrs {
      src = pkgs.fetchFromGitHub {
        owner = "Bootjewolf";
        repo = "batsignal";
        rev = "23f9d9b8c061b55501e21d6e89fa4c523254f73a";
        hash = "sha256-kGj5FVfZJPX/TCsCT2X+gplz1YAg0GlmGDMjCCxtZZw=";
      };
    };
    extraArgs = [
      # warning levels
      "-w"
      "25"
      #"-W" "WARNING: Battery below 25%"
      "-c"
      "15"
      #"-C" "CRITICAL: Battery below 20%"
      "-d"
      "5"
      #"-D"
      #"systemctl suspend"
      # enable battery full level
      "-f"
      "80"

      "-p" # show message when changing charging state
      "-q" # show message only once
      "-P"
      "charging"

      "-m"
      "+1"
    ];
  };
}
