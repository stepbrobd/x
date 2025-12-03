{ final, ... }:

let
  pkgs = final;
  inherit (pkgs) lib;
in
pkgs.ocamlPackages.buildDunePackage (finalAttrs: {
  pname = "aoc";
  version = with lib; pipe ../../dune-project [
    readFile
    (match ".*\\(version ([^\n]+)\\).*")
    head
  ];

  env = rec {
    COQPATH = lib.concatStringsSep ":" (map
      (p: (lib.concatStringsSep ":" [
        "${p}/lib/coq/user-contrib/"
        "${p}/lib/coq/${pkgs.coqPackages.coq.coq-version}/user-contrib/"
        "${p}/lib/ocaml/${pkgs.ocamlPackages.ocaml.version}/site-lib/coq/user-contrib/"
      ]))
      finalAttrs.propagatedBuildInputs);
    ROCQPATH = COQPATH;
  };

  src = with lib.fileset; toSource {
    root = ../../.;
    fileset = unions [
      ../../bin
      ../../theories
      ../../dune-project
    ];
  };

  nativeBuildInputs = with pkgs; [
    rocqPackages.rocq-core
  ];

  propagatedBuildInputs = with pkgs; [
    rocqPackages.rocq-core
    rocqPackages.stdlib
  ];

  passthru = { inherit (finalAttrs) env; };
})
