{ stdenv, jenkins, fetchurl, makeWrapper, unzip, openjdk11 }:

let openjdk = openjdk11;
in

stdenv.mkDerivation rec {
  pname = "plugin-installation-manager";
  version = "2.12.3";

  src = fetchurl {
    url = "https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/${version}/jenkins-plugin-manager-${version}.jar";
    sha256 = "sha256-YpWWS2zl+DoxWiu4+eOTLZMA5j5mGMWpiy9todcdXwI=";
  };

  nativeBuildInputs = [ makeWrapper unzip ];

  buildCommand = ''
    mkdir -p $out/bin
    #(cd $out/share/webapps && ${openjdk}/bin/jar -xf ${jenkins}/webapps/jenkins.war)
    makeWrapper "${openjdk}/bin/java" "$out/bin/plugin-installation-manager" \
        --set JAVACMD "${openjdk}/bin/java" \
        --set JAVA_OPTS "--illegal-access=permit" \
        --add-flags "-jar ${src} --war=${jenkins}/webapps/jenkins.war"
  '';
}
