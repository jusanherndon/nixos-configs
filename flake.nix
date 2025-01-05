{
  description = "This is my home-server config";
  # Rebuild using nixos-rebuild switch --flake '/path/to/flake/directory#hostname` --impure
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, home-manager, ... }: {
    nixosConfigurations.home-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
          ./home-server 
     
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
     ];
    };
  };
}
