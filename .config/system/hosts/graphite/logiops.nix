{pkgs, ...}: {
  # Install logiops package
  environment.systemPackages = [pkgs.logiops];

  # Create systemd service
  systemd.services.logiops = {
    description = "An unofficial userspace driver for HID++ Logitech devices";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.logiops}/bin/logid";
    };
  };

  # Configuration for logiops
  environment.etc."logid.cfg".text = ''
    devices: (
    {
      name: "Wireless Mouse MX Master 3";
      smartshift:
      {
        on: true;
        threshold: 15;
      };
      hiresscroll:
      {
        hires: true;
        invert: false;
        target: false;
      };
      dpi: 600;
      thumbwheel:
      {
        divert: true;
        invert: false;
        touch =
        {
          type: "Keypress";
          keys: ["KEY_LEFTMETA"];
        };
      };

      buttons: (
        { cid: 0xc4; action =
          {
            type: "Gestures";
            gestures: (
              {
                direction: "Up";
                mode: "OnFewPixels";
                pixels: 200;
                action =
                {
                  type: "Keypress";
                  keys: ["KEY_LEFTCTRL", "KEY_LEFTALT", "KEY_UP"];
                };
              },
              {
                direction: "Down";
                mode: "OnFewPixels";
                pixels: 200;
                action =
                {
                  type: "Keypress";
                  keys: ["KEY_LEFTCTRL", "KEY_LEFTALT", "KEY_DOWN"];
                };
              },
              {
                direction: "Right";
                mode: "OnRelease";
                action =
                {
                  type: "Keypress";
                  keys: ["KEY_LEFTMETA", "KEY_A"];
                };
              },
              {
                direction: "Left";
                mode: "OnRelease";
                action =
                {
                  type: "Keypress";
                  keys: ["KEY_LEFTMETA"];
                };
              },
              {
                direction: "None";
                mode: "OnRelease";
          action =
          {
                  type: "ToggleSmartshift";
          }
              }
            );
          };
        },
        { cid: 0xc3; action =
          {
            type: "Gestures";
            gestures: (
              {
                direction: "Up";
                mode: "OnRelease";
                action =
                {
                  type: "Keypress";
                  keys: ["KEY_LEFTMETA", "KEY_UP"];
                };
              },
              {
                direction: "Down";
                mode: "OnRelease";
                action =
                {
                  type: "Keypress";
                  keys: ["KEY_LEFTMETA", "KEY_DOWN"];
                };
              },
                        {
                direction: "Right";
                mode: "OnFewPixels";
                pixels: 200;
                action =
                {
                  type: "Keypress";
                  keys: ["KEY_LEFTMETA", "KEY_LEFTCTRL", "KEY_RIGHT"];
                };
              },
              {
                direction: "Left";
                mode: "OnFewPixels";
                pixels: 200;
                action =
                {
                  type: "Keypress";
                  keys: ["KEY_LEFTMETA", "KEY_LEFTCTRL", "KEY_LEFT"];
                };
              },
              {
                direction: "None";
                mode: "OnRelease";
                action =
                {
                  type: "Keypress";
                  keys: ["KEY_LEFTALT", "KEY_SPACE"];
                };
              }
            );
          };
        },
        { cid: 0x53; action =
          {
            type: "Gestures";
            gestures: (
              {
                direction: "Right";
                mode: "OnFewPixels";
                pixels: 200;
                action =
                {
                  type: "Keypress";
                  keys: ["KEY_BRIGHTNESSUP"];
                };
              },
              {
                direction: "Left";
                mode: "OnFewPixels";
                pixels: 200;
                action =
                {
                  type: "Keypress";
                  keys: ["KEY_BRIGHTNESSDOWN"];
                };
              },
              {
                direction: "Up";
                mode: "OnFewPixels";
                pixels: 200;
                action =
                {
                  type: "Keypress";
                  keys: ["KEY_VOLUMEUP"];
                };
              },
              {
                direction: "Down";
                mode: "OnFewPixels";
                pixels: 200;
                action =
                {
                  type: "Keypress";
                  keys: ["KEY_VOLUMEDOWN"];
                };
              },
              {
                direction: "None";
                mode: "OnRelease";
                action =
                {
                  type: "CycleDPI";
                  dpis: [1000, 2000, 3000, 4000];
                };
              }
            );
          };
        }
      );
    }
    );
  '';
}
