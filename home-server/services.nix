{pkgs, specialArgs, ...}:
let
  inherit (specialArgs) CLOUDFLARE_API_TOKEN;
in
{
  environment.variables.CLOUDFLARE_API_TOKEN = builtins.readFile /mnt/nas/cloud_flare_api_token;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.openssh.enable = true;

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

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
      hash = "sha256-Dvifm7rRwFfgXfcYvXcPDNlMaoxKd5h4mHEK6kJ+T4A=";
    };
    virtualHosts."immich.jusanhomelab.com" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:2283
        tls {
            dns cloudflare ${CLOUDFLARE_API_TOKEN}
        }
      '';
    };
    virtualHosts."deluge.jusanhomelab.com" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:8112
        tls {
            dns cloudflare ${CLOUDFLARE_API_TOKEN}
        }
      '';
    };
  };

  services.immich = {
    enable = true;
    host = "0.0.0.0";
    openFirewall = true;
    mediaLocation = "/mnt/nas/immich";
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

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };

}
