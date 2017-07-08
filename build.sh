#!/bin/bash

set -e

date
ps axjf

#################################################################
# Update Ubuntu and install prerequisites for running WinCoin   #
#################################################################
sudo apt-get update
#################################################################
# Build WinCoin from source                                     #
#################################################################
NPROC=$(nproc)
echo "nproc: $NPROC"
#################################################################
# Install all necessary packages for building WinCoin           #
#################################################################
sudo apt-get install -y qt4-qmake libqt4-dev libminiupnpc-dev libdb++-dev libdb-dev libcrypto++-dev libqrencode-dev libboost-all-dev build-essential libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libssl-dev libdb++-dev libssl-dev ufw git
sudo add-apt-repository -y ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

cd /usr/local
file=/usr/local/wincoinX
if [ ! -e "$file" ]
then
        sudo git clone https://github.com/wincoinproject/wincoinX.git
fi

cd /usr/local/wincoinX/src
file=/usr/local/wincoinX/src/wincoind
if [ ! -e "$file" ]
then
        sudo make -j$NPROC -f makefile.unix
fi

sudo cp /usr/local/wincoinX/src/wincoind /usr/bin/wincoind

################################################################
# Configure to auto start at boot                                      #
################################################################
file=$HOME/.wincoin
if [ ! -e "$file" ]
then
        sudo mkdir $HOME/.wincoin
fi
printf '%s\n%s\n%s\n%s\n' 'daemon=1' 'server=1' 'rpcuser=u' 'rpcpassword=p' | sudo tee $HOME/.wincoin/wincoin.conf
file=/etc/init.d/wincoin
if [ ! -e "$file" ]
then
        printf '%s\n%s\n' '#!/bin/sh' 'sudo wincoind' | sudo tee /etc/init.d/wincoin
        sudo chmod +x /etc/init.d/wincoin
        sudo update-rc.d wincoin defaults
fi

/usr/bin/wincoind
echo "WinCoin has been setup successfully and is running..."
exit 0

