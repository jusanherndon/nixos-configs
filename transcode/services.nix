{
  services.actual.enable = true;
  services.openssh.enable = true;
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };
  services.rpcbind.enable = true;
  services.xserver.videoDrivers = [ "modesetting" ];
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
      hash = "sha256-Dvifm7rRwFfgXfcYvXcPDNlMaoxKd5h4mHEK6kJ+T4A=";
    };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  systemd.mounts = [{
      type = "nfs";
        mountConfig = {
          Options = "noatime";
      };
    what = "openmediavault.fossheadscale.com:/nas";
    where = "/mnt/nas";
  }];

  systemd.automounts = [{
    wantedBy = [ "multi-user.target" ];
    automountConfig = {
      TimeoutIdleSec = "0";
    };
    where = "/mnt/nas";
  }];

}
