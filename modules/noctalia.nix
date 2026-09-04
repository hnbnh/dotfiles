# The Fedora package ships the binary but no user unit; niri starts
# graphical-session.target once it is up, which pulls this in.
{
  systemd.user.services.noctalia = {
    Unit = {
      Description = "Noctalia desktop shell";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "/usr/bin/noctalia";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
