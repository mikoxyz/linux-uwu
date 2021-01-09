#!/bin/sh

# Check if git is installed
if !  [ -x "$(command -v git)" ]
then
    echo "git is not installed on your system. Please install git using your package manager."
    exit 1
fi

echo "Welcome to the linux-uwu build script!\nThis build assumes that you have build-essential and the build dependencies for Linux installed.\nPress y if you do, press n if you don't."
read input
if [ "$input" = "n" ]
then
    echo "Exiting the build script..."
    exit 0
fi

echo "Clong the configs repo..."
git clone git@github.com:mikoxyz/linux-uwu-configs
echo "Copying the config to .config..."
cp linux-uwu-configs/config-5.10.4-uwu .config
echo "Starting the build..."
make -j`nproc` bindeb-pkg LOCALVERSION=-uwu
echo "Done!"

exit 0