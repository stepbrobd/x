{ inputs, stdenv }:

(import inputs.compat { src = ./.; }).defaultNix.packages.${stdenv.hostPlatform.system}.default
