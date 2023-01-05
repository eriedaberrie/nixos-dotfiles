{ nixpkgs, ... }:

nixpkgs.lib.genAttrs [
  "aarch64-linux"
  "x86_64-linux"
] (system: let
  pkgs = nixpkgs.legacyPackages.${system};
in {
  ruby = pkgs.ruby_3_1.withPackages (r: with r; [
    solargraph
    ruby-vips
  ]);

  python = pkgs.python311.withPackages (p: with p; [
    numpy
    pandas
    requests
    pillow
    yt-dlp
    tkinter
  ]);

  catppuccin-papirus-folders = pkgs.catppuccin-papirus-folders.override {
    flavor = "mocha";
    accent = "teal";
  };

  geticons = pkgs.callPackage ./geticons.nix { };
  fastfetch = pkgs.callPackage ./fastfetch.nix { };
})
