{
  lib,
  stdenv,
  fetchFromCodeberg,
  withManpages ? true,
  scdoc,
  zig_0_15,
  libxkbcommon,
  wayland,
  wayland-protocols,
  callPackage,
  pkg-config,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "machi";
  version = "0.1.0-dev";

  src = fetchFromCodeberg {
    owner = "machi";
    repo = "machi";
    rev = "4e0c62052f86626ece406b295c5539eb55639250";
    hash = "sha256-NwqKwwXFFShP5GMNWqYEwOX3pkqUdF312Gv6PblPcxs=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    zig_0_15
    wayland-scanner
    pkg-config
  ];
  buildInputs = [
    libxkbcommon
    wayland
    wayland-protocols
  ]
  ++ lib.optional withManpages scdoc;

  postInstall = ''
    install -Dm755 example/machi.ini -t $out/example/
  '';

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ]
  ++ [ "-Doptimize=ReleaseSafe" ];

  meta = {
    homepage = "https://codeberg.org/machi/machi";
    description = "River-based window manager with cascading windows, horizontal panels and vertical workspaces";
    longDescription = ''
      Machi（町）is a minimalist window manager with cascading windows, horizontal panels and vertical workspaces.
      It works on top of river's window management protocol.Offers single-view and split view modes.
    '';
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
})
