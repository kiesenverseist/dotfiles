{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pymodbus,
}:

buildHomeAssistantComponent rec {
  owner = "nathanmarlor";
  domain = "foxess_modbus";
  version = "v1.14.0b3";

  src = fetchFromGitHub {
    owner = "nathanmarlor";
    repo = "foxess_modbus";
    tag = version;
    hash = "";
  };

  dependencies = [ pymodbus ];

  meta = {
    changelog = "https://github.com/nathanmarlor/foxess_modbus/releases/tag/${version}";
    description = "FoxESS inverter integration. Connect directly to your FoxESS inverter (no cloud!) for real-time status and control. ";
    homepage = "https://github.com/nathanmarlor/foxess_modbus";
    license = lib.licenses.mit;
  };
}
