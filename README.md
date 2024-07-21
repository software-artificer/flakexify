# Flakexify
A collection of NixOS modules and Nix packages that I use for various different
systems.

## How to use
Add the following into your system `flake.nix` file:
```nix
{
  # ... snip ...
  inputs = {
    # ... snip ...
    flakexify.url = "github:filakhtov/flakexify";
    flakexify.inputs.nixpkgs.follows = "nixpkgs";
    # ... snip ...
  };

  outputs = { flakexify }: {
    nixosConfigurations = {
      myHostname = nixpkgs.lib.nixosSystem {
        # ... snip ...
        modules = [
          # ... snip ...
          flakexify.nixosModules.pretty-fonts
          # ... snip ...
        ];
      };
    };
  };
}
```
to load the `pretty-fonts` module (replace `.pretty-fonts` with any other
module name you would like to load.

## Modules
### pretty-fonts
This module installs a set of decent looking fonts and configures fontconfig
fallbacks. Includes a NerdFont-patched `Source Code Pro`, emoji support provided
by the `Noto Emoji` font family.

To enable this module set the following option to `true`:
```nix
flakexify.pretty-fonts.enable = true;
```

### usb-boot-decryption-key
This module is used to perform automatic safe powerdown for a USB key after the
system is booted. Intended for systems with full disk encryption using a key
stored on a removable USB drive.

To enable this module, simply list all partition UUIDs for USB drives that
should be disconnected after the system is booted in the following option:
```nix
flakexify.usb-boot-decryption-key.key-partuuids = [
  "1505860e-3d60-40bc-bb82-f06d213445a5"
];
```
