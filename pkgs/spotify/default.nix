{ pkgs
, pkgsPrev ? pkgs
, stdenv
}:

let
  inherit (pkgsPrev) spotify;
in
if stdenv.hostPlatform.isDarwin
then
  spotify.overrideAttrs
  {
    postInstall = ''
      rm -f $out/Applications/Spotify.app/Contents/Resources/Icon.icns
      cp ${./icon.icns} $out/Applications/Spotify.app/Contents/Resources/Icon.icns
    '';
  }
else spotify
