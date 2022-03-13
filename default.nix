{ pkgs ? import <nixpkgs> {}
, defaultPort ? "5002"
, defaultHost ? "localhost"
}:
let
  desktopIcon = pkgs.fetchurl {
    url = "<TODO>";
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };
  desktopItem = pkgs.makeDesktopItem {
    name = "tts-app";
    exec = "tts-app";
    #icon = desktopIcon;
    comment = "Text to speech ui";
    desktopName = "TTS App";
    genericName = "TTS";
    categories = ["Audio"];
  };
in
pkgs.stdenv.mkDerivation {
  name = "tts-app";
  src = ./.;
  buildInputs = with pkgs; [
    gtk4
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];
  preFixup = ''
    gappsWrapperArgs+=(
      --set TTS_HOST ${defaultHost}
      --set TTS_PORT ${defaultPort}
    )
  '';
  postInstall = ''
    mkdir -p $out/share/applications
    cp -r ${desktopItem}/share/applications $out/share/applications
  '';

  nativeBuildInputs = with pkgs; [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];
}
