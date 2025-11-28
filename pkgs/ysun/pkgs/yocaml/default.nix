{ buildDunePackage
, fetchFromGitHub
, alcotest
, fmt
, logs
, mdx
, ppx_expect
, qcheck
, qcheck-alcotest
}:

buildDunePackage (finalAttrs: {
  pname = "yocaml";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "xhtmlboi";
    repo = "yocaml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x9LyipIXN5qoWtmZNcOh8i+WERcrWqydAnxAWdAHXdA=";
  };

  env.DUNE_CACHE = "disabled";

  propagatedBuildInputs = [
    logs
  ];

  doCheck = true;

  nativeCheckInputs = [
    mdx.bin
  ];

  checkInputs = [
    alcotest
    fmt
    (mdx.override { inherit logs; })
    ppx_expect
    qcheck
    qcheck-alcotest
  ];
})
