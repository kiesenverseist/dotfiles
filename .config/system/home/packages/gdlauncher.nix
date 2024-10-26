{pkgs}: let
  name = "gdlauncher";
  src = pkgs.fetchurl {
    url = "https://github.com/gorilla-devs/GDLauncher/releases/download/v1.1.30/GDLauncher-linux-setup.AppImage";
    sha256 = "00rzv0i4g701v9ssy55lg7sjddrgfnf0mdq5x85c1831xkfx7ig1";
  };
  # exec = pkgs.appimageTools.wrapType1 { inherit name src; };
  contents = pkgs.appimageTools.extractType2 {inherit name src;};
in
  pkgs.appimageTools.wrapType2 {
    inherit name src;

    extraInstallCommands = ''
      install -Dm444 ${contents}/${name}.desktop -t $out/share/applications
      install -Dm444 ${contents}/${name}.png -t $out/share/pixmaps
      substituteInPlace $out/share/applications/${name}.desktop \
        --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${name} --no-sandbox'
    '';
  }
# desktop = pkgs.makeDesktopItem {
#   name = "gdlauncher";
#   desktopName = "GDLauncher";
#   exec = "gdlauncher --no-sandbox";
# };

