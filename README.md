# rescript-lsp-nix

[rescript language server](https://www.npmjs.com/package/@rescript/language-server) packaged for nix.

```
nix run github:frectonz/rescript-lsp-nix
```

or

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    rescript-lsp = {
      url = "github:frectonz/rescript-lsp-nix";
      inputs.utils.follows = "utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , utils
    , rescript-lsp
    }:
    utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs { inherit system; };
        rescript-language-server = rescript-lsp.packages.${system}.default;
      in
      with pkgs; {
        devShells.default = mkShell {
          packages = [ rescript-language-server ];
        };

        formatter = nixpkgs-fmt;
      });
}
```
