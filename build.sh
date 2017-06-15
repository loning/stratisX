#!/bin/bash

set -e

date
ps axjf

#################################################################
# Update Ubuntu and install prerequisites for running HPXT   #
#################################################################
sudo apt-get update
#################################################################
# Build HPXT from source                                     #
#################################################################
NPROC=$(nproc)
echo "nproc: $NPROC"
#################################################################
# Install all necessary packages for building HPXT           #
#################################################################
sudo apt-get install -y qt4-qmake libqt4-dev libminiupnpc-dev libdb++-dev libdb-dev libcrypto++-dev libqrencode-dev libboost-all-dev build-essential libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libssl-dev libdb++-dev libssl-dev ufw git
sudo add-apt-repository -y ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

cd /usr/local
file=/usr/local/hpxtX
if [ ! -e "$file" ]
then
        sudo git clone https://github.com/hpxtproject/hpxtX.git
fi

cd /usr/local/hpxtX/src
file=/usr/local/hpxtX/src/hpxtd
if [ ! -e "$file" ]
then
        sudo make -j$NPROC -f makefile.unix
fi

sudo cp /usr/local/hpxtX/src/hpxtd /usr/bin/hpxtd

################################################################
# Configure to auto start at boot                                      #
################################################################
file=$HOME/.hpxt
if [ ! -e "$file" ]
then
        sudo mkdir $HOME/.hpxt
fi
printf '%s\n%s\n%s\n%s\n' 'daemon=1' 'server=1' 'rpcuser=u' 'rpcpassword=p' | sudo tee $HOME/.hpxt/hpxt.conf
file=/etc/init.d/hpxt
if [ ! -e "$file" ]
then
        printf '%s\n%s\n' '#!/bin/sh' 'sudo hpxtd' | sudo tee /etc/init.d/hpxt
        sudo chmod +x /etc/init.d/hpxt
        sudo update-rc.d hpxt defaults
fi

/usr/bin/hpxtd
echo "HPXT has been setup successfully and is running..."
exit 0

