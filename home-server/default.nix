{ inputs, config, pkgs, ... }:
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ./services.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.supportedFilesystems = [ "nfs" ];
  boot.loader.grub.useOSProber = true;
  networking.networkmanager.enable = true;
  networking.hostName = "nixos"; # Define your hostname.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.rpcbind.enable = true; 


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
    caddy
    nssTools
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

  networking.firewall.allowedTCPPorts = [ 2283 8000 8081 8112 ];
  networking.firewall.allowedUDPPorts = [ 2283 8000 8081 8112 ];
  system.stateVersion = "24.11";
}
