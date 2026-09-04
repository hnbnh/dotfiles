{ pkgs, ... }:

let
  # virtio-gpu/virgl in the Linux guest exposes no desktop OpenGL core profile.
  # Use llvmpipe only for affected applications, leaving other apps on the real GPU.
  softwareGL = pkg: pkgs.symlinkJoin {
    name = "${pkg.pname}-software-gl";
    paths = [ pkg ];
    passthru = { inherit (pkg) pname version; };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/${pkg.meta.mainProgram} \
        --set-default LIBGL_ALWAYS_SOFTWARE 1
    '';
  };
in
{
  home.packages = with pkgs; [
    (softwareGL ghostty)
    (softwareGL kitty)
    calibre # marked broken on aarch64-darwin, so Linux-only
    inter # Noctalia's UI font; Fedora does not ship it
    keyd
    obs-studio
    papirus-icon-theme
    rofi
    satty # annotates what niri's built-in screenshot captures
    wl-clipboard # nvim's "+ register; Noctalia's clipboard is its own store
    xournalpp
    zathura
    zsh
  ];
}
