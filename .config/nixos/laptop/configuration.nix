# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  fileSystems."/tmp" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = ["noatime" "size=25G"];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "i915.enable_psr=0"
  ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  #  networking.dhcpcd.wait = "background";
  networking.firewall.enable = false;

  networking.wireguard = {
    enable = true;
    interfaces = {
      "wg0" = {
        privateKeyFile = "/var/keys/private";
        ips = ["10.100.0.9/24"];
        peers = [
          {
            presharedKeyFile = "/var/keys/psk";
            endpoint = "204.17.35.194:51820";
            publicKey = "cgTt2JQens2f1Etd2cKbnvT2LpdnydJIJm54xb5SZgA=";
            allowedIPs = ["10.100.0.1/32" "10.69.0.0/16" "10.96.0.0/16"];
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
  
  # Set your time zone.
  time.timeZone = "America/Phoenix";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    desktopManager = {
      # enlightenment = {
      #   enable = true;
      # };
      # lxqt = {
      #   enable = true;
      # };
      plasma5 = {
        enable = true;
      };
      # xfce = {
      #   enable = true;
      # };
    };
    # windowManager = {
    #   clfswm = {
    #     enable = true;
    #   };
    #   stumpwm = {
    #     enable = true;
    #   };
    # };
    displayManager = {
      defaultSession = "plasma";
      lightdm.extraConfig = "logind-check-graphical=true";
    };
  };

  # services.tlp.enable = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  # Configure keymap in X11
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
      white = {
      isNormalUser = true;
      #uid = 1000;
      extraGroups = [ "wheel"
                      "dialout"
                      "docker"
                      "input"
                      "vboxusers"
                      "adbusers"
                      "networkmanager"
                    ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  #   firefox
  # ];

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ anthy ];
  };
    

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.ssh.startAgent = true;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
    "steam-run"
  ];
  programs.steam.enable = true;
  programs.adb.enable = true;

  # Add fuse as an extra module for steam (for use by steam-run, to get Beyond All Reason running)
  hardware.opengl.extraPackages = with pkgs; [
    fuse
  ];

  
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.nginx = {
    enable = true;
  };
  
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nix = {
    package = pkgs.nixUnstable;
    daemonCPUSchedPolicy = "idle";
    # autoOptimiseStore = true;
    # buildCores = 6;
    # useSandbox = true;
    settings = {
      auto-optimise-store = true;
      cores= 6;
      sandbox = true;
    };
    extraOptions = ''
      experimental-features = nix-command flakes    
      keep-outputs = true
    '';
    #sandboxPaths = with pkgs; [ bash.outPath ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

