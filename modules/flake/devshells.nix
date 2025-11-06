{
  perSystem = { pkgs, inputs', ... }: {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        inputs'.colmena.packages.colmena
        inputs'.sops.packages.default
        inputs'.terranix.packages.default
        (opentofu.withPlugins (p: with p; [ cloudflare_cloudflare carlpett_sops tailscale_tailscale ]))
      ];
    };
  };
}
