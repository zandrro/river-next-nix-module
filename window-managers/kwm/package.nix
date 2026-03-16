{
lib,
stdenv,
fetchFromGitHub,
withBar ? true,
withCustomConfig ? false,
scdoc,
zig_0_15,
libxkbcommon,
wayland,
wayland-protocols,
callPackage,
pkg-config,
wayland-scanner,
pixman,
fcft,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kewuaa";
  version = "unstable-2026-03-16";

  src = fetchFromGitHub {
    owner = "kewuaa";
    repo = "kwm";
    rev = "ec2a001dffb2cca0078f5647171f99ec81677c2e";
    hash = "sha256-8L/TS5LkpQlzhwI/Q2t/A06Gt8iWyFMvz48jepKfyqs=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    zig_0_15
    wayland-scanner
    pkg-config
  ];
  buildInputs = [
    wayland
    wayland-protocols
    pixman
    fcft
    libxkbcommon
  ];

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ] ++ [ "-Doptimize=ReleaseSafe" ]
  ++ lib.optional withBar "-Dbar"
  ++ lib.optional withCustomConfig "-Dconfig"; #
})
