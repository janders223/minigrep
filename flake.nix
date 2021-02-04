{
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
		flake-utils.url = "github:numtide/flake-utils";
		naersk.url = "github:nmattia/naersk";
	};

	outputs = inputs:
	inputs.flake-utils.lib.eachDefaultSystem(system:
	let
		pkgs = inputs.nixpkgs.legacyPackages."${system}";
		naersk-lib = inputs.naersk.lib."${system}";
	in with pkgs; rec {
		packages.minigrep = naersk-lib.buildPackage {
			pname = "minigrep";
			root = ./.;
		};
		defaultPackage = packages.minigrep;

		apps.minigrep = inputs.flake-utils.lib.mkApp {
			drv = packages.minigrep;
		};
		defaultApp = apps.minigrep;

		devShell = pkgs.mkShell {
			nativeBuildInputs = with pkgs; [
				cargo
				clippy
				rnix-lsp
				rust-analyzer
				rustc
			];
		};
	});
}
