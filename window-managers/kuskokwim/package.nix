{
  python3Packages,
  fetchFromCodeberg,
  wayland,
  wayland-protocols,
  wayland-scanner,
  pkg-config,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "kuskokwim";
  version = "unstable-2026-03-16";

  pyproject = true;

  src = fetchFromCodeberg {
    owner = "ricci";
    repo = "kuskokwim";
    rev = "3ff9cab59235a55f4d88da1e1edea577e2d7ea45";
    hash = "sha256-R1Yp3jcgXeCNtdIM67AyN7pm/MH8c66SbCz6yOm1I10=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  nativeBuildInputs = [
    wayland-scanner
    pkg-config
  ];

  buildInputs = [
    wayland
    wayland-protocols
  ];

  dependencies = [
    python3Packages.pillow
    python3Packages.pydantic
    python3Packages.xkbcommon
  ];

  postInstall = ''
    install -Dm755 $src/config.example.toml -t $out/example/config.toml
  '';

  doCheck = false;
})
