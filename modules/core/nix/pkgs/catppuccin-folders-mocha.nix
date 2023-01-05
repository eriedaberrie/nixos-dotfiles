{ lib, stdenv, fetchFromGitHub, papirus-icon-theme, ... }:

stdenv.mkDerivation rec {
  pname = "catppuccin-folders-mocha";
  version = "unstable";
  nativeBuildInputs = [ papirus-icon-theme ];
  dontBuild = true;
  dontFixup = true;

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "papirus-folders";
    rev = "1a367642df9cf340770bd7097fbe85b9cea65bcb";
    sha256 = "1zqfnqs69r7j2rw3xsvrjfi8zaca7g1cwm91ifmnrxf0a12xyl4q";
  };

  installPhase  = ''
    mkdir -p $out/share/icons
    cp -va --no-preserve=mode ${papirus-icon-theme}/share/icons/Papirus ${papirus-icon-theme}/share/icons/Papirus-Dark $out/share/icons
    cp -va src/* $out/share/icons/Papirus
    bash papirus-folders -C cat-mocha-teal -t $out/share/icons/Papirus-Dark -o
  '';

  meta = {
    description = "Soothing pastel theme for Papirus Icon Theme folders (Mocha flavored)";
    homepage = "https://github.com/catppuccin/papirus-folders";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
