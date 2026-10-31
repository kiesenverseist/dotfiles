{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  bbpb
}:

buildHomeAssistantComponent rec {
  owner = "sjmotew";
  domain = "narwal";
  version = "v1.0.11";

  src = fetchFromGitHub {
    owner = "sjmotew";
    repo = "NarwalIntegration";
    tag = version;
    hash = "sha256-3tApVG0foVOF2jg5sQY/ERHv2e9KBE9ax9HeXbIJNZk=";
  };

  dependencies = [ bbpb ];

  meta = {
    changelog = "https://github.com/sjmotew/NarwalIntegration/releases/tag/${version}";
    description = "Home Assistant custom integration for Narwal Flow robot vacuum — fully local, no cloud";
    homepage = "https://github.com/sjmotew/NarwalIntegration";
    license = lib.licenses.mit;
  };
}
