{...}: {
  perSystem = {pkgs, ...}: {
    packages.backstitch-launcher = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
      pname = "backstitch-launcher";
      version = "1.0.4";
      
      src = pkgs.fetchFromGitHub {
        owner = "inkandswitch";
        repo = "backstitch-launcher";
        tag = "v${finalAttrs.version}";
        hash = "sha256-ObrhgFPctl5AghsXWya/JrWor7Hyg7ouIRiOstOgDLs=";
      };

      cargoHash = "sha256-0DKEzuUxn54388oq35c0G9G5duYR5/lOttG45Aagrqo=";
      # cargoLock = {
      #   lockFile = ./Cargo.lock;
      #   allowBuiltinFetchGit = true;
      # };

      meta = {
        homepage = "https://backstitch.dev";
        mainProgram = "backstitch-launcher";
      };
    });
  };
}
