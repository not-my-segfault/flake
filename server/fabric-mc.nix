with (import <nixpkgs> {});

let
  mcVersion = "1.18.2";
  fabricVersion = "0.14.5";
  installerVersion = "0.10.2";
  jar = fetchurl {
    url = "https://meta.fabricmc.net/v2/versions/loader/${mcVersion}/${fabricVersion}/${installerVersion}/server/jar";
    sha256 = "7TEK52q0uD+cVRcRVxcQP7BP9IMyY1IuxBf8YS0uG1E=";
  };
in stdenv.mkDerivation {
  pname = "fabric-mc";
  version = "${mcVersion}v${fabricVersion}";

  preferLocalBuild = true;

  dontUnpack = true;
  dontConfigure = true;

  buildPhase = ''
    cat > minecraft-server << EOF
    #!${bash}/bin/sh
    exec ${jre}/bin/java \$@ -jar $out/share/fabric-mc/fabric-server-mc.${mcVersion}-loader.${fabricVersion}-launcher.${installerVersion}.jar nogui
  '';

  installPhase = ''
    install -Dm444 ${jar} $out/share/fabric-mc/fabric-server-mc.${mcVersion}-loader.${fabricVersion}-launcher.${installerVersion}.jar
    install -Dm555 -t $out/bin minecraft-server
  '';

}
