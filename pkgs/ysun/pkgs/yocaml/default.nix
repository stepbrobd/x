{ buildDunePackage
, fetchFromGitHub
}:

buildDunePackage (finalAttrs: {
  pname = "yocaml";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "xhtmlboi";
    repo = "yocaml";
    tag = "v${finalAttrs.version}";
    hash = "";
  };
})
