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
    rev = "1a443d7c5d45304bb96c3f1b6a9f4e0cd2ea18a0";
    hash = "sha256-B2ppssvdO986E7daEMk8TDPEhSaQR1VkwlnCJUtDcDQ=";
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
    install -Dm755 example/machi.ini -t $out/example/
  '';

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ] ++ [ "-Doptimize=ReleaseSafe" ];

})
