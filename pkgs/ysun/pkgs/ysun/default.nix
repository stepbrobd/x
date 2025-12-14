{ lib
, buildDunePackage
, deno
, tailwindcss_4
, yocaml
, yocaml_liquid
, yocaml_markdown
, yocaml_unix
, yocaml_yaml
}:

buildDunePackage (finalAttrs: {
  pname = "ysun";
  version = with lib; pipe ../../dune-project [
    readFile
    (match ".*\\(version ([^\n]+)\\).*")
    head
  ];

  src = with lib.fileset; toSource {
    root = ../../.;
    fileset = unions [
      ../../assets
      ../../dune
      ../../dune-project
      ../../main.ml
      ../../pages
    ];
  };

  env.DUNE_CACHE = "disabled";

  nativeBuildInputs = [
    deno
    tailwindcss_4
  ];

  buildInputs = [
    yocaml
    yocaml_liquid
    yocaml_markdown
    yocaml_unix
    yocaml_yaml
  ];

  buildPhase = ''
    runHook preBuild
    dune build -p ${finalAttrs.pname} ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
    dune exec ./main.exe
    deno fmt _build/www
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    dune install --prefix $out --libdir $OCAMLFIND_DESTDIR ${finalAttrs.pname}
    mkdir -p $out/var/www/html
    cp -r _build/www/* $out/var/www/html/
    runHook postInstall
  '';
})
