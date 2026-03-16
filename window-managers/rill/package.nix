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
  pname = "rill";
  version = "unstable-2026-02-20";

  src = fetchFromCodeberg {
    owner = "lzj15";
    repo = "rill";
    rev = "656d375bb40b961ad25efdadae8ee32412148906";
    hash = "sha256-GEhH8vJRTjDCUDD5oMV2m0HUvIlXdr4qUTtYJ/y3nKM=";
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
  ] ++ lib.optional withManpages scdoc;

  postInstall = ''
    install -Dm755 assets/config.zon -t $out/example/
  '';

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ] ++ [ "-Doptimize=ReleaseSafe" ];

})
