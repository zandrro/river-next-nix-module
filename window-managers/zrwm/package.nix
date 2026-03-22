{
  stdenv,
  fetchFromSourcehut,
  wayland,
  pkg-config,
  wayland-scanner,
  wayland-protocols,
  libxkbcommon,
  lib,
  git,
  fetchFromGitHub,
  writeText,
}:

let
  exampleConfig = ./init;
  libxkbcommon_13 = libxkbcommon.overrideAttrs (
    final: prev: {
      version = "1.13.1";
      src = fetchFromGitHub {
        owner = "xkbcommon";
        repo = "libxkbcommon";
        tag = "xkbcommon-${final.version}";
        hash = "sha256-wUsxsM0xXTg7nbvFMXrrnHherOepj0YI77eferjRgJA=";
      };
      patches = [
        (writeText "disable-x11com.patch" ''
          On nixpkgs /tmp/.X11-unix is not compatible with Xvfb requirement and the
          test fails.
          --- a/meson.build
          +++ b/meson.build
          @@ -1229,18 +1229,6 @@ if get_option('enable-x11')
                   env: test_env,
                   is_parallel : false,
               )
          -    test(
          -        'x11comp',
          -        executable(
          -            'test-x11comp',
          -            'test/x11comp.c',
          -            'test/utils-text.c',
          -            'test/utils-text.h',
          -            dependencies: x11_xvfb_test_dep
          -        ),
          -        env: test_env,
          -        is_parallel : false,
          -    )
           endif
           if get_option('enable-xkbregistry')
               test(
        '')
      ];
    }
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zrwm";
  version = "unstable-2026-03-16";

  src = fetchFromSourcehut {
    owner = "~zuki";
    repo = "zrwm";
    rev = "d36851012c15b81498900dfd68d6fc56cf828699";
    hash = "sha256-q0iOCaCWMaMWRQOTXRpo/SAPBQB0Nf+EdK+aapwP4+w=";
  };

  nativeBuildInputs = [
    wayland-scanner
    pkg-config
    git
  ];
  buildInputs = [
    wayland
    libxkbcommon_13
    wayland-protocols
  ];

  buildPhase = ''
    cc nob.c -o nob
    ./nob
  '';

  installPhase = ''
    install -Dm755 zrwm $out/bin/zrwm
    install -Dm755 zrwm-msg $out/bin/zrwm-msg
    install -Dm755 ${exampleConfig} $out/examples/init
  '';

  postPatch = ''
    substituteInPlace ipc.h \
      --replace \
        'init_file = malloc(sizeof(char) * (home_len + zrwm_init_text_len));' \
        'init_file = malloc(sizeof(char) * (home_len + zrwm_init_text_len + 1));'
  '';

  meta = {
    homepage = "https://git.sr.ht/~zuki/zrwm";
    description = "dwl-inspired window manager for river";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
})
