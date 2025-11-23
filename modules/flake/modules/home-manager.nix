{ modulesFor, ... }:

{
  # same shit but different names?
  flake = rec {
    hmModules = homeManagerModules;
    homeModules = homeManagerModules;
    homeManagerModules = modulesFor "home";
  };
}
