{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		flake-parts.url = "github:hercules-ci/flake-parts";
		systems.url = "github:nix-systems/default";
	};

	outputs = inputs @ { flake-parts,  ... }:
		flake-parts.lib.mkFlake { inherit inputs; } {
			systems = import inputs.systems;

			perSystem = { pkgs, ... }: {
				packages = rec {
					jompose = pkgs.callPackage ./. {};
					default = jompose;
				};
			};
		};
}
