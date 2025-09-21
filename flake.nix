{
  description = "This is my home-server config";
  # Rebuild using nixos-rebuild switch --flake '/path/to/flake/directory#hostname` --impure
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    mdhtml.url = "git+https://codeberg.org/Tomkoid/mdhtml";
    copyparty.url = "github:9001/copyparty";
  };
  outputs = { nixpkgs, home-manager, copyparty, ... }@inputs: {
    nixosConfigurations.home-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { 
      inherit inputs; 
      CLOUDFLARE_API_TOKEN = builtins.readFile /mnt/nas/cloud_flare_api_token;
      };
      modules = [ 
          ./home-server 
          
          copyparty.nixosModules.default
          ({ pkgs, ... }: {
          # add the copyparty overlay to expose the package to the module
          nixpkgs.overlays = [ copyparty.overlays.default ];
          environment.systemPackages = [ pkgs.copyparty ];
          services.copyparty.enable = true;
        })
     ];
    };
  };
}
