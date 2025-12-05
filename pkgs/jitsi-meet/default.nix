{ pkgs
, pkgsPrev ? pkgs
}:

let
  inherit (pkgsPrev) jitsi-meet;
in
jitsi-meet.overrideAttrs (prev: {
  patches = [ ./plausible.patch ];
})
