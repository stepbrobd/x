# All the weird stuff goes here

This is basically a monorepo where I dump everything that can be made public.

## Structure

- [`lib`](./lib): [autopilot](https://github.com/stepbrobd/autopilot) evaluation
  entry point, Nix related helper functions
- [`modules`](./modules): all modules that will be picked up by autopilot, then
  loaded with [flake-parts](https://flake.parts)
- [`pkgs`](./pkgs): packages from [nixpkgs](https://github.com/nixos/nixpkgs)
  that are globally overridden, my own stuff, it's a mess...
