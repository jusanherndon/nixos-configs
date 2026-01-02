{ inputs, config, pkgs, specialArgs, ... }:

let
  inherit (specialArgs) CLOUDFLARE_API_TOKEN;
in
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ./services.nix
      ./users.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.supportedFilesystems = [ "nfs" ];
  boot.loader.grub.useOSProber = true;
  networking.networkmanager.enable = true;
  networking.hostName = "nixos"; # Define your hostname.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.rpcbind.enable = true; 

  environment.variables.CLOUDFLARE_API_TOKEN = builtins.readFile /mnt/nas/cloud_flare_api_token;

  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
          LC_ADDRESS = "en_US.UTF-8";
          LC_IDENTIFICATION = "en_US.UTF-8";
          LC_MEASUREMENT = "en_US.UTF-8";
          LC_MONETARY = "en_US.UTF-8";
          LC_NAME = "en_US.UTF-8";
          LC_NUMERIC = "en_US.UTF-8";
          LC_PAPER = "en_US.UTF-8";
          LC_TELEPHONE = "en_US.UTF-8";
          LC_TIME = "en_US.UTF-8";
      };
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    git
    deluged
    jellyfin
    jellyfin-web
    actual-server
    caddy
    nssTools
    tailscale
    immich
  ];

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
    virtualHosts."budget.jusanhomelab.com" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:3000
        tls {
            dns cloudflare ${CLOUDFLARE_API_TOKEN}
        }
      '';
    };
    virtualHosts."jellyfin.jusanhomelab.com" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:8096
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
    virtualHosts."public-jellyfin.jusanhomelab.com" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:8096
        tls {
            dns cloudflare ${CLOUDFLARE_API_TOKEN}
        }
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 2283 3000 8000 8081 8112 8096 ];
  networking.firewall.allowedUDPPorts = [ 80 443 2283 3000 8000 8081 8112 8096 ];
  system.stateVersion = "24.11";
}
