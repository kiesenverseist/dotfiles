{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:
buildHomeAssistantComponent rec {
  owner = "macxq";
  domain = "foxess";
  version = "v0.48beta2";

  src = fetchFromGitHub {
    owner = "macxq";
    repo = "foxess-ha";
    tag = version;
    hash = "sha256-/6nUiAKRHLANOPRpJIJB5Q8V2CUVf3QotzAtCxxv4X0=";
  };

  meta = {
    changelog = "https://github.com/macxq/foxess_ha/releases/tag/${version}";
    description = "Home Assistant & FoxESS integration. Monitor you photovoltaic installation directly from HA";
    homepage = "https://github.com/macxq/foxess_ha";
    license = lib.licenses.mit;
  };
}
