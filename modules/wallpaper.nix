{
  config,
  lib,
  pkgs,
  ...
}:

let
  relPath = "wallpapers/nord-wolf-and-lion.png";
  wallpaperFile = "${config.xdg.dataHome}/${relPath}";
in
{
  xdg.dataFile.${relPath}.source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/dharmx/walls/ed5864e529fe79d3c21d5b507e1c0273457094fa/nord/a_drawing_of_a_wolf_and_a_lion.png";
    hash = "sha256-fPaAJlujIHmE2StTBwCx0Hq/T8qpBhie0Nc8MeHwK1A=";
  };

  systemd.user.services.dms-wallpaper = {
    Unit = {
      Description = "Apply the repo default wallpaper once DMS is up";
      After = [ "dms.service" ];
      Requisite = [ "dms.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "/usr/bin/dms ipc call wallpaper set ${wallpaperFile}";
    };
    Install.WantedBy = [ "dms.service" ];
  };

  home.activation.dmsWallpaper = lib.hm.dag.entryAfter [ "reloadSystemd" ] ''
    ${config.systemd.user.systemctlPath} --user start dms-wallpaper.service >/dev/null 2>&1 ||
      echo "dms: not running, wallpaper will apply when it starts" >&2
  '';
}
