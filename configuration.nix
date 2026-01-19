{ ... }:
let
  hostname = builtins.replaceStrings [ "\n" ] [ "" ] (
    builtins.readFile /etc/hostname
  );
  hostConfig = {
    "Aerial" = ./hosts/Aerial/configuration.nix;
    "Barbatos" = ./hosts/Barbatos/configuration.nix;
    "Sniipet-1" = ./hosts/Sniipet-1/configuration.nix;
    "Sniipet-2" = ./hosts/Sniipet-2/configuration.nix;
    "Sniipet-3" = ./hosts/Sniipet-3/configuration.nix;
    "Goblin-1" = ./hosts/Goblin-1/configuration.nix;
    "Goblin-2" = ./hosts/Goblin-2/configuration.nix;
  };
in
{
  imports = [
    (
      if hostConfig ? "${hostname}" then
        hostConfig."${hostname}"
      else
        throw "Invalid hostname '${hostname}', no matching config in configuration.nix"
    )
  ];
}
