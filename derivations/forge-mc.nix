{ pkgs, stdenv, fetchurl }:

let
  mcVersion = "1.12.2";
  forgeVersion = "14.23.5.2860";
  archive = fetchurl {
    url =
      "https://tar.black/site/secret/forge-${mcVersion}-${forgeVersion}.tar.gz";
    sha256 = "zhuI3jOROttJ4dmsDUo/yevgkcL4V0nEYJi5aHAXoGw=";
  };
in stdenv.mkDerivation {
  pname = "forge-mc";
  version = "${mcVersion}-${forgeVersion}";

  preferLocalBuild = true;

  dontUnpack = true;
  dontConfigure = true;

  buildPhase = ''
    cat > minecraft-server << EOF
    #!${pkgs.bash}/bin/sh
    exec ${pkgs.jre8}/bin/java \''${@:2} -jar $out/share/forge-mc/forge-${mcVersion}-${forgeVersion}.jar nogui
  '';

  installPhase = ''
    mkdir ar/
    tar -xv --no-same-owner -f ${archive} -C ar/

    mkdir -p $out/share/forge-mc
    cp -r ar/forge-${mcVersion}-${forgeVersion}/* $out/share/forge-mc/

    install -Dm555 -t $out/bin minecraft-server
  '';

}
