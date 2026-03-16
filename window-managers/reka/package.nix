{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  pkg-config,
  wayland-scanner,
  wayland,
  libxkbcommon,
  wayland-protocols,
  emacsPackages,
  fetchurl,
}: # Packaging approach adopted from https://codeberg.org/tazjin/reka/src/branch/canon/default.nix

let
reka = rustPlatform.buildRustPackage {
    pname = "reka-lib";
    version = "unstable-2026-03-16";

    src = fetchFromCodeberg {
      owner = "tazjin";
      repo = "reka";
      rev = "8441e6eaf4b76f7085a25d3dafa0ef281d4cb009";
      hash = "sha256-KXAClKjYfkit6n89YTZ83qzp4n81bEXZ2cFGliZZOxQ=";
    };

    cargoHash = "sha256-qSyx2tzWMBr56Lbdjy+DJVuaHJmtxzKlFZivG7VA1d8=";

    nativeBuildInputs = [
      pkg-config
      wayland-scanner
    ];

    buildInputs = [
      wayland
      libxkbcommon
      wayland-protocols
    ];

    postInstall = ''
      mkdir -p $out/share/emacs/site-lisp
      ln -s $out/lib/libreka.so $out/share/emacs/site-lisp/libreka.so
    '';
  };
in
emacsPackages.trivialBuild {
  pname = "reka";
  version = "unstable-2026-03-16";
  src = fetchurl {
    url = "https://codeberg.org/tazjin/reka/raw/branch/canon/lisp/reka.el";
    hash = "sha256-K4uk1Zuct0xpth/MyJNbhJ+qm2yia0zDoNplA/YX1kU=";
  };
  packageRequires = [ reka ];

  passthru.reka-lib = reka;
}
