{ pkgs, ... }:

let
  # ghostty's renderer is desktop OpenGL and it starts by setting
  # GDK_DISABLE=gles-api,vulkan, so GTK has only the EGL desktop-GL path left.
  # Against mesa 26.2.0 on this VM's virtio GPU that path yields no usable
  # config ("No EGL configuration available") and ghostty exits. Forcing
  # llvmpipe, mesa's CPU rasteriser, gets it a context; a terminal does not
  # miss the GPU. mesa 25.0.5 works unwrapped, so this reads like a mesa
  # regression rather than a missing capability -- drop the wrapper once a
  # later mesa renders ghostty on the GPU again.
  #
  # Wrapped rather than set in home.sessionVariables so obs-studio and the rest
  # keep the real GPU; --set-default leaves LIBGL_ALWAYS_SOFTWARE=0 as an
  # escape hatch.
  ghostty = pkgs.symlinkJoin {
    name = "ghostty-software-gl";
    paths = [ pkgs.ghostty ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/ghostty --set-default LIBGL_ALWAYS_SOFTWARE 1
    '';
  };
in
{
  home.packages = with pkgs; [
    calibre # marked broken on aarch64-darwin, so Linux-only
    ghostty
    keyd
    kitty
    obs-studio
    satty # annotates what niri's built-in screenshot captures
    wl-clipboard # nvim's "+ register; DMS's clipboard is its own store
    xournalpp
    zathura
    zsh
  ];
}
