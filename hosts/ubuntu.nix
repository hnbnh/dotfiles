{
  system = { };

  home = {
    targets.genericLinux.enable = true;
    targets.genericLinux.gpu.enable = false;

    home.sessionPath = [ "/run/system-manager/sw/bin" ];
    xdg.systemDirs.data = [ "/run/system-manager/sw/share" ];
  };
}
