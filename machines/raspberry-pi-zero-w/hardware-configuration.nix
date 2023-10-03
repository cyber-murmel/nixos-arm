{ config, pkgs, lib, ... }:

{
  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_rpi0;
    loader = {
      grub.enable = false;
      raspberryPi = {
        enable = true;
        version = 0;
        firmwareConfig = ''
          # overclock some (https://www.tomshardware.com/how-to/overclock-any-raspberry-pi#overclocking-values-for-all-models-of-pi-xa0)
          arm_freq=1100
          core_freq=450
          over_voltage=6
          gpu_freq=500
        '';
      };
    };

    # consoleLogLevel = lib.mkDefault 7;

    # prevent `modprobe: FATAL: Module ahci not found`
    initrd.availableKernelModules = pkgs.lib.mkForce [
      "mmc_block"
    ];
  };

  hardware = {
    # needed for wlan0 to work (https://github.com/NixOS/nixpkgs/issues/115652)
    enableRedistributableFirmware = pkgs.lib.mkForce false;
    firmware = with pkgs; [
      raspberrypiWirelessFirmware
    ];
  };

  environment.systemPackages = with pkgs; [
    libraspberrypi
  ];
}
