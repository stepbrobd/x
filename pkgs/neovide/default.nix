{ pkgs
, pkgsPrev ? pkgs
, stdenv
}:

let
  inherit (pkgsPrev) neovide;
in
if stdenv.hostPlatform.isDarwin
then
  neovide.overrideAttrs
    (prev: {
      postInstall = prev.postInstall + ''
        rm -f $out/Applications/Neovide.app/Contents/Resources/Neovide.icns
        cp ${./icon.icns} $out/Applications/Neovide.app/Contents/Resources/Neovide.icns
      '';
    })
else neovide
