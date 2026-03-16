{
lib,
stdenv,
fetchFromCodeberg,
zig_0_15,
libxkbcommon,
wayland,
wayland-protocols,
callPackage,
pkg-config,
wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rhine";
  version = "unstable-2026-03-16";

  src = fetchFromCodeberg {
    owner = "Sivecano";
    repo = "rhine";
    rev = "33b491cc8291510f846a695ef73468e8c63d36c5";
    hash = "sha256-h74l11CNwD4AxU39deAGge+72VvPMgi4zcV1GHntAl4=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    zig_0_15
    wayland-scanner
    wayland-protocols
    pkg-config
  ];
  buildInputs = [
    libxkbcommon
    wayland
  ];

  postInstall = ''
    install -Dm755 $src/config.rh -t $out/examples/
  '';

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ] ++ [ "-Doptimize=ReleaseSafe" ];

})
