{
  lib,
  stdenv,
  callPackage,
  fetchFromCodeberg,
  fetchFromGitHub,
  libGL,
  libx11,
  libevdev,
  libinput,
  libxkbcommon,
  pixman,
  pkg-config,
  scdoc,
  udev,
  versionCheckHook,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots_0_19,
  writeText,
  xwayland,
  zig_0_15,
  withManpages ? true,
  xwaylandSupport ? true,
}:

let
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
  pname = "river-next";
  version = "0.5.0-dev";
  outputs = [ "out" ] ++ lib.optionals withManpages [ "man" ];

  src = fetchFromCodeberg {
    owner = "river";
    repo = "river";
    rev = "7c9f32ba8a0227661ba1c1bbfe673f0d2b37af0a";
    hash = "sha256-gh2SdhMl6b6vGth7t+GjUDzfx1dN+JeC83wP/Ntj/3k=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
    xwayland
    zig_0_15
  ]
  ++ lib.optional withManpages scdoc;

  buildInputs = [
    libGL
    libevdev
    libinput
    libxkbcommon_13
    pixman
    udev
    wayland
    wayland-protocols
    wlroots_0_19
  ]
  ++ lib.optional xwaylandSupport libx11;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ]
  ++ lib.optional withManpages "-Dman-pages"
  ++ lib.optional xwaylandSupport "-Dxwayland"
  ++ [ "-Doptimize=ReleaseSafe" ];

  postInstall = ''
    install contrib/river.desktop -Dt $out/share/wayland-sessions
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  passthru = {
    providedSessions = [ "river" ];
  };

  meta = {
    homepage = "https://codeberg.org/river/river-classic";
    description = "Dynamic tiling wayland compositor";
    longDescription = ''
      River is a non-monolithic Wayland compositor.
      Unlike other Wayland compositors, river does not combine the compositor and window manager into one program.
      Instead, users can choose any window manager implementing the river-window-management-v1 protocol.
    '';
    changelog = "https://codeberg.org/river/river/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # Includes original maintainers when the file was used to generate the new version. Note: the release has now dropped on Nixpkgs.
      adamcstephens
      moni
      rodrgz
      dmkhitaryan
    ];
    mainProgram = "river";
    platforms = lib.platforms.linux;
  };
})
