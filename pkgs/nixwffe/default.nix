{ nixVersions }:

nixVersions.latest.override {
  nix-flake = nixVersions.latest.libs.nix-flake.overrideAttrs (prev: {
    patches = prev.patches or [ ] ++ [ ./0001-nix-with-full-flake-expr.patch ];
  });
}
