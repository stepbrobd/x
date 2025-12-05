{ pkgs
, pkgsPrev ? pkgs
}:

let
  inherit (pkgsPrev) hydra;
in
hydra.overrideAttrs {
  patches = [ ./oidc.patch ];
  doCheck = false;
}
