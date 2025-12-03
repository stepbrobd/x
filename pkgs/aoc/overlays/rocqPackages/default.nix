{ final, rocqPackages, ... }:

rocqPackages.overrideScope (rocqFinal: rocqPrev: {
  rocq-core = rocqPrev.rocq-core.override {
    customOCamlPackages = final.ocamlPackages;
  };
  stdlib = final.ocamlPackages.buildDunePackage {
    pname = "rocq-stdlib";
    inherit (rocqPrev.stdlib) version src;
    nativeBuildInputs = [ final.coqPackages.coq ];
    buildInputs = [ final.rocqPackages.rocq-core ];
  };
})
