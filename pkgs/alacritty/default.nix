{ stdenv
, alacritty
}:

if stdenv.hostPlatform.isDarwin
then
  alacritty.overrideAttrs
    (prev: {
      postInstall = prev.postInstall + ''
        rm -f $out/Applications/Alacritty.app/Contents/Resources/alacritty.icns
        cp ${./icon.icns} $out/Applications/Alacritty.app/Contents/Resources/alacritty.icns
      '';
    })
else alacritty
