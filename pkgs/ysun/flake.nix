{
  outputs = { self, nixpkgs, parts, systems } @ inputs: parts.lib.mkFlake { inherit inputs; } {
    systems = import systems;

    perSystem = { lib, pkgs, system, ... }: {
      _module.args = lib.fix (self: {
        lib = builtins // parts.lib // nixpkgs.lib;
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              ocamlPackages = prev.ocamlPackages.overrideScope (ocamlFinal: ocamlPrev:
                (with self.lib; genAttrs
                  (attrNames (readDir ./pkgs))
                  (name: ocamlFinal.callPackage ./pkgs/${name} { }))
                //
                {
                  dune = ocamlPrev.dune_3;
                });
            })
          ];
        };
      });

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          deno
          direnv
          git
          nix-direnv
        ] ++ (with ocamlPackages; [
          dune_3
          ocaml
          ocamlformat
          ocaml-print-intf
          yocaml
        ]);
      };

      formatter = pkgs.writeShellScriptBin "formatter" ''
        ${lib.getExe pkgs.deno} fmt .
        ${lib.getExe pkgs.dune_3} fmt
        ${lib.getExe pkgs.nixpkgs-fmt} .
      '';

      packages = {
        yocaml = pkgs.ocamlPackages.yocaml;
        yocaml_cmarkit = pkgs.ocamlPackages.yocaml_cmarkit;
      };
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    parts.url = "github:hercules-ci/flake-parts";
    parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    systems.url = "github:nix-systems/default";
  };
}
