{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wayland-scanner,
  wayland,
  libxkbcommon,
  withWev ? false,
  withWlrRandr ? false,
  wev,
  wlr-randr,
}:
let
  exampleConfig = ./rrwm.toml;
in
rustPlatform.buildRustPackage {
  pname = "rrwm";
  version = "unstable-2026-03-16";

  src = fetchFromGitHub {
    owner = "cap153";
    repo = "rrwm";
    rev = "42a709f7240c2ef6a67d0258127cb460dd20f17e";
    hash = "sha256-8uIB+kpqWvK7O1Gb0HwO6oaNecFcXyT9KJcqk5vElDc=";
  };

  cargoHash = "sha256-8OiF34Aa/jH82MAcQ5HnIW+4Bi9wLK904kfJvdHVrEc=";

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    libxkbcommon
  ]
  ++ lib.optional withWev wev
  ++ lib.optional withWlrRandr wlr-randr;

  postInstall = ''
    install -Dm755 $src/example/waybar_example_config.jsonc $out/example
    install -Dm755 $src/example/rrwm.desktop $out/local/share/wayland-sessions
    install -Dm755 ${exampleConfig} $out/example
  '';

  meta = {
    homepage = "https://github.com/cap153/rrwm";
    description = "Tiling window manager with a cosmic/bspwm layout";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
}
