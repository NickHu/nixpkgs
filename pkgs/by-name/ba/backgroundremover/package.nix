{
  python3,
  lib,
  runCommand,
  fetchFromGitHub,
  fetchurl,
  gitUpdater,
}:

let
  p = python3.pkgs;
  self = p.buildPythonApplication rec {
    pname = "backgroundremover";
    version = "0.3.0";
    pyproject = true;

    build-system = [
      p.setuptools
    ];

    src = fetchFromGitHub {
      owner = "nadermx";
      repo = "backgroundremover";
      rev = "v${version}";
      hash = "sha256-fWazMDjc+EoXvO7Iq+zwtJaMEU64ajpO6JtlvU5T0nc=";
    };

    models = runCommand "background-remover-models" { } ''
      mkdir $out
      cat ${src}/models/u2a{a,b,c,d} > $out/u2net.pth
      cat ${src}/models/u2ha{a,b,c,d} > $out/u2net_human_seg.pth
      cp ${src}/models/u2netp.pth $out
    '';

    postPatch = ''
      rm -rf *dist
      substituteInPlace backgroundremover/bg.py backgroundremover/u2net/detect.py \
        --replace-fail 'os.path.expanduser(os.path.join("~", ".u2net", model_name + ".pth"))' "os.path.join(\"$models\", model_name + \".pth\")"

      substituteInPlace backgroundremover/bg.py \
        --replace-fail 'import moviepy.editor' 'import moviepy'
    '';

    pythonRelaxDeps = [
      "pillow"
      "torchvision"
      "moviepy"
    ];

    dependencies = [
      p.certifi
      p.charset-normalizer
      p.ffmpeg-python
      p.filelock
      p.filetype
      p.hsh
      p.idna
      p.more-itertools
      p.moviepy
      p.numpy
      p.pillow
      p.pymatting
      p.pysocks
      p.requests
      p.scikit-image
      p.scipy
      p.six
      p.torch
      p.torchvision
      p.tqdm
      p.urllib3
      p.waitress
    ];

    pythonImportsCheck = [ "backgroundremover" ];

    passthru = {
      inherit models;
      tests = {
        image =
          let
            # random no copyright car image from the internet
            demoImage = fetchurl {
              url = "https://pics.craiyon.com/2023-07-16/38653769ac3b4e068181cb5ab1e542a1.webp";
              hash = "sha256-Kvd06eZdibgDbabVVe0+cNTeS1rDnMXIZZpPlHIlfBo=";
            };
          in
          runCommand "backgroundremover-image-test.png"
            {
              buildInputs = [ self ];
            }
            ''
              export NUMBA_CACHE_DIR=$(mktemp -d)
              backgroundremover -i ${demoImage} -o $out
            '';
      };
      updateScript = gitUpdater { rev-prefix = "v"; };
    };

    doCheck = false; # no tests

    meta = {
      mainProgram = "backgroundremover";
      description = "Command line tool to remove background from image and video, made by nadermx to power";
      homepage = "https://BackgroundRemoverAI.com";
      downloadPage = "https://github.com/nadermx/backgroundremover/releases";
      license = lib.licenses.mit;
      maintainers = [ lib.maintainers.lucasew ];
    };
  };
in
self
