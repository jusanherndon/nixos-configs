{ config, pkgs, specialArgs, ... }:

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
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  services.rpcbind.enable = true; # needed for NFS

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
    cloudflared
    static-web-server
  ];

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
      hash = "sha256-Gsuo+ripJSgKSYOM9/yl6Kt/6BFCA6BuTDvPdteinAI=";
    };
      config = ''
        *.jusanhomelab.com {
          tls {
            dns cloudflare ${CLOUDFLARE_API_TOKEN}
          } 

          @budget budget.jusanhomelab.com
	  handle @budget{
            reverse_proxy 127.0.0.1:3000
          }
        }
     '';
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 3000 8000 8096 ];
  networking.firewall.allowedUDPPorts = [ 80 443 3000 8000 8096 ];
  system.stateVersion = "24.11"; 
}
