{ hydra }:

hydra.overrideAttrs {
  patches = [ ./oidc.patch ];
  doCheck = false;
}
