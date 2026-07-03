{ username, ... }:
{
  wsl = {
    enable = true;
    defaultUser = username;
    useWindowsDriver = true;
    startMenuLaunchers = true;

    wslConf = {
      automount = {
        enabled = true;
        root = "/mnt";
        options = "metadata,uid=1000,gid=100,umask=022,fmask=011";
      };
      boot.systemd = true;
      interop = {
        enabled = true;
        appendWindowsPath = true;
      };
      network = {
        generateHosts = true;
        generateResolvConf = true;
      };
    };
  };

  services.openssh.enable = true;
}
