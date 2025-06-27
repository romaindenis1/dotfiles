{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  users.users.r = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" ];
    shell = pkgs.zsh;
  };

  # Enable zsh program support
  programs.zsh.enable = true;

  # Enable Hyprland
  programs.hyprland.enable = true;

  # Greetd to launch Hyprland at login
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "Hyprland";
        user = "r";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    hyprland
    hyprpaper
    waybar
    kitty
    neovim
    wl-clipboard
    git
    gh
    firefox
    zsh
    neofetch
    stow
  ];

  # Networking
  networking.networkmanager.enable = true;

  networking.hostName = "nix";
  # Bootloader - adjust this to your system type

  # If you have BIOS/MBR:
#  boot.loader.grub = {
#    enable = true;
#    devices = [ "/dev/sda" ];  # replace /dev/sda with your boot drive
#  };

  # If you have UEFI and want systemd-boot instead, comment out the above and uncomment:
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable ssh for convenience
  services.openssh.enable = true;

  # Locale and timezone
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.05";
}
