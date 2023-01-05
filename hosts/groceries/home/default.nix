_:

{
  imports = [ ./packages.nix ];

  my = {
    git.enable = true;

    shell = {
      aliases.enable = true;
      direnv.enable = true;
      fish.enable = true;
      globalNpmPackages.enable = true;
    };
  };

  home.stateVersion = "23.05";
}
