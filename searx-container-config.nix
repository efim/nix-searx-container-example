# moved to the flake, yay
{ config, lib, pkgs, ... }:

{
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
