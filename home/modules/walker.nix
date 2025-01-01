{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    walker.enable = lib.mkEnableOption "enables walker program runner";
  };

  imports = [
    inputs.walker.homeManagerModules.default
  ];

  config = lib.mkIf config.walker.enable {

    programs.walker = {
      enable = true;
      runAsService = true;
      package = pkgs.walker;

      theme.layout = {
        ui = {
          anchors = {
            top = true;
            bottom = true;
            left = true;
            right = true;
          };
          window = {
            box = {
              h_align = "center";
              margins = {
                bottom = 200;
                top = 200;
              };
              orientation = "vertical";
              width = 400;
              scroll = {
                list = {
                  always_show = true;
                  item = {
                    activation_label = {
                      width = 20;
                      x_align = 1;
                    };
                    icon = {
                      theme = "Papirus";
                    };
                    spacing = 5;
                    text = {
                      revert = true;
                    };
                  };
                  max_height = 300;
                  max_width = 400;
                  min_width = 400;
                  width = 400;
                };
              };
              search = {
                spacing = 10;
                v_align = "start";
                width = 400;
              };
              spacing = 10;
              v_align = "center";
            };
            h_align = "fill";
            v_align = "fill";
          };
        };
      };

      theme.style = ''
#window,
#box,
#search,
#password,
#input,
#typeahead,
#spinner,
#list,
child,
scrollbar,
slider,
#item,
#text,
#label,
#bar,
#listplaceholder,
#sub,
#activationlabel {
  all: unset;
}

#window {
  background: none;
}

#box {
  background: #303446;
  padding: 16px;
  padding-top: 0px;
  border-radius: 8px;
  box-shadow:
    0 19px 38px rgba(0, 0, 0, 0.3),
    0 15px 12px rgba(0, 0, 0, 0.22);
}

scrollbar {
  background: none;
  padding-left: 8px;
}

slider {
  min-width: 2px;
  background: #7f849c;
  opacity: 0.5;
}

#search {
}

#password,
#input,
#typeahead {
  background: #363a4f;
  background: none;
  box-shadow: none;
  border-radius: 0px;
  border-radius: 32px;
  color: #c6d0f5;
  padding-left: 12px;
  padding-right: 12px;
}

#input {
  background: none;
}

#input > *:first-child,
#typeahead > *:first-child {
  color: #7f849c;
  margin-right: 7px;
}

#input > *:last-child,
#typeahead > *:last-child {
  opacity: 0;
}

#spinner {
}

#typeahead {
  color: #89b4fa;
}

#input placeholder {
  opacity: 0.5;
}

#list {
}

#listplaceholder {
  color: #cad3f5;
}

child {
  border-radius: 8px;
  color: #cad3f5;
  padding: 4px;
}

child:selected,
child:hover {
  background: #414559;
  box-shadow: none;
  color: #cad3f5;
}

#item {
}

#icon {
}

#text {
}

#label {
  font-weight: bold;
  color: #cad3f5;
}

#sub {
  opacity: 0.5;
  color: #cad3f5;
}

#activationlabel {
  opacity: 0.5;
  padding-right: 4px;
}

.activation #activationlabel {
  font-weight: bold;
  color: #89b4fa;
  opacity: 1;
}

.activation #text,
.activation #icon,
.activation #search {
}
      '';

    };

  };
}
