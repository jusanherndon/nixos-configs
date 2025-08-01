{
  description = "This is my home-server config";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    mdhtml.url = "git+https://codeberg.org/Tomkoid/mdhtml";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.home-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
      inherit inputs;
      CLOUDFLARE_API_TOKEN = builtins.readFile /mnt/nas/cloud_flare_api_token;
      };
      modules = [
          ./home-server
     ];
    };
    nixosConfigurations.home-desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
      inherit inputs;
      # CLOUDFLARE_API_TOKEN = builtins.readFile /mnt/nas/cloud_flare_api_token;
      };
      modules = [
          ./home-desktop
         
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.justin = import ./home-desktop/home.nix;
          }
     ];
    };
  };
}
