{ pkgs
, pkgsPrev ? pkgs
}:

let
  inherit (pkgsPrev) nixVersions;
in
nixVersions.latest.appendPatches [
  ./0001-nix-with-full-flake-expr.patch
]
