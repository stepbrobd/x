# All the weird stuff goes here

This is basically a monorepo where I dump everything that can be made public.

## Structure

- [`lib`](./lib): [autopilot](https://github.com/stepbrobd/autopilot) evaluation
  entry point, Nix related helper functions
- [`modules`](./modules): all modules that will be picked up by autopilot, then
  loaded with [flake-parts](https://flake.parts)
- [`pkgs`](./pkgs): packages from [nixpkgs](https://github.com/nixos/nixpkgs)
  that are globally overridden, my own stuff, it's a mess...

## Module portability

For all modules exposed under `./modules`, `importApplyWithArgs` is used to
optionally apply a two level argument. For example, if the file importing is in
`./modules/nixos`, we can have:

```nix
{ lib, inputs, ... } @ arg0:

{ config, lib, modulesPath, options, pkgs, ... } @ arg1:

{ ... } # actual content
```

Where `arg0` is from `./modules/flake/modules/default.nix`, includes the `lib`
from `builtins // nixpkgs.lib`, and with all locally defined helper functions
under `./lib` and extensions declared in `autopilot`, and is not compatible with
the `lib` in `arg1`.

All variables from `arg1` are standard NixOS module arguments, but if `lib` is
needed, it must be pulled in from `arg0` (precedence), or `pkgs.lib`:

```nix
{ config, lib, ... }: # <-

lib.deepMergeAttrsList ... # pull something from `config`
```

Will resulted in an error (`config` not found), and

```nix
{ lib, ... }: # <-

{ config, ... }:

lib.deepMergeAttrsList ... # pull something from `config`
```

Must be used. But if the following is allowed since the application of `arg0` is
optional based on the names inside:

```nix
{ config, ... }:

{ ... } # do something dependent on `config`
```

Note that this behavior only apply one level deep, i.e. only modules imported
using `modulesFor` will get automatic argument injection. If `arg0` is needed in
nested modules or files imported from top-level module:

```nix
arg0:

{ config, ... }:

{
  imports = [
    (import ./some-module.nix arg0) # `arg0` is not optionally here, the second level arg is the regular module arg
  ];
}
```
