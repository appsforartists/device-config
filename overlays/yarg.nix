final: prev: {
  yarg = prev.yarg.overrideAttrs (oldAttrs: {
    version = "0-unstable-2025-01-31";

    src = prev.fetchzip {
      url = "https://github.com/YARC-Official/YARG-BleedingEdge/releases/download/b2896/YARG_b2896-Linux-x64.zip";
      stripRoot = false;
      hash = "sha256-rHokdlsJ0xnVL+MqMgmt79Nv9HhXPbFqh+5cMZ+i72g=";
    };
  });
}