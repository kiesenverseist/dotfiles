{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook,
  gtk3,
  libdbusmenu-gtk3,
  librsvg,
  withWayland ? false,
  gtk-layer-shell,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "eww";
  version = "unstable-2023-08-18";

  src = fetchFromGitHub {
    owner = "hylophile";
    repo = "eww";
    rev = "2bfd3af0c0672448856d4bd778042a2ec28a7ca7";
    hash = "sha256-t62kQiRhzTL5YO6p0+dsfLdQoK6ONjN47VKTl9axWl4=";
  };

  cargoHash = "sha256-3B81cTIVt/cne6I/gKBgX4zR5w0UU60ccrFGV1nNCoA=";

  nativeBuildInputs = [pkg-config wrapGAppsHook];

  buildInputs = [gtk3 librsvg libdbusmenu-gtk3] ++ lib.optional withWayland gtk-layer-shell;

  buildNoDefaultFeatures = true;
  buildFeatures = [
    (
      if withWayland
      then "wayland"
      else "x11"
    )
  ];

  cargoBuildFlags = ["--bin" "eww"];

  cargoTestFlags = cargoBuildFlags;

  # requires unstable rust features
  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    description = "ElKowars wacky widgets";
    homepage = "https://github.com/elkowar/eww";
    license = licenses.mit;
    maintainers = with maintainers; [figsoda lom];
    mainProgram = "eww";
    broken = stdenv.isDarwin;
  };
}
