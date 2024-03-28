{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , utils
    }:
    utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      with pkgs; {
        packages.default = pkgs.buildNpmPackage rec {
          pname = "rescript-language-server";
          version = "1.50.0";

          src = pkgs.fetchFromGitHub {
            owner = "rescript-lang";
            repo = "rescript-vscode";
            rev = version;
            hash = "sha256-4b2Z94/CCvPge9qKmv8svUib8zJ9NEZ+FYeylgmkKBQ=";
          };

          sourceRoot = "${src.name}/server";
          npmDepsHash = "sha256-xxGELwjKIGRK1/a8P7uvUCKrP9y8kqAHSBfi2/IsebU=";

          nativeBuildInputs = [ pkgs.esbuild ];
          buildPhase = ''
            esbuild src/cli.ts --bundle --sourcemap --outfile=out/cli.js --format=cjs --platform=node --loader:.node=file --minify
          '';
        };

        formatter = nixpkgs-fmt;
      });
}
