{
  lib,
  stdenv,
  cmake,
  pkg-config,
  fetchFromGitHub,
  makeWrapper,
  # hard deps
  dbus,
  dconf,
  glib,
  pciutils,
  zlib,
  # soft deps
  enableChafa ? false,
  chafa,
  enableImageMagick ? false,
  imagemagick_light,
  enableOpenCLModule ? true,
  ocl-icd,
  opencl-headers,
  enableOpenGLModule ? true,
  libglvnd,
  enableVulkanModule ? true,
  vulkan-loader,
  enableWayland ? true,
  wayland,
  enableX11 ? true,
  libX11,
  libxcb,
  enableXFCE ? false,
  xfce,
  extraFlashfetchConf ? null,
}:

stdenv.mkDerivation rec {
  pname = "fastfetch";
  version = "1.11.3";

  src = fetchFromGitHub {
    owner = "LinusDierheimer";
    repo = pname;
    rev = version;
    hash = "sha256-6q7hr9W3GG9dcgfRT32+6CUYDFcgtGlgn0AuezgbQis=";
  };

  nativeBuildInputs = [ cmake makeWrapper pkg-config ];

  runtimeDependencies =
    [ dbus dconf glib pciutils zlib ]
    ++ lib.optional enableChafa chafa
    ++ lib.optional enableImageMagick imagemagick_light
    ++ lib.optional enableOpenCLModule ocl-icd
    ++ lib.optional enableOpenGLModule libglvnd
    ++ lib.optional enableVulkanModule vulkan-loader
    ++ lib.optional enableWayland wayland
    ++ lib.optional enableX11 libxcb
    ++ lib.optional enableXFCE xfce.xfconf;

  buildInputs =
    runtimeDependencies
    ++ lib.optional enableOpenCLModule opencl-headers
    ++ lib.optional enableX11 libX11;

  patches =
    [ ./fastfetch-detect-wrapped.patch ]
    ++ lib.optional (extraFlashfetchConf != null) [ ./flashfetch.patch ];

  postPatch = lib.optionalString (extraFlashfetchConf != null) ''
    substituteAllInPlace src/flashfetch.c
  '';

  cmakeFlags = [
    "-DCMAKE_INSTALL_SYSCONFDIR=${placeholder "out"}/etc"
  ];

  ldLibraryPath = lib.makeLibraryPath runtimeDependencies;

  postInstall = ''
    wrapProgram $out/bin/fastfetch --prefix LD_LIBRARY_PATH : "${ldLibraryPath}"
    wrapProgram $out/bin/flashfetch --prefix LD_LIBRARY_PATH : "${ldLibraryPath}"
  '';

  inherit extraFlashfetchConf;

  meta = with lib; {
    description = "Like neofetch, but much faster";
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
