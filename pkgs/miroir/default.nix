{ lib
, stdenv
}:

(lib.getFlake (lib.toString ./.)).packages.${stdenv.hostPlatform.system}.default
