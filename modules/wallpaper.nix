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

  # DMS keeps the wallpaper in session state, not in the settings.json this repo
  # tracks, so seed it here. Only when unset: a wallpaper picked in the dash has
  # to survive the next switch. session.json is a real file with a FileView
  # watching it, so this lands without restarting dms.
  home.activation.dmsWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    session="${config.xdg.stateHome}/DankMaterialShell/session.json"
    seed='if (.wallpaperPath // "") == "" then .wallpaperPath = $p else empty end'

    if [ ! -s "$session" ]; then
      new='{ "wallpaperPath": "${wallpaperFile}" }'
    elif ! new=$(${lib.getExe pkgs.jq} --arg p "${wallpaperFile}" "$seed" "$session"); then
      echo "dms: session.json does not parse, leaving the wallpaper alone" >&2
      new=""
    fi

    if [ -n "$new" ]; then
      mkdir -p "$(dirname "$session")"
      printf '%s\n' "$new" > "$session.new" && mv "$session.new" "$session"
    fi
  '';
}
