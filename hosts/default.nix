{ nixpkgs, self, ... }:

let
  inputs = self.inputs;
  mkSystems = systems: builtins.mapAttrs (hostName: cfg: nixpkgs.lib.nixosSystem (with cfg; {
    inherit system;
    modules = [
      {
        networking = {inherit hostName;};
        users.users.${username} = {
          isNormalUser = true;
          extraGroups = [
            "wheel"
            "video"
            "disk"
            "input"
          ];
        };
        home-manager = {
          backupFileExtension = "hm-bak";
          useUserPackages = true;
          useGlobalPkgs = true;
          extraSpecialArgs = {inherit self inputs;};
          users.${username} = _: {
            imports = [
              ../modules/home
              "${module}/home"
            ];
            home = {
              inherit username;
              homeDirectory = "/home/${username}";
            };
          };
        };
      }
      inputs.home-manager.nixosModules.home-manager
      # inputs.nur.nixosModules.nur
      ../modules/os
      module
    ];
    specialArgs = {inherit self inputs username;};
  })) systems;
in mkSystems {

  nix-laptop = {
    system = "x86_64-linux";
    username = "errie";
    module = ./nix-laptop;
  };

  groceries = {
    system = "x86_64-linux";
    username = "serverie";
    module = ./groceries;
  };

}
