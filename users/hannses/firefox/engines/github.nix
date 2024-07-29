{ updateInterval, ... }:
let
  gh_search = { type, alias, personal ? false, addAliases ? [ ], ... }:
    let title = "GitHub ${type}" + (if personal then " personal" else "");
    in {
      "${title}" = {
        urls = [{
          template = "https://github.com/search";
          params = [
            {
              name = "q";
              value = if personal then
                "owner:haennes+{searchTerms}"
              else
                "" + "{searchTerms}";
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
        iconUpdateURL =
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
