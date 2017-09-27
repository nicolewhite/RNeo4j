# Should be sourced to propogate environment variables
git clone https://github.com/cleishm/libneo4j-client --depth 1
pushd libneo4j-client

mkdir ~/usr
./autogen.sh
./configure --disable-tools --prefix="$HOME/usr"
make install

export CPATH="$HOME/usr/include"
export LIBRARY_PATH="$HOME/usr/lib"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/usr/lib"

popd
