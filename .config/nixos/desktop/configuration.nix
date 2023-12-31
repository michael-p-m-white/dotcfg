# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "nodev"; # or "nodev" for efi only

  # boot.loader.systemd-boot.enable = true;

  # Settings related to GPU passthrough
  # Enable IOMMU (necessary for GPU passthrough to virtual machines
  boot.kernelParams = [
    # Required to do VFIO PCI passthrough on an Intel based system.
    "intel_iommu=on"

    # I had issues trying to pass through a PCIe USB controller. Specifically, the guest
    # VM would freeze as soon as I plugged a device in. dmesg in the host would show an
    # "AER: PCIe Bus Error". According to the following reddit post, the solution is to pass
    # pcie_aspm=off to the kernel.
    # https://old.reddit.com/r/VFIO/comments/mqlabq/aer_errors_when_passing_through_pcie_usb_hub/
    "pcie_aspm=off"
  ];
  boot.kernelModules = [ "kvm-intel" ];

  boot.initrd =
    { availableKernelModules = [ "amdgpu" "vfio-pci" ];
      preDeviceCommands = ''
        DEVS="0000:00:01.0 0000:01:00.0 0000:02:00.0 0000:03:00.0 0000:03:00.1"
        for DEV in $DEVS; do
          echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
        done
        modprobe -i vfio-pci
      '';
    };

  virtualisation.libvirtd =
    {

      qemu = {
        ovmf.enable = true;
        runAsRoot = true;
        verbatimConfig =
          let nums = builtins.genList (x: x) 101;
              events = map (num: "\"/dev/input/event${toString num}\",") nums;
              eventsToEmbed = builtins.foldl' (x: y: x + "\n  " + y) (builtins.head events) (builtins.tail events);
          in
            ''
            namespaces = []
            user="white"
            group="users"
            cgroup_device_acl = [
              "/dev/null",
              "/dev/full",
              "/dev/zero",
              "/dev/random",
              "/dev/urandom",
              "/dev/ptmx",
              "/dev/kvm",
              "/dev/kqemu",
              "/dev/rtc",
              "/dev/hpet",
              "/dev/input/by-id/usb-04d9_USB_Keyboard-event-if00",
              "/dev/input/by-id/usb-04d9_USB_Keyboard-event-if01",
              "/dev/input/by-id/usb-Logitech_USB_Optical_Mouse-event-mouse",
              ${eventsToEmbed}
                  ]
            nographics_allow_host_audio = 1
          '';
      };


      enable = true;
#      qemuOvmf = true;
#      qemuRunAsRoot = true;
      onBoot = "ignore";
      onShutdown = "shutdown";

      # qemuVerbatimConfig =
      #   let nums = builtins.genList (x: x) 101;
      #       events = map (num: "\"/dev/input/event${toString num}\",") nums;
      #       eventsToEmbed = builtins.foldl' (x: y: x + "\n  " + y) (builtins.head events) (builtins.tail events);
      #   in
      #     ''
      #       namespaces = []
      #       user="white"
      #       group="users"
      #       cgroup_device_acl = [
      #         "/dev/null",
      #         "/dev/full",
      #         "/dev/zero",
      #         "/dev/random",
      #         "/dev/urandom",
      #         "/dev/ptmx",
      #         "/dev/kvm",
      #         "/dev/kqemu",
      #         "/dev/rtc",
      #         "/dev/hpet",
      #         "/dev/input/by-id/usb-04d9_USB_Keyboard-event-if00",
      #         "/dev/input/by-id/usb-04d9_USB_Keyboard-event-if01",
      #         "/dev/input/by-id/usb-Logitech_USB_Optical_Mouse-event-mouse",
      #         ${eventsToEmbed}
      #       ]
      #       nographics_allow_host_audio = 1
      #     '';
    };

  fileSystems."/tmp" =
    {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "noatime" "size=16G" ];
    };

  networking.hostName = "nixos-desktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  networking.interfaces.eno2.useDHCP = true;
  networking.interfaces.br0.useDHCP = true;
  networking.bridges = {
    "br0" = {
      interfaces = [ "eno2" ];
    };
  };

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/Phoenix";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    virt-manager
    guestfs-tools
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  programs.ssh.startAgent = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  hardware.pulseaudio =
    {
      enable = true;
      package = pkgs.pulseaudioFull;
    };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager = {
    sddm.enable = true;
    defaultSession = "plasma";
  };
  # Legacy options; names have changed in newer nixpkgs
  # services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.displayManager.defaultSession = "plasma5";


  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  users.extraUsers =
    {
      white =
        {
          isNormalUser = true;
          uid = 1000;
          extraGroups = [ "audio"
                          "dialout"
                          "docker"
                          "wheel"
                          "vboxusers"

                          # Following options are for GPU passthrough
                          "kvm"
                          "libvirtd"
                          "qemu-libvirtd"
                          "input"
                        ];
        };
    };

  users.users.qemu-libvirtd.extraGroups = [ "input" ];

  nix = {
    daemonCPUSchedPolicy = "idle";
    settings = {
      auto-optimise-store = true;
      cores = 8;
      sandbox = true;

      # Additional binary substituters, and their keys.
      # I used by nixos-laptop, but don't want that as a substituter all the time,
      # hence why it's commented out.
      substituters = [
        # "http://192.168.88.133:5000"
      ];

      trusted-public-keys = [
        # "nixos-laptop-binary-cache-key:r74yhO5bwBBH95psFkXSWW20fHgcgZoy3u4wTHNgwrk="
      ];
    };

    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
    '';

    # Legacy options no longer valid
    # daemonNiceLevel = 15;
  };

  # Ensure the "nixpkgs" flake alias refers to the nixpkgs flake used
  # to build the system.
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.nixPath = [
    "nixpkgs=${inputs.nixpkgs.outPath}"
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}

# # Prevent video card from being "claimed" by its video driver
# # before the vfio drivers can claim it
# boot.blacklistedKernelModules = [ "amdgpu" "radeon" ];

# boot.kernelModules =
#   [ "vfio_virqfd"
#     "vfio_pci"
#     "vfio_iommy_type1"
#     "vfio"
#   ];

# boot.extraModprobeConfig = "options vfio-pci ids";
