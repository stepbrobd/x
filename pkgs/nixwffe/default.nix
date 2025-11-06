{ nixVersions }:

nixVersions.git.overrideAttrs (prev: {
  patches = prev.patches or [ ] ++ [
    # ./0001-nix-with-full-flake-expr.patch
  ];
})
