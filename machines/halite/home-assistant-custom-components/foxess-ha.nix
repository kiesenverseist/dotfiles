{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  callPackage,
}:
buildHomeAssistantComponent rec {
  owner = "macxq";
  domain = "foxess";
  version = "v0.46";

  src = fetchFromGitHub {
    owner = "macxq";
    repo = "foxess-ha";
    tag = version;
    hash = "sha256-vOjmhps2UVUs5/GJV8kH/mx6slkhsG9IEaAIm9xpSe0=";
  };

  # dependencies = [ fake-useragent ];
  dependencies = [(callPackage ./random-user-agent.nix {})];

  meta = {
    changelog = "https://github.com/macxq/foxess_ha/releases/tag/${version}";
    description = "Home Assistant & FoxESS integration. Monitor you photovoltaic installation directly from HA";
    homepage = "https://github.com/macxq/foxess_ha";
    license = lib.licenses.mit;
  };
}
