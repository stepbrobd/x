{
  outputs = inputs: inputs.parts.lib.mkFlake { inherit inputs; } {
    systems = import inputs.systems;

    perSystem = { lib, pkgs, system, self', ... }: {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          (final: prev: (
            let
              ocamlPackages = prev.ocaml-ng.ocamlPackages_5_4;
              coqPackages = prev.coqPackages_9_1;
              rocqPackages = prev.rocqPackages_9_1;
            in
            with builtins; with lib; genAttrs
              (attrNames (readDir ./overlays))
              (name: import ./overlays/${name} {
                inherit final prev ocamlPackages coqPackages rocqPackages;
              })
          ))
        ];
      };

      devShells.default = pkgs.mkShell {
        inherit (self'.packages.default) env;
        inputsFrom = [ self'.packages.default ];
        packages = with pkgs; with ocamlPackages; [
          coqfmt
          ocamlformat
          utop
        ];
      };

      formatter = pkgs.writeShellScriptBin "formatter" ''
        ${lib.getExe pkgs.dune} fmt
        ${lib.getExe pkgs.nixpkgs-fmt} .
      '';

      packages.default = pkgs.aoc;
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    parts.url = "github:hercules-ci/flake-parts";
    parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    systems.url = "github:nix-systems/default";
  };
}
