{ nixVersions }:

nixVersions.latest.appendPatches [
  ./0001-nix-with-full-flake-expr.patch
]
