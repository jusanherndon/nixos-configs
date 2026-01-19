{ inputs, config, pkgs, ... }:
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
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
    supportedFilesystems = [ "nfs" ];
  };
  networking = {
    hostName = "nixos"; 
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [ 2283 8112 ];
      allowedUDPPorts = [ 2283 8112 ];
    };
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "America/Chicago";
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
  environment.systemPackages = with pkgs; [
    vim
    git
    deluged
    caddy
    tailscale
    immich
  ];
  users.users = {
      justin = {
        isNormalUser = true;
        description = "Justin";
        extraGroups = [ "networkmanager" "wheel" "deluge" ];
      };
      deluge = {
        extraGroups = [ "deluge" ];
      };
  };
  system.stateVersion = "24.11";
}
