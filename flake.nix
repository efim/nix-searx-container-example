{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";

  outputs = { self, nixpkgs }: {

    nixosConfigurations.foo-container = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          ({ pkgs, ... }: {
            boot.isContainer = true;

            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

            # Network configuration.
            networking.hostName = "foo"; # Define your hostname.
            networking.useDHCP = false;
            networking.firewall.allowedTCPPorts = [ 80 8080 ];

            # Define a user account. Don't forget to set a password with ‘passwd’.
            users.mutableUsers = false;
            users.users.foo = {
              isNormalUser = true;
              extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
              # A hashed password can be generated using mkpasswd -m sha-512
              #   generated on host: foo
              hashedPassword = "$6$C9blMHmw48to$gN9V5/sPX60.YO1LkwtZ2186OqPVGsKkybJjJavkMnnDCm76qDs6jcU0RzokgxVzd740P69oWqbYuJ4A/96Md1";
            };

            services = {
              searx = {
                enable = true;
                settings = {
                  server.port = 8080;
                  server.bind_address = "0.0.0.0";
                  server.secret_key = "@SEARX_SECRET_KEY@";
                  engines = nixpkgs.lib.singleton
                    {
                      name = "wolframalpha";
                      shortcut = "wa";
                      api_key = "@WOLFRAM_API_KEY@";
                      engine = "wolframalpha_api";
                    };
                };
              };
            };
          })
        ];
    };

  };
}
