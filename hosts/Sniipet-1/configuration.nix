{
  config,
  pkgs,
  lib,
  ...
}:
let
  secrets = import ./secrets.nix;
  vars = {
    user = "sniijz";
    location = "$HOME/.setup";
    gitUser = "robin.cassagne";
  };
  sources = import ../../nix/sources.nix;
  # To retrieve sha256, use the following :
  # nix-prefetch-url https://github.com/k3s-io/k3s/releases/download/v1.30.9%2Bk3s1/k3s

  customK3S =
    pkgs.runCommand "k3s-1.35.0"
      {
        src = pkgs.fetchurl {
          url = "https://github.com/k3s-io/k3s/releases/download/v1.35.0%2Bk3s1/k3s";
          sha256 = "0cf3dndkcnghh0hq7j1h8s4dgscxc3bwany9s5c3k2dblq89774m";
        };
      }
      ''
        mkdir -p $out/bin
        cp $src $out/bin/k3s
        chmod +x $out/bin/k3s
      '';

  interface = "eno1";
  vip = "192.168.1.30";

  kubeVipRBAC = ''
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: kube-vip
      namespace: kube-system
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      annotations:
        rbac.authorization.kubernetes.io/autoupdate: "true"
      name: system:kube-vip-role
    rules:
      - apiGroups: [""]
        resources: ["services/status"]
        verbs: ["update"]
      - apiGroups: [""]
        resources: ["services", "endpoints"]
        verbs: ["list","get","watch", "update"]
      - apiGroups: [""]
        resources: ["nodes"]
        verbs: ["list","get","watch", "update", "patch"]
      - apiGroups: ["coordination.k8s.io"]
        resources: ["leases"]
        verbs: ["list", "get", "watch", "update", "create"]
      - apiGroups: ["discovery.k8s.io"]
        resources: ["endpointslices"]
        verbs: ["list","get","watch", "update"]
      - apiGroups: [""]
        resources: ["pods"]
        verbs: ["list"]
    ---
    kind: ClusterRoleBinding
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: system:kube-vip-binding
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: system:kube-vip-role
    subjects:
    - kind: ServiceAccount
      name: kube-vip
      namespace: kube-system
  '';

  kubeVipDS = ''
    ---
    apiVersion: apps/v1
    kind: DaemonSet
    metadata:
      name: kube-vip-ds
      namespace: kube-system
    spec:
      selector:
        matchLabels:
          name: kube-vip-ds
      template:
        metadata:
          creationTimestamp: null
          labels:
            name: kube-vip-ds
        spec:
          affinity:
            nodeAffinity:
              requiredDuringSchedulingIgnoredDuringExecution:
                nodeSelectorTerms:
                - matchExpressions:
                  - key: node-role.kubernetes.io/master
                    operator: Exists
                - matchExpressions:
                  - key: node-role.kubernetes.io/control-plane
                    operator: Exists
          containers:
          - args:
            - manager
            env:
            - name: vip_arp
              value: "true"
            - name: port
              value: "6443"
            - name: vip_interface
              value: "${interface}"
            - name: vip_subnet
              value: "32"
            - name: cp_enable
              value: "true"
            - name: cp_namespace
              value: kube-system
            - name: vip_ddns
              value: "false"
            - name: svc_enable
              value: "true"
            - name: vip_leaderelection
              value: "true"
            - name: vip_leaseduration
              value: "5"
            - name: vip_renewdeadline
              value: "3"
            - name: vip_retryperiod
              value: "1"
            - name: address
              value: "${vip}"
            image: ghcr.io/kube-vip/kube-vip:v1.0.4
            imagePullPolicy: IfNotPresent
            name: kube-vip
            resources: {}
            securityContext:
              capabilities:
                add:
                - NET_ADMIN
                - NET_RAW
                - SYS_TIME
          hostNetwork: true
          serviceAccountName: kube-vip
          tolerations:
          - effect: NoSchedule
            operator: Exists
          - effect: NoExecute
            operator: Exists
      updateStrategy: {}
  '';

in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <home-manager/nixos>
    (import ../../common/terminal {
      inherit
        vars
        lib
        pkgs
        sources
        config
        ;
    })
    (import ../../common/desktop {
      inherit
        vars
        pkgs
        config
        lib
        ;
    })
    (import ../../common/app {
      inherit
        vars
        pkgs
        config
        lib
        ;
    })
    (import ../../common/games {
      inherit
        vars
        pkgs
        config
        lib
        ;
    })
    (import ../../common/editor {
      inherit
        vars
        pkgs
        config
        lib
        ;
    })
    (import ../../common/compose {
      inherit
        vars
        pkgs
        config
        lib
        ;
    })
    (import ../../common/system {
      inherit
        vars
        pkgs
        config
        lib
        ;
    })
    (import ../../common/dev {
      inherit
        vars
        pkgs
        config
        lib
        ;
    })
  ];

  customModules = {
    # Terminal
    starship.PastelPowerline.enable = true;
    neovim.enable = true;
  };

  ######################### Global Settings #########################

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
  # KEEP IT LIKE THIS ON SNIIPET-1, THIS ONE HAS BEEN UPGRADED FROM 24.05, SNIIPET-1
  # HAS BEEN DIRECTLY INSTALLED IN 25.05

  # Use systemd-boot as bootloader and not grub like Aerial and Barbatos
  boot = {
    loader = {
      systemd-boot.enable = lib.mkForce true;
      efi.canTouchEfiVariables = lib.mkForce true;
      grub.enable = lib.mkForce false;
    };
    # Rook/Ceph support
    kernelModules = [
      "configs"
      "rbd"
      "br_netfilter"
      "overlay"
    ];
  };

  ######################### Networking #########################

  # Define your hostname.

  # Enable networking
  networking = {
    hostName = "Sniipet-1";
    useNetworkd = lib.mkForce true;
    dhcpcd.enable = lib.mkForce false;
    useDHCP = lib.mkForce false;
    networkmanager.enable = lib.mkForce false;
    nameservers = [
      "192.168.1.2"
      "192.168.1.3"
    ];
    interfaces.eno1.ipv4.addresses = [
      {
        address = "192.168.1.6";
        prefixLength = 24;
      }
    ];
    defaultGateway = {
      address = "192.168.1.1";
      interface = "eno1";
    };
  };

  # Configure network proxy if necessary
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  # List services that you want to enable:

  ######################### Accounts ###########################

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sniijz = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    openssh.authorizedKeys.keys = secrets.pubKeys;
  };

  ######################### Home-Manager #########################
  # To install home manager version 24.05 channel :
  # sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz home-manager
  # sudo nix-channel --update

  # users.users.sniijz.isNormalUser = true;
  home-manager.users.sniijz = {
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "25.11";
  };

  ######################### Packages #########################

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs = {
    ssh.startAgent = true;
    git.enable = true;
    git.config = {
      user.name = "Robin CASSAGNE";
      user.email = "robin.jean.cassagne@gmail.com";
    };
  };

  environment = {
    variables = {
      K3S_RESOLV_CONF = "/etc/resolv.conf";
    };

    systemPackages = with pkgs; [
      ansible # Automation tool
      bash # Universal linux shell
      btop # Top tool written in C++
      cmatrix # matrix effect package
      cryptsetup # luks for dm-crypt needed for longhorn
      curl # Universal cli tool
      eza # modern replacement of ls
      etcd # etcd and etcdctl commands
      fish # alternative to bash
      fishPlugins.fzf-fish # fzf plugin for fish
      fishPlugins.z # zoxide plugin for fish
      fzf # fuzzy finder
      gawk # gnuw implem of awk
      go # Golang language
      gotop # top tool written in go
      htop # Graphical top
      jellyfin-ffmpeg # For Jellyfin transcoding
      jellyfin-mpv-shim # For Jellyfin transcoding
      kubectl # kube ctl cli
      neovim # text editor
      nfs-utils # Needed for Longhorn
      openiscsi # Needed for longhorn
      rsync # Syncer
      smartmontools # disk utility tool
      termshark # cli packet capture
      tldr # man summary
      util-linux # contains nsenter for longhorn
      vim # text editor
      wget # cli tool for download
    ];
  };

  ##################### NFS Configuration ##########################

  fileSystems."/mnt/SniiNAS" = {
    device = "192.168.1.5:/volume1/SniiNAS";
    fsType = "nfs4";
    options = [
      "_netdev"
      "rw"
      "hard"
      "nolock"
      "noauto"
      "x-systemd.automount"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
    ];
  };

  services = {

    openssh.enable = true;
    openssh.settings.PasswordAuthentication = false;

    ##################### K3S Configuration ##########################

    k3s = {
      enable = true;
      package = customK3S;
      token = secrets.apiTokens.k3s;
      role = "server";
      extraFlags = toString [
        "--node-name=sniipet-1"
        "--disable=servicelb"
        "--disable=traefik"
        "--kubelet-arg=cgroup-driver=systemd"
        "--tls-san=192.168.1.30"
        "--cluster-init"
      ];
    };

    ###################### iscsi configuration for longhorn ###########
    openiscsi = {
      enable = true;
      name = "${config.networking.hostName}-initiatorhost";
    };
  };

  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
    "L+ /usr/local/bin/nsenter - - - - ${pkgs.util-linux}/bin/nsenter"
    "L+ /usr/bin/nsenter - - - - ${pkgs.util-linux}/bin/nsenter"
    "L+ /bin/bash - - - - ${pkgs.bash}/bin/bash"
    "d /var/lib/rancher/k3s/server/manifests 0700 root root -"
    "L+ /var/lib/rancher/k3s/server/manifests/kube-vip.yaml - - - - ${
      pkgs.writeText "kube-vip-full.yaml" (kubeVipRBAC + kubeVipDS)
    }"
  ];

}
