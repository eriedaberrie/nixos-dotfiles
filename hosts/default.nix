{ nixpkgs, self, ... }:

let
  inputs = self.inputs;
  home-manager = {
    backupFileExtension = "hm-bak";
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit self inputs;};
    users.errie = ../home/errie;
  };
in {
  nix-laptop = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      {inherit home-manager;}
      {networking.hostName = "nix-laptop";}
      inputs.home-manager.nixosModules.home-manager
      ./nix-laptop
      ../modules/core
      ../modules/cloudflare-warp
      ../modules/wayland
    ];
    specialArgs = {inherit self inputs;};
  };
}
