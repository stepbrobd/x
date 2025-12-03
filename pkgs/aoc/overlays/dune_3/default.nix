{ prev, ... }:

prev.dune_3.overrideAttrs {
  version = "3.21.0-unstable-2025-12-02";
  src = prev.fetchFromGitHub {
    owner = "ocaml";
    repo = "dune";
    rev = "7c53739170c4131e3ca58ca522b02174db59d2da";
    hash = "sha256-VCpR0VCHxDgK5ScXAT/hdgkbsLsg9swTjzOx4Pt6Jqw=";
  };
}
