if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
    brew update
    brew tap caskroom/cask
    brew install caskroom/versions/java8 llvm cleishm/neo4j/neo4j-client
    export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
else
    export JAVA_HOME=/usr/lib/jvm/java-8-oracle
    . ./build-libneo4j-client.sh
fi
curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain 1.15.1
. ~/.cargo/env