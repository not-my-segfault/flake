{
  pkgs,
  lib,
  ...
}: let
  server = {
    name = "SoftServe Git Forge";
    host = "soft";
    port = 23231;
    anonAccess = "read-write";
    allowKeyless = true;
    users = [
      {
        name = "michal";
        admin = true;
        publicKeys = [
          "key"
        ];
      }
    ];
  };
  userConstruct = {
    name,
    admin ? false,
    publicKeys ? [],
    collabRepos ? [],
  }: ''
    - name: "${name}"
      admin: ${
      if admin
      then "true"
      else "false"
    }
      ${
      if publicKeys != []
      then "public-keys:  ${lib.concatStringsSep "\n    - " ([""] ++ publicKeys)}"
      else ""
    }
      ${
      if collabRepos != []
      then "collab-repos: ${lib.concatStringsSep "\n    - " ([""] ++ collabRepos)}"
      else ""
    }
  '';
  userList = lib.forEach server.users userConstruct;
in {
  environment.systemPackages = with pkgs; [
    soft-serve
  ];

  networking.firewall = {
    allowedTCPPorts = [server.port];
  };

  environment.etc."soft-serve.yml".text = ''
    # Basic config
    name: "${server.name}"
    host: "${server.host}"
    port:  ${toString server.port}

    # Security
    anon-access:   "${server.anonAccess}"
    allow-keyless:  ${toString server.allowKeyless}

    # User setup
    users:
    ${lib.concatStrings userList}
  '';
}
