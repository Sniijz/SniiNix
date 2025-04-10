{...}: let
  hostname = builtins.replaceStrings ["\n"] [""] (builtins.readFile /etc/hostname);
  hostConfig = {
    "Barbatos" = ./hosts/Barbatos/configuration.nix;
    "Goblin-1" = ./hosts/Goblin-1/configuration.nix;
    "Goblin-2" = ./hosts/Goblin-2/configuration.nix;
  };
in {
  imports = [
    (
      if hostConfig ? "${hostname}"
      then hostConfig."${hostname}"
      else throw "Invalid hostname '${hostname}', no matching config in configuration.nix"
    )
  ];
}
