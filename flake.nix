{
  outputs =
    { self, ... }@inputs:
    inputs.autopilot.lib.mkFlake
      {
        inherit inputs;

        autopilot = {
          lib = {
            path = ./lib;
            extender = inputs.nixpkgs.lib;
            excludes = [ "secrets.yaml" ];
            extensions = with inputs; [
              autopilot.lib
              colmena.lib
              darwin.lib
              hm.lib
              parts.lib
              terranix.lib
              utils.lib
              { std = inputs.std.lib; }
            ];
          };

          nixpkgs = {
            config = {
              allowUnfree = true;
            };
            overlays = with inputs; [
              self.overlays.default
              golink.overlays.default
              mac-style-plymouth.overlays.default
              rust-overlay.overlays.default
              unstraightened.overlays.default
            ];
            instances = {
              pkgs = inputs.nixpkgs;
            };
          };

          parts.path = ./modules/flake;
        };
      }
      {
        debug = true;
        systems = import inputs.systems;
      };

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # a
    autopilot.url = "github:stepbrobd/autopilot";
    autopilot.inputs.nixpkgs.follows = "nixpkgs";
    autopilot.inputs.parts.follows = "parts";
    autopilot.inputs.systems.follows = "systems";
    # c
    colmena.url = "github:zhaofengli/colmena";
    colmena.inputs.nixpkgs.follows = "nixpkgs";
    colmena.inputs.stable.follows = "nixpkgs";
    colmena.inputs.flake-compat.follows = "compat";
    colmena.inputs.flake-utils.follows = "utils";
    colmena.inputs.nix-github-actions.follows = "";
    compat.url = "github:nixos/flake-compat";
    compat.flake = false;
    cornflake.url = "github:jzbor/cornflakes";
    crane.url = "github:ipetkov/crane";
    # d
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    # f
    flakey-profile.url = "github:lf-/flakey-profile";
    # g
    garnix.url = "github:garnix-io/garnix-lib";
    garnix.inputs.nixpkgs.follows = "nixpkgs";
    generators.url = "github:nix-community/nixos-generators";
    generators.inputs.nixpkgs.follows = "nixpkgs";
    generators.inputs.nixlib.follows = "nixpkgs";
    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks.inputs.flake-compat.follows = "compat";
    git-hooks.inputs.gitignore.follows = "gitignore";
    gitignore.url = "github:hercules-ci/gitignore.nix";
    gitignore.inputs.nixpkgs.follows = "nixpkgs";
    golink.url = "github:tailscale/golink";
    golink.inputs.nixpkgs.follows = "nixpkgs";
    golink.inputs.systems.follows = "systems";
    # h
    hardware.url = "github:nixos/nixos-hardware";
    hm.url = "github:nix-community/home-manager";
    hm.inputs.nixpkgs.follows = "nixpkgs";
    hydra.url = "github:ners/hydra/oidc";
    hydra.inputs.nixpkgs.follows = "nixpkgs";
    # i
    impermanence.url = "github:nix-community/impermanence";
    index.url = "github:nix-community/nix-index-database";
    index.inputs.nixpkgs.follows = "nixpkgs";
    # l
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.3";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.inputs.crane.follows = "crane";
    lanzaboote.inputs.flake-compat.follows = "compat";
    lanzaboote.inputs.flake-parts.follows = "parts";
    lanzaboote.inputs.pre-commit-hooks-nix.follows = "";
    lanzaboote.inputs.rust-overlay.follows = "rust-overlay";
    # m
    mac-style-plymouth.url = "github:sergioribera/s4rchiso-plymouth-theme";
    mac-style-plymouth.inputs.nixpkgs.follows = "nixpkgs";
    mac-style-plymouth.inputs.flake-utils.follows = "utils";
    # n
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.flake-parts.follows = "parts";
    nixvim.inputs.systems.follows = "systems";
    # p
    parts.url = "github:hercules-ci/flake-parts";
    parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    # r
    rpi.url = "github:nvmd/nixos-raspberrypi";
    rpi.inputs.nixpkgs.follows = "nixpkgs";
    rpi.inputs.flake-compat.follows = "compat";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    # s
    schemas.url = "github:determinatesystems/flake-schemas";
    sops.url = "github:mic92/sops-nix";
    sops.inputs.nixpkgs.follows = "nixpkgs";
    srvos.url = "github:nix-community/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs";
    std.url = "github:chessai/nix-std";
    sweep.url = "github:jzbor/nix-sweep";
    sweep.inputs.nixpkgs.follows = "nixpkgs";
    sweep.inputs.cf.follows = "cornflake";
    sweep.inputs.crane.follows = "crane";
    systems.url = "github:nix-systems/default";
    # t
    terranix.url = "github:terranix/terranix";
    terranix.inputs.nixpkgs.follows = "nixpkgs";
    terranix.inputs.flake-parts.follows = "parts";
    terranix.inputs.systems.follows = "systems";
    tsnsrv.url = "github:boinkor-net/tsnsrv";
    tsnsrv.inputs.nixpkgs.follows = "nixpkgs";
    tsnsrv.inputs.flake-parts.follows = "parts";
    # u
    unstraightened.url = "github:marienz/nix-doom-emacs-unstraightened";
    unstraightened.inputs.nixpkgs.follows = "nixpkgs";
    unstraightened.inputs.systems.follows = "systems";
    utils.url = "github:numtide/flake-utils";
    utils.inputs.systems.follows = "systems";
  };
}
