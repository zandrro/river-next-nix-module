{
  stdenv,
  fetchFromGitLab,
  wayland,
  pkg-config,
  wayland-scanner,
  wayland-protocols,
  libxkbcommon,
  gnumake,
  libbsd,
  libscfg,
  libevdev,
  pixman,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "tarazed";
  src = fetchFromGitLab {
    domain = "gitlab.gwdg.de";
    owner = "leonhenrik.plickat";
    repo = "tarazed";
    rev = "cd8dddf40db77006ebd91e8393f3cc8b07a41b9b";
    hash = "sha256-FQit/nffkwNIOVu+ws105UpA4i5R6MyVimLtaFJe3Rc=";
  };

  nativeBuildInputs = [
    wayland-scanner
    pkg-config
    gnumake
  ];
  buildInputs = [
    wayland
    libbsd
    libscfg
    libevdev
    pixman
    libxkbcommon
    wayland-protocols
  ];

  installPhase = ''
    install -Dm755 tarazed $out/bin/tarazed
  '';
})
