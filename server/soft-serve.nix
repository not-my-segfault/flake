{ pkgs, lib, ... }:

let
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
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAwgkEpWmDGQiOK+N5MxXdBYDIIr6DNn52UAKqY0dnxyYw1aATyChe1etqeWN/e6DH6g9yc3BvG6lV21pCVmqc3CyrxfsgQnCBU8ziUi8xk9dmdbSyZoEnETY2DGX3oWmYOlNQsbSa8IBa4iwbW5lLpdvowaka9TEmTGsNafkx8fPMhK4cdD0RsAsCg1pFCskHOxBZzrgV5HL2aMLy2Ys+4DqWOPXIY3pXsVjzdi3YVW59oXaNNd+NC8pqM3HiR2X4WS+/F5s1yIJE8G7TeC7mSqa68K6pfPAjzyHe/4ZzcyYkuOEe4KSxsPwNGGCXoYEaCMb2v7jgxWWZxedvBC1psSiFj01AAZBWl2fwSIOa88LwGtdtA/LOz5aOdHmxtZ8NwwGtx+mWz31eWUEMUEc72XMn7XdP++yvdlVsZg+bat2NryjO8+iCpz8opfqZ9r5f4EDkXFPcFMMwjUAFUUk0hv008vwhuudEwcuqgFzyt23aWOQFxTVAtD4OHYvKYCF1JkVYuZnpzDY2I2zUZ+749kYyUm+aWae+fE54FvyX0yO3M08GNizUn0X578HhICgZJlo09ewy9dIKQtsoVZPFGyr+jDqJJkJFbCkLwwxUIiijz16olrFD3UpscF+oiEVzkJ+9ClXvcbArqu1KtZ+2TrjFhk1o23ukmxZrjSEKkQ== cardno:16 179 196"
        ];
      }
      {
        name = "swift";
        publicKeys = [ "swiftkey" ];
        collabRepos = [ "test-repo" ];
      }
    ];
  };
  userConstruct = {
    name,
    admin ? false,
    publicKeys ? [],
    collabRepos ? []
  } : ''
          - name: "${name}"
            admin: ${if admin then "true" else "false"}
            ${if publicKeys  != [] then "public-keys:  ${lib.concatStringsSep "\n    - " ([""] ++ publicKeys)}"  else ""}
            ${if collabRepos != [] then "collab-repos: ${lib.concatStringsSep "\n    - " ([""] ++ collabRepos)}" else ""}
      '';
  userList =
    lib.forEach server.users (user: 
      userConstruct user
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
