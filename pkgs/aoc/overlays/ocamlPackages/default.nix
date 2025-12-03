{ final, ocamlPackages, ... }:

ocamlPackages.overrideScope (ocamlFinal: ocamlPrev: {
  buildDunePackage = ocamlPrev.buildDunePackage.override {
    dune_3 = final.dune;
  };
})
