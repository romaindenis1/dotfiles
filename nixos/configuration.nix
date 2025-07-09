{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  users.users.r = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" ];
    shell = pkgs.zsh;
  };

  #Flakes
  nix.settings.experimental-features = "nix-command flakes";

  # Enable zsh program support
  programs.zsh.enable = true;

  # Enable Hyprland
  programs.hyprland.enable = true;

  #Launch Hyprland at login
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "Hyprland";
        user = "r";
      };
    };
  };
systemd.user.services.waybar = {
    description = "Waybar";
    wantedBy = [ "default.target" ];  # Makes sure it starts in the user session
    serviceConfig.ExecStart = "${pkgs.waybar}/bin/waybar";
  };
  environment.systemPackages = with pkgs; [
    hyprland
    waybar
    kitty
    ncmpcpp
    neovim
    wl-clipboard
    git
    gh
    firefox
    zsh
    neofetch
  ];


  # Networking
  networking.networkmanager.enable = true;

  #nix looks cooler than nixos :) 
  networking.hostName = "nix";
  
  # Bootloader - im on UEFI
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable ssh for convenience
  services.openssh.enable = true;

  # Locale and timezone
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.05";

}

