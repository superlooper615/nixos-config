{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix 
  ];

  # 1. User Account: Banana
  users.users.banana = {
    isNormalUser = true;
    description = "banana";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "lp" "scanner" ];
  };

  # 2. Allow Unfree & System Packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Requested Apps
    firefox
    stremio
    signal-desktop
    google-chrome
    obsidian

    # EliteBook Essentials
    fwupd               # For BIOS/Firmware updates
    light               # For controlling screen brightness
    tlp                 # Advanced power management
  ];

  # 3. EliteBook Specific Tweaks
  # Better Power Management (Crucial for laptops)
  services.tlp.enable = true;
  services.thermald.enable = true; # Prevents overheating

  # Fingerprint Sensor (Most EliteBooks use libfprint)
  services.fprintd.enable = true;

  # Better Touchpad/Trackpoint Support
  services.libinput.enable = true;

  # Hardware Video Acceleration (Intel Graphics standard on EliteBooks)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # 4. Standard Desktop (GNOME works best with touchscreen/scaling)
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # 5. Boot & System
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "banana-elitebook";
  networking.networkmanager.enable = true;

  system.stateVersion = "24.05"; 
}