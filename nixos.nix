# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix 
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  hardware.parallels.enable = true;

  networking.hostName = "sepiol"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
   # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.displayManager.ssdm.enable = true;
  # services.xserver.displayManager.ssdm.defaultSession = "none+awesome";
  # windowManager.awesome.enable = true;


  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stan = {
   shell = pkgs.zsh;
   isNormalUser = true;
   initialPassword = "wachtwoord";
   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      vim
      openvpn
      papirus-icon-theme
      firefox
      gnome.gnome-tweaks
      gobuster
      jdk11
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    cifs-utils
    zsh
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  # custom STAN settings
  security.sudo.wheelNeedsPassword = false;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nixpkgs.config.allowUnfree = true;


  # List services that you want to enable:


  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = '' # used for less common options, intelligently combines if defined in multiple places.
# remap prefix from 'C-b' to 'C-a'
unbind C-b
set-option -g prefix C-space
# Start window numbering at 1
set -g base-index 1
set -g allow-rename off
set -g history-limit 10000
set -g mouse on
set-option -g status-fg white
set-option -g status-bg "#151515"
set-window-option -g window-status-current-style fg=yellow,bg="#151515"
set-window-option -g window-status-style bg="#151515"
set -g status-left " "
set -g status-justify left
setw -g window-status-format '#I:#W '          # window name formatting
setw -g window-status-current-format '#I:#W '
set -g status-right " "
set -g message-command-style bg="#151515",fg=yellow
set -g message-style bg="#151515"
bind-key -n S-Up set-option -g status
bind-key -n S-Down set-option -g status
bind-key -n S-Left previous-window
bind-key -n S-Right next-window
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R
bind -r C-H resize-pane -L 5
bind -r C-J resize-pane -D 5
bind -r C-K resize-pane -U 5
bind -r C-L resize-pane -R 5
# Pane border
set -g pane-border-style bg=default,fg=colour238
set -g pane-active-border-style fg=magenta
# loud or quiet?
set-option -g visual-activity off
set-option -g visual-bell off
set-option -g visual-silence off
set-window-option -g monitor-activity off
set-option -g bell-action none
set-option -g allow-rename off
set -g prefix `                   # use tilde key as prefix
bind `     send-key `   
bind <     swap-window -t :-
bind >     swap-window -t :+
bind ,     previous-window
bind .     next-window
bind q     kill-pane
bind Q     kill-window
bind H     split-window -h        # split into left and right panes
bind V     split-window -v  
bind r     source-file ~/.tmux.conf \; display-message " * reloaded ~/.tmux.conf"
bind n     command-prompt 'rename-window %%'
bind N     command-prompt 'rename-session %%'
set -g default-terminal "xterm-256color"

    '';
  };


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

