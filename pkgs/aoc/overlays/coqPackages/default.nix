{ final, coqPackages, ... }:

coqPackages.overrideScope (coqFinal: coqPrev: {
  coq = coqPrev.coq.override {
    buildIde = false;
    customOCamlPackages = final.ocamlPackages;
    rocqPackages = final.rocqPackages;
  };
})
