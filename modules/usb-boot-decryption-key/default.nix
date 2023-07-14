flake: { config, lib, pkgs, utils, ... }:
with lib;
let
  inherit (flake.packages.${pkgs.stdenv.hostPlatform.system}) usb-ejector;
  cfg = config.my-nix-flakes-modules.usb-boot-decryption-key;

  post_device_commands = strings.concatMapStrings
    (uuid: "waitDevice /dev/disk/by-partuuid/" + uuid + "\n")
    cfg.key-partuuids;

  systemd_services = builtins.foldl' (services: uuid:
    let
      escaped_uuid = utils.escapeSystemdPath uuid;
    in
      services // {
        "usb-ejector@${escaped_uuid}" = {
          wantedBy = [ "multi-user.target" ];
          overrideStrategy = "asDropin";
        };
      }
    ) {} cfg.key-partuuids;

  enabled = length cfg.key-partuuids > 0;
in
{
  options = {
    my-nix-flakes-modules = {
      usb-boot-decryption-key = {
        key-partuuids = mkOption {
          type = types.listOf types.string;
          default = [ ];
          example = [ "1505860e-3d60-40bc-bb82-f06d213445a5" ];
          description = mdDoc ''
            A list of partition UUIDs for all USB drives that need to be waited
	    for during the boot and safely removed after the system is booted.
          '';
        };
      };
    };
  };

  config = lib.mkIf enabled {
    systemd.services = {
      "usb-ejector@" = {
        description = "Detach configured USB drive from the system";

        after = [ "local-fs.target" ];

        unitConfig = {
          ConditionPathExists = "/dev/disk/by-partuuid/%I";
        };

        restartIfChanged = false;

        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${usb-ejector}/bin/usb-ejector.sh %I";
        };
      };
    } // systemd_services;

    environment.systemPackages = [ usb-ejector ];

    boot.initrd.postDeviceCommands = mkBefore post_device_commands;
  };

}
