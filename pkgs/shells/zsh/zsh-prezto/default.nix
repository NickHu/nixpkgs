{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zsh-prezto";
  version = "2020-05-02";
  src = fetchFromGitHub {
    owner = "sorin-ionescu";
    repo = "prezto";
    rev = "13c61bae30c3a8cf610623c094f2aa0a95fbf035";
    sha256 = "1i283y1cn4j7c41naafy4zv77shbg9ff6c2sld2lrvy7sarbliy1";
    fetchSubmodules = true;
  };
  buildPhase = ''
    sed -i '/\''${ZDOTDIR:\-\$HOME}\/.zpreztorc" ]]/i\
    if [[ -s "/etc/zpreztorc" ]]; then\
      source "/etc/zpreztorc"\
    fi' init.zsh
    sed -i -e "s|\''${ZDOTDIR:\-\$HOME}/.zprezto/|$out/|g" init.zsh
    for i in runcoms/*; do
      sed -i -e "s|\''${ZDOTDIR:\-\$HOME}/.zprezto/|$out/|g" $i
    done
  '';
  installPhase = ''
    mkdir -p $out
    cp ./* $out/ -R
  '';
  meta = with stdenv.lib; {
    description = "Prezto is the configuration framework for Zsh; it enriches the command line interface environment with sane defaults, aliases, functions, auto completion, and prompt themes.";
    homepage = "https://github.com/sorin-ionescu/prezto";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = with platforms; unix;
  };
}
