{
  description = "This is my home-server config";
  # Rebuild using nixos-rebuild switch --flake '/path/to/flake/directory#hostname` --impure
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };
  outputs = { nixpkgs, home-manager, ... }: {
    nixosConfigurations.home-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
         CLOUDFLARE_API_TOKEN = builtins.readFile /mnt/nas/cloud_flare_api_token; 
      };
      modules = [ 
          ./home-server 
     ];
    };
  };
}
