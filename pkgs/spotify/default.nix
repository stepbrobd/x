{
  stdenv,
  spotify,
}:

if stdenv.hostPlatform.isDarwin then
  spotify.overrideAttrs (_: {
    postInstall = ''
      rm -f $out/Applications/Spotify.app/Contents/Resources/Icon.icns
      cp ${./icon.icns} $out/Applications/Spotify.app/Contents/Resources/Icon.icns
    '';
  })
else
  spotify
