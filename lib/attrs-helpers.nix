{ lib, ... }:
rec {
  mapAttrsToPathValueList =
    set:
    lib.mapAttrsRecursive (path: value: [
      {
        name = "${lib.concatStringsSep "." path}";
        inherit value;
      }
    ]) set;

  flattenAttrsToList =
    let
      inherit (lib) flatten collect isList;
    in
    set: flatten (collect isList (mapAttrsToPathValueList set));

  flattenAttrs = set: lib.listToAttrs (flattenAttrsToList set);

  recursiveMerge =
    let
      inherit (lib) foldr recursiveUpdate;
    in
    listOfAttrsets: foldr (attrset: acc: recursiveUpdate attrset acc) { } listOfAttrsets;

}
