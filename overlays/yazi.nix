final: prev:
rec {
  rofi-wayland = prev.rofi-wayland.overrideAttrs (old: {
    version = "test";
    src = prev.fetchFromGitHub {
    owner = "davatorium";
    #owner = "lbonn";
    repo = "rofi";
    #rev = "1.7.5+wayland3";
    #rev = "32d229bb47d1d84a15edb3e142e6e3805c5c0ea4"; /wayland latest
    #sha256 = "sha256-pKxraG3fhBh53m+bLPzCigRr6dBcH/A9vbdf67CO2d8=";
    #rev = "3b0f2b43f9d594478dc188030f564488f6f10609";
    #sha256 = "sha256-F/XiegTq03oF4d59em1xgTmlEZ4GgG+MWtXBrOxnliQ=";
    fetchSubmodules = true;
    #sha256 = "sha256-JORQoLe3cc7f5muj7E9ldS89aRld4oZ/b5PAt7OH0jE=";
    #rev = "3b0f2b43f9d594478dc188030f564488f6f10609";
    #rev = "d88b475bad26a6ba60c85cd7830e441da5774cdb";

    #rev = "9963df114bc2de0d452a4751d8b250118ca6b20a";
    #sha256 = "sha256-3XFusKeckagEPfbLtt1xAVTEfn1Qebdi/Iq1AYbHCR4=";

    rev = "8f06e0a3707e3e2ba2fb695eeb1df09a4a33bdf2";
    sha256 = "sha256-20MYgM0jfIEPYVB4hNPbACKtk6dVb2I8hYgQtYX+Evw=";
  };
  });
  pinentry-rofi = prev.pinentry-rofi.overrideAttrs(old: {
      propagatedBuildInputs = [ rofi-wayland ];
  });
}
