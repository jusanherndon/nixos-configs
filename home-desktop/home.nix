{ config, pkgs, ... }:
{

  home = {
    username = "justin";
    packages = with pkgs; [
      git
    ]; 
    stateVersion = "25.05";
  };
  programs.firefox.enable = true;
  programs.git = {
    enable = true;
    userName = "Justin Herndon";
    userEmail = "jherndon111@gmail.com";
  };
  programs.home-manager.enable = true;
}
