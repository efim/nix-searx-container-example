{ config, lib, pkgs, ... }:

let
  tgwf-searx-plugin = builtins.fetchGit {
    url = "https://github.com/ngi-nix/tgwf-searx-plugins.git";
    ref = "nix-flake"; # branch name
    rev = "b4d4acb25a284c222c2598ad25867db84b6c07e7";
  };
  sample-plugin = builtins.fetchGit {
    url = "https://github.com/efim/sample-searx-plugin.git";
    ref = "master"; # branch name
    rev = "d4cedb3515816db4eff52f70726d029ac0aa54b5";
  };
in
{

  imports = [
    (import tgwf-searx-plugin).nixosModules.tgwf-green-results-searx-plugin-module
    (import sample-plugin).nixosModules.sample-searx-plugin-module
  ];

  networking.hostName = "foo"; # Define your hostname.
  #
  environment.systemPackages = with pkgs; [
    git
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users.foo = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    # A hashed password can be generated using mkpasswd -m sha-512
    #   generated on host: foo
    hashedPassword = "$6$C9blMHmw48to$gN9V5/sPX60.YO1LkwtZ2186OqPVGsKkybJjJavkMnnDCm76qDs6jcU0RzokgxVzd740P69oWqbYuJ4A/96Md1";
  };

  networking.firewall.allowedTCPPorts = [ 80 8080 ];

  services = {
    searx = {
      enable = true;
      settings = {
        server.port = 8080;
        server.bind_address = "0.0.0.0";
        server.secret_key = "@SEARX_SECRET_KEY@";
        engines = lib.singleton
          {
            name = "wolframalpha";
            shortcut = "wa";
            api_key = "@WOLFRAM_API_KEY@";
            engine = "wolframalpha_api";
          };
      };
    };
  };

}
