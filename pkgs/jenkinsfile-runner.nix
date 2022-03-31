{ stdenv, pkgs, jenkins, fetchurl, makeWrapper, unzip, openjdk11 }:

let openjdk = openjdk11;
in

stdenv.mkDerivation rec {
  pname = "jenkinsfile-runner";
  version = "1.0-beta-30";

  src = fetchurl {
    url = "https://github.com/jenkinsci/jenkinsfile-runner/releases/download/${version}/jenkinsfile-runner-${version}.zip";
    sha256 = "sha256-O02oVAxnx1U09CKjgkx+9D4/KtqJ3MrWa3YwLkdpHY8=";
  };

  nativeBuildInputs = [ makeWrapper unzip ];

  buildCommand = ''
    mkdir -p $out/bin $out/share/java $out/share/webapps
    (cd $out/share/java && unzip  $src)
    (cd $out/share/webapps && ${openjdk}/bin/jar -xf ${jenkins}/webapps/jenkins.war)
    chmod +x $out/share/java/bin/jenkinsfile-runner
    patchShebangs $out/share/java/bin/jenkinsfile-runner
    rm $out/share/java/bin/jenkinsfile-runner.bat # we don't have windows
    cat >$out/bin/jenkinsfile-runner <<EOF
    #!${pkgs.runtimeShell}
    export JAVACMD="${openjdk}/bin/java"
    export JAVA_OPTS="--illegal-access=permit"
    echo "NOTE: Ignore warnings about \"illegal reflective access\"" 
    exec $out/share/java/bin/jenkinsfile-runner \$@ --jenkins-war=$out/share/webapps/
    EOF
    chmod +x $out/bin/jenkinsfile-runner
  '';
}
