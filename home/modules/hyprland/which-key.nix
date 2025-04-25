{pkgs, inputs, config, ...}: {

  wayland.windowManager.hyprland = {
    settings = {
      plugins = { 
        hyprhook = {
          onSubmap = "~/.config/hypr/scripts/which-key.sh";
        };
      };
    };
    plugins = [
      inputs.hyprhook.packages.${pkgs.system}.hyprhook
    ];
  };

  home.file = let
    dotfiles = "${config.home.homeDirectory}/dotfiles";
    sym = dir: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/config/${dir}";
  in {
    ".config/which-key".source = sym "which-key";
  };

}
