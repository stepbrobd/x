{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    parts.url = "github:hercules-ci/flake-parts";
    parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs: inputs.parts.lib.mkFlake { inherit inputs; } {
    systems = import inputs.systems;

    perSystem = { lib, pkgs, system, ... }: {
      _module.args = {
        lib = with inputs; builtins // nixpkgs.lib // parts.lib;
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              ocamlPackages = prev.ocamlPackages.overrideScope (_: prev': {
                mirage-crypto-rng = prev'.mirage-crypto-rng.overrideAttrs (_: {
                  # https://github.com/mirage/mirage-crypto/issues/216
                  # https://github.com/nixos/nixpkgs/pull/356634
                  doCheck = !(with final.stdenv; isDarwin && isAarch64);
                });
              });
            })
          ];
        };
      };

      packages.default = pkgs.ocamlPackages.buildDunePackage (finalAttrs: {
        pname = "yeh";
        meta.mainProgram = finalAttrs.pname;
        version = with lib; pipe ./dune-project [
          readFile
          (match ".*\\(version ([^\n]+)\\).*")
          head
        ];

        src = with lib.fileset; toSource {
          root = ./.;
          fileset = unions [
            ./lib
            ./bin
            ./dune-project
            ./yeh.opam
          ];
        };

        env.DUNE_CACHE = "disabled";

        propagatedBuildInputs = with pkgs.ocamlPackages; [
          angstrom
          cohttp
          cohttp-lwt
          cohttp-lwt-unix
          core
          lambdasoup
          lwt
          mrmime
          ptime
          uri
        ];
      });

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          dune_3
          ocaml
          ocamlformat
          sops
        ] ++ (with ocamlPackages; [
          angstrom
          cohttp
          cohttp-lwt
          cohttp-lwt-unix
          core
          lambdasoup
          lwt
          mrmime
          ocaml-print-intf
          odoc
          ptime
          uri
          utop
        ]);
      };

      formatter = pkgs.writeShellScriptBin "formatter" ''
        ${pkgs.deno}/bin/deno fmt readme.md
        ${pkgs.dune_3}/bin/dune fmt
        ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt .
      '';
    };
  };
}
