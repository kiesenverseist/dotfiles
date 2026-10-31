{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:
buildHomeAssistantComponent rec {
  owner = "macxq";
  domain = "foxess";
  version = "v0.59";

  src = fetchFromGitHub {
    owner = "macxq";
    repo = "foxess-ha";
    tag = version;
    hash = "sha256-NDdGg8P6TUQ651mVhaYt0vojknmphIweTSOEK50fMKk=";
  };

  meta = {
    changelog = "https://github.com/macxq/foxess_ha/releases/tag/${version}";
    description = "Home Assistant & FoxESS integration. Monitor you photovoltaic installation directly from HA";
    homepage = "https://github.com/macxq/foxess_ha";
    license = lib.licenses.mit;
  };
}
