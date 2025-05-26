{
  services.openssh.enable = true;
  services.actual.enable = true;

  services.deluge = {
    enable = true;
    group = "deluge";
    web = { 
      enable = true;
      openFirewall = true;
    };
    config = {
      share_ratio_limit = "1.0";
    };
    dataDir = "/media/deluge";
    openFirewall = true;
  };

  services.jellyfin = {
    enable = true;
    user="jellyfin";
    openFirewall = true;
    configDir = "/mnt/nas/jellyfin";
  };
  
  services.caddy = {
    enable = true;

  };

  services.static-web-server = {
  enable = true;
  listen = "[::]:80";
  root = "../website";
  configuration = {
    general = { 
      directory-listing = true;
    };
  };
};

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

}
