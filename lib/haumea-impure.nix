let
  path = builtins.fetchGit {
    url = "https://github.com/nix-community/haumea";
  };
in
import "${path.outPath}/default.nix" { }
