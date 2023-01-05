_:

{
  imports = [
    # inputs.nur.hmModules.nur
    ./graphical
    ./themes
    ./cli.nix
    ./email.nix
    ./fetch.nix
    ./git.nix
    ./packages.nix
    ./shell.nix
    ./spotify.nix
  ];

  xdg = {
    enable = true;
    configFile = {
      "nixpkgs/config.nix".text = ''
        {
          allowUnfree = true;
        }
      '';
    };
  };
}
