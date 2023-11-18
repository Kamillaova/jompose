{ lib, callPackage }:
let
	jomposeStd = lib.sourceFilesBySuffices ./src [".libsonnet"];
	jomposeBin = callPackage ./src/jompose.sh.nix { inherit jomposeStd; };
in jomposeBin
