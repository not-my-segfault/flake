{pkgs, ...}: let
  # fabric-mc = pkgs.callPackage ../derivations/fabric-mc.nix { };
  forge-mc = pkgs.callPackage ../derivations/forge-mc.nix {};
in {
  services.minecraft-server = {
    enable = true;
    declarative = true;
    package = forge-mc;
    eula = true;
    whitelist = {
      jnats = "07d59f96-8b4e-49a8-9f14-9ec28d7efc5d";
      Karma_Koo = "bc4f61d4-3c36-42d1-8ad4-2d3b37e05f8b";
    };
    serverProperties = {
      difficulty = 2;
      max-players = 2;
      motd = "NixOS Modded Minecraft Server !";
    };
    jvmOpts = "java -Xms6144M -Xmx6144M -Dterminal.jline=false -Dterminal.ansi=true -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:InitiatingHeapOccupancyPercent=15";
  };

  networking.firewall.allowedTCPPorts = [25565];
}
