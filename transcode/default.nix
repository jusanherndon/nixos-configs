{ config, pkgs, specialArgs, ... }:
let
  inherit (specialArgs) CLOUDFLARE_API_TOKEN;
in
{
  imports =
    [ 
      ./../configuration.nix
      ./hardware-configuration.nix
    ];
  boot  = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
  environment = {
    sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD"; # Prefer the modern iHD backend
    variables.CLOUDFLARE_API_TOKEN = builtins.readFile /mnt/nas/cloud_flare_api_token;
    };
    systemPackages = with pkgs; [
      ffmpeg-full
      pciutils
      actual-server
      jellyfin
      jellyfin-web
      #immich
      #uv
      #iperf
    ];
  };
  networking = {
    networkmanager.enable = true;
    hostName = "transcode"; # Define your hostname.
    firewall.enable = false;
  };
  services = {
    actual.enable = true;
    xserver.videoDrivers = [ "modesetting" ];
    jellyfin = {
      enable = true;
      user="jellyfin";
      openFirewall = true;
    };
    #immich = {
    #  enable = true;
    #  host = "0.0.0.0";
    #  openFirewall = true;
    #  mediaLocation = "/mnt/nas/immich_migrated";
    #};
    caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
        hash = "sha256-Zls+5kWd/JSQsmZC4SRQ/WS+pUcRolNaaI7UQoPzJA0=";
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
        "immich.jusanhomelab.com" = {
          extraConfig = ''
            reverse_proxy 127.0.0.1:2283
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
  system.stateVersion = "25.11"; # Did you read the comment?
}
