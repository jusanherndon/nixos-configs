{
  services.openssh.enable = true;
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };
  services.rpcbind.enable = true;
  services.xserver.videoDrivers = [ "modesetting" ];

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
