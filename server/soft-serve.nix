{ pkgs, lib, ... }:

let
  server = {
    name = "tar.black SoftServe Git Forge";
    host = "soft";
    port = 23231;
    anonAccess = "read-write";
    allowKeyless = true;
    users = [
      {
        name = "michal";
        admin = true;
        publicKeys = [ 
          "" 
        ];
        collabRepos = [];
      }
    ];
  };
  userConstruct = {
    name,
    admin ? false,
    publicKeys,
    collabRepos
  } : ''
          - name: "${name}"
            admin: ${toString admin}
            ${if publicKeys  != [] then "public-keys:  ${lib.intersperse "\n      - " publicKeys}"  else ""}
            ${if collabRepos != [] then "collab-repos: ${lib.intersperse "\n      - " collabRepos}" else ""}
      
  '';
  userList =
    lib.forEach server.users (user: 
      userConstruct { user.name, user.admin, user.publicKeys, user.collabRepos }
    );
in
{
  environment.systemPackages = with pkgs; [
    soft-serve  
  ];
  
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
