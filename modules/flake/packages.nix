{ inputs, lib, ... }:

let
  inherit (lib) fix importPackagesWith mkDynamicAttrs;
in
{
  perSystem = { pkgs, ... }: {
    packages = mkDynamicAttrs (fix (self: {
      dir = ../../pkgs;
      fun = name: importPackagesWith (pkgs // { inherit inputs lib; }) (self.dir + "/${name}") { };
    }));
  };

  # seems like `legacyPackages` is equivalent to `packages`?
  # https://nixos.wiki/wiki/Flakes#Output_schema
  flake.legacyPackages = inputs.self.packages;
}
