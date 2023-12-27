
{pkgs}:
let 
  name = "alvr";
  src = pkgs.fetchurl {
    url = "https://github.com/alvr-org/ALVR/releases/download/v20.5.0/ALVR-x86_64.AppImage";
    sha256 = "068xmz6rlfc7267zr3zc1z9ndsrpxwvhk0zz8v6y65xzybfks45j";
  };
  # exec = pkgs.appimageTools.wrapType1 { inherit name src; };
  contents = pkgs.appimageTools.extractType2 {inherit name src;};
in 
pkgs.appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    install -Dm444 ${contents}/${name}.desktop -t $out/share/applications
    install -Dm444 ${contents}/${name}.png -t $out/share/pixmaps
  '';
    # substituteInPlace $out/share/applications/${name}.desktop \
    #   --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${name} --no-sandbox'
}
