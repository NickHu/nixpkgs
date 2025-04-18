{
  fetchFromGitHub,
  qtbase,
  stdenv,
  lib,
  wrapQtAppsHook,
  qmake,
  qtcharts,
  qtwebengine,
  qtserialport,
  qtwebchannel,
  hamlib,
  qtkeychain,
  pkg-config,
  cups,
}:

stdenv.mkDerivation rec {
  pname = "qlog";
  version = "0.43.0";

  src = fetchFromGitHub {
    owner = "foldynl";
    repo = "QLog";
    rev = "v${version}";
    hash = "sha256-gCXLZ00klyjisLxSvs4wKD0Sg8CFvF0xR+eHpc1D0Jc=";
    fetchSubmodules = true;
  };

  env.NIX_LDFLAGS = "-lhamlib";

  buildInputs =
    [
      qtbase
      qtcharts
      qtwebengine
      qtserialport
      qtwebchannel
      hamlib
      qtkeychain
    ]
    ++ (lib.optionals stdenv.hostPlatform.isDarwin [
      cups
    ]);

  nativeBuildInputs = [
    wrapQtAppsHook
    qmake
    pkg-config
  ];

  meta = with lib; {
    description = "Amateur radio logbook software";
    mainProgram = "qlog";
    license = with licenses; [ gpl3Only ];
    homepage = "https://github.com/foldynl/QLog";
    maintainers = with maintainers; [
      oliver-koss
      mkg20001
    ];
    platforms = with platforms; unix;
  };
}
