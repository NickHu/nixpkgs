{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hilbish";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "Rosettea";
    repo = "Hilbish";
    rev = "v${version}";
    hash = "sha256-bCV9hiTvtkdEMPEn9r5PxB+MqJk030E5YISN8B/4h4A=";
    fetchSubmodules = true;
  };

  subPackages = [ "." ];

  vendorHash = "sha256-v5YkRZA8oOKwXa6yFGQ33jKEc742zIrmJ0+w8ggmu/0=";

  ldflags = [
    "-s"
    "-w"
    "-X main.dataDir=${placeholder "out"}/share/hilbish"
  ];

  postInstall = ''
    mkdir -p "$out/share/hilbish"

    cp .hilbishrc.lua $out/share/hilbish/
    cp -r docs -t $out/share/hilbish/
    cp -r libs -t $out/share/hilbish/
    cp -r nature $out/share/hilbish/
  '';

  meta = with lib; {
    description = "Interactive Unix-like shell written in Go";
    mainProgram = "hilbish";
    changelog = "https://github.com/Rosettea/Hilbish/releases/tag/v${version}";
    homepage = "https://github.com/Rosettea/Hilbish";
    maintainers = with maintainers; [ moni ];
    license = licenses.mit;
  };
}
