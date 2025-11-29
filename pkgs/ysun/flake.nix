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
          dune
          ocaml
          ocamlformat
          ocaml-print-intf
          yocaml
        ]);
      };

      formatter = pkgs.writeShellScriptBin "formatter" ''
        ${lib.getExe pkgs.deno} fmt .
        ${lib.getExe pkgs.nixpkgs-fmt} .
        ${lib.getExe pkgs.ocamlPackages.dune} fmt
      '';

      packages = lib.fix (self: {
        default = self.cohttp-eio;

        inherit (pkgs.ocamlPackages)
          carton
          carton-git-lwt
          carton-lwt
          cohttp
          cohttp-eio
          git-kv
          git-net
          hilite
          http
          liquid_interpreter
          liquid_ml
          liquid_parser
          liquid_std
          liquid_syntax
          omd
          oniguruma
          plist-xml
          textmate-language
          yocaml
          yocaml_cmarkit
          yocaml_eio
          yocaml_git
          yocaml_jingoo
          yocaml_liquid
          yocaml_markdown
          yocaml_mustache
          yocaml_omd
          yocaml_otoml
          yocaml_runtime
          yocaml_syndication
          yocaml_unix
          yocaml_yaml
          ;
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
