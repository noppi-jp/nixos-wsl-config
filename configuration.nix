# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  wsl = {
    enable = true;
    defaultUser = "nixos";
    useWindowsDriver = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    docker-buildx
    docker-compose
    #emacs
    fastfetch
    file
    p7zip
    ripgrep
    wget
  ];

  # Select internationalisation properties.
  i18n.defaultLocale = "ja_JP.UTF-8";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs = {
    bash.shellAliases = {
      ls = "ls --color=auto -F";
      grep = "grep --color=auto";
      less = "less -i";
      fastfetch = "fastfetch -l 'nixos_old'";
    };

    git = {
      enable = true;
      lfs.enable = true;

      config = {
        core.quotePath = false;
      };
    };

    nano.enable = false;

    neovim = {
      enable = true;
      defaultEditor = true;
    };

    tmux = {
      enable = true;
      terminal = "tmux-256color";
      keyMode = "vi";
      historyLimit = 10000;
      escapeTime = 10;
      clock24 = true;
      extraConfig = ''
        set-option -g status-right-length 60
        set-option -g status-right "\"#{=30:pane_title}\" %Y/%m/%d (%a) %H:%M"

        set-option -g focus-events on
        set-option -sa terminal-features ",$TERM:RGB"
      '';
    };
  };

  services = {
    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  users = {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.nixos = {
      group = "nixos";
      extraGroups = [ "wheel" "docker" ];
      isNormalUser = true;
      hashedPassword = "$y$j9T$i8FidX3eyTOwJ8sRB9Zlv/$AUbG0y.3CcB2Mdj3zd3DQSo/Q7WnqG3y84MJeAqG0x4";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII5UERJFt3NpoGmdv3mhTkJiw4BaCJRIZ6akRoLr2BDH noppi"
      ];
      packages = with pkgs; [];
    };

    groups.nixos = {
      gid = 1000;
    };
  };

  virtualisation = {
    containers.enable = true;
    docker.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
