{
  outputs = inputs: inputs.parts.lib.mkFlake { inherit inputs; } {
    systems = import inputs.systems;

    perSystem = { lib, pkgs, system, self', ... }: {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          (final: prev: lib.fix (self:
            let
              ocamlPackages = prev.ocaml-ng.ocamlPackages_5_4;
              coqPackages = prev.coqPackages_9_1;
              rocqPackages = prev.rocqPackages_9_1;
            in
            {
              coqfmt = final.coqPackages_8_20.coqfmt;
              dune = self.dune_3;
              dune_3 = prev.dune_3.overrideAttrs {
                version = "3.21.0-unstable-2025-12-02";
                src = prev.fetchFromGitHub {
                  owner = "ocaml";
                  repo = "dune";
                  rev = "7c53739170c4131e3ca58ca522b02174db59d2da";
                  hash = "sha256-VCpR0VCHxDgK5ScXAT/hdgkbsLsg9swTjzOx4Pt6Jqw=";
                };
              };
              ocamlPackages = ocamlPackages.overrideScope (ocamlFinal: ocamlPrev: {
                buildDunePackage = ocamlPrev.buildDunePackage.override {
                  dune_3 = final.dune;
                };
              });
              coqPackages = coqPackages.overrideScope (coqFinal: coqPrev: {
                coq = coqPrev.coq.override {
                  buildIde = false;
                  customOCamlPackages = final.ocamlPackages;
                  rocqPackages = final.rocqPackages;
                };
              });
              rocqPackages = rocqPackages.overrideScope (rocqFinal: rocqPrev: {
                rocq-core = rocqPrev.rocq-core.override {
                  customOCamlPackages = final.ocamlPackages;
                };
                stdlib = final.ocamlPackages.buildDunePackage {
                  pname = "rocq-stdlib";
                  inherit (rocqPrev.stdlib) version src;
                  nativeBuildInputs = [ final.coqPackages.coq ];
                  buildInputs = [ final.rocqPackages.rocq-core ];
                };
              });
            }))
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

      packages.default = pkgs.ocamlPackages.buildDunePackage (finalAttrs: {
        pname = "aoc";
        version = with lib; pipe ./dune-project [
          readFile
          (match ".*\\(version ([^\n]+)\\).*")
          head
        ];

        env = rec {
          COQPATH = lib.concatStringsSep ":" (map
            (p: (lib.concatStringsSep ":" [
              "${p}/lib/coq/user-contrib/"
              "${p}/lib/coq/${pkgs.coqPackages.coq.coq-version}/user-contrib/"
              "${p}/lib/ocaml/${pkgs.ocamlPackages.ocaml.version}/site-lib/coq/user-contrib/"
            ]))
            finalAttrs.propagatedBuildInputs);
          ROCQPATH = COQPATH;
        };

        src = with lib.fileset; toSource {
          root = ./.;
          fileset = unions [
            ./dune-project
            ./src
          ];
        };

        nativeBuildInputs = with pkgs; [
          rocqPackages.rocq-core
        ];

        propagatedBuildInputs = with pkgs; [
          rocqPackages.rocq-core
          rocqPackages.stdlib
        ];

        passthru = { inherit (finalAttrs) env; };
      });
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    parts.url = "github:hercules-ci/flake-parts";
    parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    systems.url = "github:nix-systems/default";
  };
}
