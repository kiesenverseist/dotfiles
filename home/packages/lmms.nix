{pkgs}: let
  name = "lmms";
  src = pkgs.requireFile {
    name = "lmms-1.3.0-alpha.1.431+gca9e98959-linux-x86_64.AppImage";
    url = "https://github.com/LMMS/lmms/suites/16996172402/artifacts/970795165";
    sha256 = "c65d47f80f2d3e1751e401e583029d9aeafe50d789c0e762dd90455fd63f45eb";
  };
  # exec = pkgs.appimageTools.wrapType1 { inherit name src; };
  contents = pkgs.appimageTools.extractType1 {inherit name src;};
in
  pkgs.appimageTools.wrapType1 {
    inherit name src;

    extraPkgs = pkgs:
      with pkgs; [
        carla
        alsa-lib
        fftwFloat
        fltk13
        fluidsynth
        lame
        libgig
        libjack2
        libpulseaudio
        libsamplerate
        libsndfile
        libsoundio
        libvorbis
        portaudio
        libsForQt5.qt5.qtbase
        libsForQt5.qt5.qtx11extras
        SDL2
      ];

    extraInstallCommands = ''
      install -Dm444 ${contents}/${name}.desktop -t $out/share/applications
      install -Dm444 ${contents}/${name}.png -t $out/share/pixmaps
      substituteInPlace $out/share/applications/${name}.desktop \
        --replace 'Exec=lmms.real' 'Exec=env QT_QPA_PLATFORM="xcb" lmms.real'
    '';
  }
