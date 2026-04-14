{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  callPackage,
}:
buildHomeAssistantComponent rec {
  owner = "macxq";
  domain = "foxess";
  version = "v0.48beta1";

  src = fetchFromGitHub {
    owner = "macxq";
    repo = "foxess-ha";
    tag = version;
    hash = "sha256-xIRqYx8xodK+KC5EX6px4lfsl/pKYefjQIpYvM52Sfo=";
  };

  meta = {
    changelog = "https://github.com/macxq/foxess_ha/releases/tag/${version}";
    description = "Home Assistant & FoxESS integration. Monitor you photovoltaic installation directly from HA";
    homepage = "https://github.com/macxq/foxess_ha";
    license = lib.licenses.mit;
  };
}
