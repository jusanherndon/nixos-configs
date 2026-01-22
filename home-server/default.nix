{ inputs, config, pkgs, ... }:
{
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
  system.stateVersion = "24.11";
}
