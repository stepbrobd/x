{
  outputs = inputs: inputs.parts.lib.mkFlake { inherit inputs; } {
    systems = import inputs.systems;

    perSystem = { pkgs, system, ... }: {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            dune = prev.dune_3.overrideAttrs {
              version = "3.20.3-unstable-2025-12-02";
              src = prev.fetchFromGitHub {
                owner = "ocaml";
                repo = "dune";
                rev = "7c53739170c4131e3ca58ca522b02174db59d2da";
                hash = "sha256-VCpR0VCHxDgK5ScXAT/hdgkbsLsg9swTjzOx4Pt6Jqw=";
              };
            };
            rocq = prev.rocq-core_9_1.override {
              customOCamlPackages = prev.ocamlPackages;
            };
          })
        ];
      };

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          dune
          ocaml
          ocamlformat
          rocq
          sops
        ] ++ (with ocamlPackages; [
          utop
        ]);
      };

      formatter = pkgs.writeShellScriptBin "formatter" ''
        ${pkgs.dune}/bin/dune fmt
        ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt .
      '';
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    parts.url = "github:hercules-ci/flake-parts";
    parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    systems.url = "github:nix-systems/default";
  };
}
