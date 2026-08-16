# Login screen. The greetd and tuigreet binaries come from Fedora, not
# nixpkgs: a nix-built greetd loads PAM modules from the nix store and so
# cannot use the host's pam_systemd/pam_selinux, which the session needs
# for a logind seat (and with it, access to the GPU). Only the config is
# managed here; install.sh enables Fedora's greetd.service in place of gdm.
{ ... }:

{
  environment.etc."greetd/config.toml" = {
    text = ''
      [terminal]
      vt = 1

      [default_session]
      # greetd runs the command through the user's shell, so zsh's .zshenv
      # (nix profile on PATH, home-manager session vars) applies to the
      # whole Hyprland session.
      command = "tuigreet --time --remember --cmd /home/hnbnh/.nix-profile/bin/Hyprland"
      user = "greetd"
    '';
    # Fedora's greetd package ships its own config.toml.
    replaceExisting = true;
  };
}
