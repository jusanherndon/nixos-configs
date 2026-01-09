{ specialArgs, pkgs, ... }:
let
  inherit (specialArgs) CLOUDFLARE_API_TOKEN;
in
{
  environment.variables.CLOUDFLARE_API_TOKEN = builtins.readFile /mnt/nas/cloud_flare_api_token;

  services = {
    actual.enable = true;
    openssh.enable = true;
    rpcbind.enable = true;
    xserver = {
      videoDrivers = [ "modesetting" ];
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };
    jellyfin = {
      enable = true;
      user="jellyfin";
      openFirewall = true;
    };
    caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
        hash = "sha256-Dvifm7rRwFfgXfcYvXcPDNlMaoxKd5h4mHEK6kJ+T4A=";
      };
      virtualHosts = {
        "budget.jusanhomelab.com" = {
          extraConfig = ''
            reverse_proxy 127.0.0.1:3000
            tls {
              dns cloudflare ${CLOUDFLARE_API_TOKEN}
            }
          '';
        };
        "jellyfin.jusanhomelab.com" = {
          extraConfig = ''
            reverse_proxy 127.0.0.1:8096
            tls {
              dns cloudflare ${CLOUDFLARE_API_TOKEN}
            }
          '';
        };
        "public-jellyfin.jusanhomelab.com" = {
          extraConfig = ''
          reverse_proxy 127.0.0.1:8096
            tls {
              dns cloudflare ${CLOUDFLARE_API_TOKEN}
            }
          '';
        };
      };
    };
    #iperf3 = { 
      #enable = true;
      #extraFlags = [ "-D" ];
    #}; 
  };
  systemd = {
    mounts = [{
      type = "nfs";
        mountConfig = {
          Options = "noatime";
      };
      what = "openmediavault.fossheadscale.com:/nas";
      where = "/mnt/nas";
    }];

    automounts = [{
      wantedBy = [ "multi-user.target" ];
      automountConfig = {
        TimeoutIdleSec = "0";
      };
      where = "/mnt/nas";
    }];
  };
}
