{ updateInterval, lib, ... }:
let
  gh_search = { type, alias, personal ? false, addAliases ? [ ]
    , addSearchParams ? [ ]
    , title ? "GitHub ${type}" + (if personal then " personal" else ""), ... }:
    let
      inherit (lib) concatMapStrings;
      additionalSearchParams = concatMapStrings (v: "${v}+") addSearchParams;
    in {
      "${title}" = {
        urls = [{
          template = "https://github.com/search";
          params = [
            {
              name = "q";
              value = if personal then
                "owner:haennes+${additionalSearchParams}{searchTerms}"
              else
                "${additionalSearchParams}{searchTerms}";
            }
            {
              name = "type";
              value = type;
            }
          ];
        }];
        definedAliases =
          [ ("<gh" + (if personal then "p" else "") + "${alias}") ]
          ++ addAliases;
        icon =
          "https://github.githubassets.com/assets/pinned-octocat-093da3e6fa40.svg";
        inherit updateInterval;
      };
    };
in gh_search ({
  type = "repositories";
  alias = "r";
  addAliases = [ "gh" ];
}) # <ghr or <gh
// gh_search ({
  type = "users";
  alias = "u";
}) # <ghu

// gh_search ({
  type = "repositories";
  alias = "r";
  personal = true;
  addAlias = [ "ghp" ];
  addSearchParams = [ "fork:true" ];
}) # <ghpr or <ghp
// gh_search ({
  type = "users";
  alias = "u";
  personal = true;
}) # <ghpu
// gh_search ({
  type = "issues";
  alias = "i";
  personal = true;
}) # <ghpi
// gh_search {
  type = "code";
  title = "GitHub nix files";
  alias = "nf";
  addSearchParams = [ "path%3A**%2F*.nix" ];
} # <ghnf
// gh_search {
  type = "code";
  title = "GitHub nix flakes";
  alias = "nff";
  addSearchParams = [ "path%3A**%2Fflake.nix" ];
} # <ghnf
