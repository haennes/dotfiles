{ updateInterval, ... }:
{
  # Dont ask why (:
  "wooclap" = {
    urls = [ { template = "https://app.wooclap.com/{searchTerms}"; } ];
    icon = "https://wooclap-assets-production.wooclap.com/11.83.0-47c1c0efee233d790dc49acfc76f32f4f91ceba0/assets/favicon.ico";
    definedAliases = [
      # keep-sorted start
      "<clap"
      "<woo"
      # keep-sorted end
    ];
    inherit updateInterval;
  };
}
