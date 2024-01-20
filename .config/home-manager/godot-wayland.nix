{pkgs}:
let

in {
  godot-wayland = pkgs.godot_4.overrideAttrs (old: rec {
    pname = "godot-wayland";
    version = "4.2.0-wayland";
    commitHash = "12b7296457feaf9e7c2324e8669ee54c73f83506";
    src = pkgs.fetchFromGitHub {
      owner = "Riteo";
      repo = "godot";
      rev = commitHash;
      hash = "sha256-IvLuAT/yCfznLmA15jkgGmxBftukukd/JxwEkb+rrB0=";
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
