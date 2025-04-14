{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  cfg = config.customModules.steam;
in {
  options.customModules.steam = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        whether to enable steam globally or not
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    # Add the following to add more gamepad support
    hardware.steam-hardware.enable = true;
    # Install Steam
    # Don't forget to also modify : /home/sniijz/.config/autostart/steam.desktop
    # Add the following parameter : Exec=steam %U -nochatui -nofriendsui -silent -steamos3
    # Launch a game in HDR with RT in 4k within gamescope : gamemoderun gamescope -f -e -r 120 -W 3840 -H 2160 --hdr-enabled --force-grab-cursor --hdr-debug-force-output --hdr-itm-enable --steam env ENABLE_GAMESCOPE_WSI=1 DXVK_HDR=1 RADV_PERFTEST='rt' DISABLE_HDR_WSI=1 MANGOHUD=1 -- %command%
    # Same without RT : gamemoderun gamescope -f -e -W 3840 -H 2160 --hdr-enabled --force-grab-cursor --hdr-debug-force-output --hdr-itm-enable --steam env ENABLE_GAMESCOPE_WSI=1 DXVK_HDR=1 DISABLE_HDR_WSI=1 MANGOHUD=1 -- %command%
    # For 2k Screen : gamemoderun  gamescope -f -e -r 120 -W 2560 -H 1440 --hdr-enabled --force-grab-cursor --hdr-debug-force-output --hdr-itm-enable --steam env ENABLE_GAMESCOPE_WSI=1 DXVK_HDR=1 RADV_PERFTEST='rt' DISABLE_HDR_WSI=1 MANGOHUD=1 -- %command%
    # For MH Wilds : gamemoderun gamescope -f -e -W 3840 -H 2160 --hdr-enabled --force-grab-cursor --hdr-debug-force-output --hdr-itm-enable --steam env ENABLE_GAMESCOPE_WSI=1 DXVK_HDR=1 VKD3D_DISABLE_EXTENSIONS=VK_NV_low_latency2 DISABLE_HDR_WSI=1 MANGOHUD=1 -- %command%
    # For Spiderman 2 : gamemoderun gamescope -f -e -r 120 -W 3840 -H 2160 --hdr-enabled --force-grab-cursor --hdr-debug-force-output --hdr-itm-enable --steam env ENABLE_GAMESCOPE_WSI=1 DXVK_HDR=1 RADV_PERFTEST='rt' DISABLE_HDR_WSI=1 MANGOHUD=1 -- %command%
    # gamemoderun gamescope -f -e -r 120 -W 3840 -H 2160 --hdr-enabled --force-grab-cursor --steam env ENABLE_GAMESCOPE_WSI=1 DXVK_HDR=1 -- %command%
    # Run steam in gamescope : gamescope -e -- steam -steamdeck -f -e -r 120 -W 3840 -H 2160 --hdr-enabled --force-grab-cursor --steam env ENABLE_GAMESCOPE_WSI=1 DXVK_HDR=1 -- %command%
    # To fix later
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            gamemode
            mangohud
            # additional packages...
            # e.g. some games require python3
          ];
        extraEnv = {
          MANGOHUD = true;
          LD_PRELOAD = "${pkgs.gamemode.lib}/lib/libgamemode.so";
        };
        # fix gamescope launch from within steam
        extraLibraries = p:
          with p; [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            keyutils
          ];
      };
      extest.enable = false;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      gamescopeSession = {
        enable = true;
      };
    };

    # systemd.user.services.steam_background = {
    #   enable = true;
    #   description = "Open Steam in the background at boot";
    #   wantedBy = ["default.target"]; # Run after the user session is fully initialized
    #   after = ["graphical-session.target"]; # Ensure graphical session is ready
    #   serviceConfig = {
    #     ExecStart = "${pkgs.steam}/bin/steam -nochatui -nofriendsui -silent %U";
    #     ExecStartPre = "${pkgs.coreutils}/bin/sleep 5"; # Delay by x seconds to ensure graphical session is ready
    #     Restart = "on-failure";
    #     RestartSec = "5s";
    #     Environment = "DISPLAY=:0";
    #   };
    # };

    home-manager.users.${vars.user} = {
      xdg.desktopEntries.steam = {
        name = "Steam";
        genericName = "All-in-one cross-platform voice and text chat for gamers";
        exec = "steam %U -nochatui -nofriendsui -steamos3";
        icon = "steam";
        terminal = false;
        categories = ["Network" "FileTransfer" "Game"];
        mimeType = ["x-scheme-handler/steam" "x-scheme-handler/steamlink"];
        settings = {
          StartupWMClass = "steam";
        };
        actions = {
          Store = {
            name = "Store";
            exec = "steam steam://store";
          };
          Community = {
            name = "Community";
            exec = "steam steam://url/SteamIDControlPage";
          };
          Library = {
            name = "Library";
            exec = "steam steam://open/games";
          };
          Servers = {
            name = "Servers";
            exec = "steam steam://open/servers";
          };
          Screenshots = {
            name = "Screenshots";
            exec = "steam steam://open/screenshots";
          };
          News = {
            name = "News";
            exec = "steam steam://open/news";
          };
          Settings = {
            name = "Settings";
            exec = "steam steam://open/settings";
          };
          BigPicture = {
            name = "Big Picture";
            exec = "steam steam://open/bigpicture";
          };
          Friends = {
            name = "Friends";
            exec = "steam steam://open/friends";
          };
        };
      };

      home.file.".config/autostart/steam.desktop" = {
        source = pkgs.writeText "steam.desktop" ''
          [Desktop Entry]
          Name=Steam
          Comment=Application for managing and playing games on Steam
          Comment[pt_BR]=Aplicativo para jogar e gerenciar jogos no Steam
          Comment[bg]=Приложение за ръководене и пускане на игри в Steam
          Comment[cs]=Aplikace pro spravování a hraní her ve službě Steam
          Comment[da]=Applikation til at håndtere og spille spil på Steam
          Comment[nl]=Applicatie voor het beheer en het spelen van games op Steam
          Comment[fi]=Steamin pelien hallintaan ja pelaamiseen tarkoitettu sovellus
          Comment[fr]=Application de gestion et d'utilisation des jeux sur Steam
          Comment[de]=Anwendung zum Verwalten und Spielen von Spielen auf Steam
          Comment[el]=Εφαρμογή διαχείρισης παιχνιδιών στο Steam
          Comment[hu]=Alkalmazás a Steames játékok futtatásához és kezeléséhez
          Comment[it]=Applicazione per la gestione e l'esecuzione di giochi su Steam
          Comment[ja]=Steam 上でゲームを管理＆プレイするためのアプリケーション
          Comment[ko]=Steam에 있는 게임을 관리하고 플레이할 수 있는 응용 프로그램
          Comment[no]=Program for å administrere og spille spill på Steam
          Comment[pt_PT]=Aplicação para organizar e executar jogos no Steam
          Comment[pl]=Aplikacja do zarządzania i uruchamiania gier na platformie Steam
          Comment[ro]=Aplicație pentru administrarea și jucatul jocurilor pe Steam
          Comment[ru]=Приложение для игр и управления играми в Steam
          Comment[es]=Aplicación para administrar y ejecutar juegos en Steam
          Comment[sv]=Ett program för att hantera samt spela spel på Steam
          Comment[zh_CN]=管理和进行 Steam 游戏的应用程序
          Comment[zh_TW]=管理並執行 Steam 遊戲的應用程式
          Comment[th]=โปรแกรมสำหรับจัดการและเล่นเกมบน Steam
          Comment[tr]=Steam üzerinden oyun oynama ve düzenleme uygulaması
          Comment[uk]=Програма для керування іграми та запуску ігор у Steam
          Comment[vi]=Ứng dụng để quản lý và chơi trò chơi trên Steam
          Exec=steam %U -nochatui -nofriendsui -silent -steamos3
          Icon=steam
          Terminal=false
          Type=Application
          Categories=Network;FileTransfer;Game;
          MimeType=x-scheme-handler/steam;x-scheme-handler/steamlink;
          Actions=Store;Community;Library;Servers;Screenshots;News;Settings;BigPicture;Friends;
          PrefersNonDefaultGPU=true
          X-KDE-RunOnDiscreteGpu=true

          [Desktop Action Store]
          Name=Store
          Name[pt_BR]=Loja
          Name[bg]=Магазин
          Name[cs]=Obchod
          Name[da]=Butik
          Name[nl]=Winkel
          Name[fi]=Kauppa
          Name[fr]=Magasin
          Name[de]=Shop
          Name[el]=ΚΑΤΑΣΤΗΜΑ
          Name[hu]=Áruház
          Name[it]=Negozio
          Name[ja]=ストア
          Name[ko]=상점
          Name[no]=Butikk
          Name[pt_PT]=Loja
          Name[pl]=Sklep
          Name[ro]=Magazin
          Name[ru]=Магазин
          Name[es]=Tienda
          Name[sv]=Butik
          Name[zh_CN]=商店
          Name[zh_TW]=商店
          Name[th]=ร้านค้า
          Name[tr]=Mağaza
          Name[uk]=Крамниця
          Name[vi]=Cửa hàng
          Exec=steam steam://store %U -nochatui -nofriendsui -silent -steamos3

          [Desktop Action Community]
          Name=Community
          Name[pt_BR]=Comunidade
          Name[bg]=Общност
          Name[cs]=Komunita
          Name[da]=Fællesskab
          Name[nl]=Community
          Name[fi]=Yhteisö
          Name[fr]=Communauté
          Name[de]=Community
          Name[el]=Κοινότητα
          Name[hu]=Közösség
          Name[it]=Comunità
          Name[ja]=コミュニティ
          Name[ko]=커뮤니티
          Name[no]=Samfunn
          Name[pt_PT]=Comunidade
          Name[pl]=Społeczność
          Name[ro]=Comunitate
          Name[ru]=Сообщество
          Name[es]=Comunidad
          Name[sv]=Gemenskap
          Name[zh_CN]=社区
          Name[zh_TW]=社群
          Name[th]=ชุมชน
          Name[tr]=Topluluk
          Name[uk]=Спільнота
          Name[vi]=Cộng đồng
          Exec=steam steam://url/SteamIDControlPage %U -nochatui -nofriendsui -silent -steamos3

          [Desktop Action Library]
          Name=Library
          Name[pt_BR]=Biblioteca
          Name[bg]=Библиотека
          Name[cs]=Knihovna
          Name[da]=Bibliotek
          Name[nl]=Bibliotheek
          Name[fi]=Kokoelma
          Name[fr]=Bibliothèque
          Name[de]=Bibliothek
          Name[el]=Συλλογή
          Name[hu]=Könyvtár
          Name[it]=Libreria
          Name[ja]=ライブラリ
          Name[ko]=라이브러리
          Name[no]=Bibliotek
          Name[pt_PT]=Biblioteca
          Name[pl]=Biblioteka
          Name[ro]=Colecţie
          Name[ru]=Библиотека
          Name[es]=Biblioteca
          Name[sv]=Bibliotek
          Name[zh_CN]=库
          Name[zh_TW]=收藏庫
          Name[th]=คลัง
          Name[tr]=Kütüphane
          Name[uk]=Бібліотека
          Name[vi]=Thư viện
          Exec=steam steam://open/games %U -nochatui -nofriendsui -silent -steamos3

          [Desktop Action Servers]
          Name=Servers
          Name[pt_BR]=Servidores
          Name[bg]=Сървъри
          Name[cs]=Servery
          Name[da]=Servere
          Name[nl]=Servers
          Name[fi]=Palvelimet
          Name[fr]=Serveurs
          Name[de]=Server
          Name[el]=Διακομιστές
          Name[hu]=Szerverek
          Name[it]=Server
          Name[ja]=サーバー
          Name[ko]=서버
          Name[no]=Tjenere
          Name[pt_PT]=Servidores
          Name[pl]=Serwery
          Name[ro]=Servere
          Name[ru]=Серверы
          Name[es]=Servidores
          Name[sv]=Servrar
          Name[zh_CN]=服务器
          Name[zh_TW]=伺服器
          Name[th]=เซิร์ฟเวอร์
          Name[tr]=Sunucular
          Name[uk]=Сервери
          Name[vi]=Máy chủ
          Exec=steam steam://open/servers %U -nochatui -nofriendsui -silent -steamos3

          [Desktop Action Screenshots]
          Name=Screenshots
          Name[pt_BR]=Capturas de tela
          Name[bg]=Снимки
          Name[cs]=Snímky obrazovky
          Name[da]=Skærmbilleder
          Name[nl]=Screenshots
          Name[fi]=Kuvankaappaukset
          Name[fr]=Captures d'écran
          Name[de]=Screenshots
          Name[el]=Φωτογραφίες
          Name[hu]=Képernyőmentések
          Name[it]=Screenshot
          Name[ja]=スクリーンショット
          Name[ko]=스크린샷
          Name[no]=Skjermbilder
          Name[pt_PT]=Capturas de ecrã
          Name[pl]=Zrzuty ekranu
          Name[ro]=Capturi de ecran
          Name[ru]=Скриншоты
          Name[es]=Capturas
          Name[sv]=Skärmdumpar
          Name[zh_CN]=截图
          Name[zh_TW]=螢幕擷圖
          Name[th]=ภาพหน้าจอ
          Name[tr]=Ekran Görüntüleri
          Name[uk]=Скріншоти
          Name[vi]=Ảnh chụp
          Exec=steam steam://open/screenshots %U -nochatui -nofriendsui -silent -steamos3

          [Desktop Action News]
          Name=News
          Name[pt_BR]=Notícias
          Name[bg]=Новини
          Name[cs]=Zprávy
          Name[da]=Nyheder
          Name[nl]=Nieuws
          Name[fi]=Uutiset
          Name[fr]=Actualités
          Name[de]=Neuigkeiten
          Name[el]=Νέα
          Name[hu]=Hírek
          Name[it]=Notizie
          Name[ja]=ニュース
          Name[ko]=뉴스
          Name[no]=Nyheter
          Name[pt_PT]=Novidades
          Name[pl]=Aktualności
          Name[ro]=Știri
          Name[ru]=Новости
          Name[es]=Noticias
          Name[sv]=Nyheter
          Name[zh_CN]=新闻
          Name[zh_TW]=新聞
          Name[th]=ข่าวสาร
          Name[tr]=Haberler
          Name[uk]=Новини
          Name[vi]=Tin tức
          Exec=steam steam://open/news %U -nochatui -nofriendsui -silent -steamos3

          [Desktop Action Settings]
          Name=Settings
          Name[pt_BR]=Configurações
          Name[bg]=Настройки
          Name[cs]=Nastavení
          Name[da]=Indstillinger
          Name[nl]=Instellingen
          Name[fi]=Asetukset
          Name[fr]=Paramètres
          Name[de]=Einstellungen
          Name[el]=Ρυθμίσεις
          Name[hu]=Beállítások
          Name[it]=Impostazioni
          Name[ja]=設定
          Name[ko]=설정
          Name[no]=Innstillinger
          Name[pt_PT]=Definições
          Name[pl]=Ustawienia
          Name[ro]=Setări
          Name[ru]=Настройки
          Name[es]=Parámetros
          Name[sv]=Inställningar
          Name[zh_CN]=设置
          Name[zh_TW]=設定
          Name[th]=การตั้งค่า
          Name[tr]=Ayarlar
          Name[uk]=Налаштування
          Name[vi]=Thiết lập
          Exec=steam steam://open/settings %U -nochatui -nofriendsui -silent -steamos3

          [Desktop Action BigPicture]
          Name=Big Picture
          Exec=steam steam://open/bigpicture %U -nochatui -nofriendsui -silent -steamos3

          [Desktop Action Friends]
          Name=Friends
          Name[pt_BR]=Amigos
          Name[bg]=Приятели
          Name[cs]=Přátelé
          Name[da]=Venner
          Name[nl]=Vrienden
          Name[fi]=Kaverit
          Name[fr]=Amis
          Name[de]=Freunde
          Name[el]=Φίλοι
          Name[hu]=Barátok
          Name[it]=Amici
          Name[ja]=フレンド
          Name[ko]=친구
          Name[no]=Venner
          Name[pt_PT]=Amigos
          Name[pl]=Znajomi
          Name[ro]=Prieteni
          Name[ru]=Друзья
          Name[es]=Amigos
          Name[sv]=Vänner
          Name[zh_CN]=好友
          Name[zh_TW]=好友
          Name[th]=เพื่อน
          Name[tr]=Arkadaşlar
          Name[uk]=Друзі
          Name[vi]=Bạn bè
          Exec=steam steam://open/friends %U -nochatui -nofriendsui -silent -steamos3
        '';
      };

      # Not yet implemented in Home-Manager 24.11
      # But deployed in 2025 : https://github.com/nix-community/home-manager/commits/master/modules/misc/xdg-autostart.nix
      # xdg.autostart = {
      #   enable = true;
      #   entries = ["steam.desktop"];
      # };
    };
  };
}
