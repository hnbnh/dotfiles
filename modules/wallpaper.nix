{ pkgs, ... }:

{
  # Noctalia is pointed at this file by the vendored
  # modules/home/.config/noctalia/wallpaper.toml.
  xdg.dataFile."wallpapers/nord-wolf-and-lion.png".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/dharmx/walls/ed5864e529fe79d3c21d5b507e1c0273457094fa/nord/a_drawing_of_a_wolf_and_a_lion.png";
    hash = "sha256-fPaAJlujIHmE2StTBwCx0Hq/T8qpBhie0Nc8MeHwK1A=";
  };
}
