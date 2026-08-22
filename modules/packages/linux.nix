{ pkgs, ... }:

let
  # This VM's GPU is virtio-gpu, and mesa's virgl driver sits on top of ANGLE
  # -> Metal on the M2 host. That stack offers only OpenGL 2.1 compatibility
  # and OpenGL ES 3.0: eglinfo prints no "OpenGL core profile" section at all,
  # and glxinfo reports "Max core profile version: 0.0". Fedora's own mesa
  # 26.0.3 reports exactly the same, so the ceiling is the virtual GPU's, not
  # something nixpkgs picked. Both readings are mesa 26; what lifts this is a
  # virgl backend that exposes core profiles, not necessarily a mesa bump.
  #
  # Driver discovery is fine and this is not what nix-system-graphics fixes:
  # /run/opengl-driver resolves (modules/system) and eglinfo names virtio_gpu,
  # so nix programs do reach the real GPU -- it just cannot serve core profiles.
  #
  # So nothing that renders with desktop GL can get a context here: ghostty
  # sets GDK_DISABLE=gles-api,vulkan and then finds no EGL config, and kitty
  # asks for 3.3 core and gets EGL_BAD_MATCH ("Arguments are inconsistent"),
  # which GLFW reports as GLFW_VERSION_UNAVAILABLE. llvmpipe, mesa's CPU
  # rasteriser, does offer core 4.5, and a terminal does not miss the GPU.
  #
  # zink is not a way out: vulkaninfo finds only lavapipe here, no venus, so
  # GL-on-Vulkan would land on software Vulkan and be slower than llvmpipe.
  # A terminal that needs no core profile (foot, or alacritty on GLES 2.0)
  # would need no wrapper at all, if these two ever stop being worth it.
  #
  # Wrapped per program rather than set in home.sessionVariables so obs-studio
  # and the rest keep the real GPU; --set-default leaves LIBGL_ALWAYS_SOFTWARE=0
  # as an escape hatch. Both terminals' .desktop files exec a bare command name,
  # so launchers pick these wrappers up from PATH too.
  softwareGL = pkg: pkgs.symlinkJoin {
    name = "${pkg.pname}-software-gl";
    paths = [ pkg ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/${pkg.meta.mainProgram} \
        --set-default LIBGL_ALWAYS_SOFTWARE 1
    '';
  };
in
{
  home.packages = with pkgs; [
    calibre # marked broken on aarch64-darwin, so Linux-only
    (softwareGL ghostty)
    keyd
    (softwareGL kitty)
    obs-studio
    satty # annotates what niri's built-in screenshot captures
    wl-clipboard # nvim's "+ register; DMS's clipboard is its own store
    xournalpp
    zathura
    zsh
  ];
}
