{
  services.openssh.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  systemd.mounts = [{
      type = "nfs";
        mountConfig = {
          Options = "noatime";
      };
    what = "openmediavault.lan:/nas";
    where = "/mnt/nas";
  }];

  systemd.automounts = [{
    wantedBy = [ "multi-user.target" ];
    automountConfig = {
      TimeoutIdleSec = "0";
    };
    where = "/mnt/nas";
  }];

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };

}
