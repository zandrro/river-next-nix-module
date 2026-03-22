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
      rev = "e6c6ac359f0331054f311d873ee7db52a3f84b0f";
      hash = "sha256-LLuPu51318aF7Z53K5Sko5FpjVSfMlSatfa8Y9/w1jU=";
    };

    cargoHash = "sha256-h5FTiU6zR0+w0KVnrjjaeQkSXOuCrQOXbZinJMLrNiY=";

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
    hash = "sha256-LLdH9NiKquFjrzly7uKnG/+QQKw+DA5khT6ggJx/SmM=";
  };
  packageRequires = [ reka ];

  passthru.reka-lib = reka;

  meta = {
    homepage = "https://code.tvl.fyi/about/tools/emacs-pkgs/reka";
    description = "Emacs-based window manager for river";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
}
