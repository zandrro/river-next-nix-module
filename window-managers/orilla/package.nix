{
  lib,
  rustPlatform,
  fetchFromSourcehut,
  pkg-config,
  wayland-scanner,
  wayland,
  libxkbcommon,
  wayland-protocols,
}:

let
  defaultConfig = ./default.toml;
in
rustPlatform.buildRustPackage {
  pname = "orilla";
  version = "unstable-2026-03-16";

  src = fetchFromSourcehut {
    owner = "~hokiegeek";
    repo = "orilla";
    rev = "bd77afb99a192c10211385df4555e68e786094fb";
    hash = "sha256-FwLKvIB4VXRhD0/1HpEdGwMp/EfGqTC2AfVs354uD3c=";
  };

  cargoHash = "sha256-fTKgRSDtV+5Dn4QAfBYsUbdaNj5GsVAwnYVwpw7VJms=";
  patches = [ ./xdg-config-path.patch ];

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
    install -Dm755 ${defaultConfig} $out/example/default.toml
  '';

}
