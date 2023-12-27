{pkgs}:
let

in {
  godot-wayland = pkgs.godot_4.overrideAttrs (old: rec {
    pname = "godot-wayland";
    version = "4.2.0-wayland";
    commitHash = "4a26acf156d1a6f5246733e3c4d037e13a69cb60";
    src = pkgs.fetchFromGitHub {
      owner = "Riteo";
      repo = "godot";
      rev = commitHash;
      hash = "sha256-e6D9Mx/ehI8ykceNq0GF/0Mf5vICamqjqohuhdFriRA=";
    };

    nativeBuildInputs = old.nativeBuildInputs ++ [pkgs.wayland-scanner];
    runtimeDependencies = old.runtimeDependencies ++ [pkgs.wayland-scanner];

    installPhase = ''
    mkdir -p "$out/bin"
    cp bin/godot.* $out/bin/godot

    installManPage misc/dist/linux/godot.6

    mkdir -p "$out"/share/{applications,icons/hicolor/scalable/apps}
    cp misc/dist/linux/org.godotengine.Godot.desktop "$out/share/applications/org.godotengine.Godot.desktop"
    substituteInPlace "$out/share/applications/org.godotengine.Godot.desktop" \
      --replace "Exec=godot" "Exec=$out/bin/godot" \
      --replace "Godot Engine" "Godot Engine (Wayland)"
    cp icon.svg "$out/share/icons/hicolor/scalable/apps/godot.svg"
    cp icon.png "$out/share/icons/godot.png"
  '';
  });
}
