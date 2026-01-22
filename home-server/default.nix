{ inputs, config, pkgs, specialArgs, ... }:
let
  inherit (specialArgs) CLOUDFLARE_API_TOKEN;
in
{
  environment.variables.CLOUDFLARE_API_TOKEN = builtins.readFile /mnt/nas/cloud_flare_api_token;
  imports =
    [
      ./../configuration.nix
      ./hardware-configuration.nix
      ./services.nix
    ];
  boot = { 
    loader = {
      grub = {
        enable = true;
        device = "/dev/sda";
        useOSProber = true;
      };
    };
  };
  networking = {
    hostName = "nixos"; 
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [ 2283 8112 ];
      allowedUDPPorts = [ 2283 8112 ];
    };
  };
  environment.systemPackages = with pkgs; [
    deluged
    immich
  ];
  users.users = {
      deluge = {
        extraGroups = [ "deluge" ];
      };
  };
  services = {
    deluge = {
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
    caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
        hash = "sha256-Zls+5kWd/JSQsmZC4SRQ/WS+pUcRolNaaI7UQoPzJA0=";
      };
      virtualHosts = {
        "immich.jusanhomelab.com" = {
          extraConfig = ''
            reverse_proxy 127.0.0.1:2283
            tls {
              dns cloudflare ${CLOUDFLARE_API_TOKEN}
            }
          '';
        };
        "deluge.jusanhomelab.com" = {
          extraConfig = ''
            reverse_proxy 127.0.0.1:8112
            tls {
              dns cloudflare ${CLOUDFLARE_API_TOKEN}
            }
          '';
        };
      };
    };
    immich = {
      enable = true;
      host = "0.0.0.0";
      openFirewall = true;
      mediaLocation = "/mnt/nas/immich";
    };
  };
  system.stateVersion = "24.11";
}
