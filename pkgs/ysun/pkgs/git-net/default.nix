{ buildDunePackage
, alcotest
, awa-mirage
, bos
, ca-certs-nss
, git-kv
, gitMinimal
, h1
, happy-eyeballs-lwt
, mimic
, mimic-happy-eyeballs
, paf
, tcpip
, tls
, tls-mirage
, uri
}:

buildDunePackage {
  pname = "git-net";

  inherit (git-kv) version src;

  env.DUNE_CACHE = "disabled";

  propagatedBuildInputs = [
    awa-mirage
    ca-certs-nss
    git-kv
    h1
    happy-eyeballs-lwt
    mimic
    mimic-happy-eyeballs
    paf
    tcpip
    tls
    tls-mirage
    uri
  ];

  doCheck = false;

  nativeCheckInputs = [
    gitMinimal
  ];

  checkInputs = [
    alcotest
    bos
  ];
}
