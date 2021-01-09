#!/bin/sh

# Check if git is installed
if !  [ -x "$(command -v git)" ]; then
    echo "git is not installed on your system. Please install git using your package manager."
    exit 1
fi

echo "Welcome to the linux-uwu build script!\nDo you want to install the build dependencies? [y/n]"

# This is probably really hacky, but it works ¯\_(ツ)_/¯
while true; do
    read input
    if [ "$input" = "y" ]; then
        echo "Installing the build dependencies..."
        sudo apt-get update && sudo apt-get install build-essential && sudo apt-get build-dep linux
        break
    elif [ "$input" = "n" ]; then
        break
    elif [ "$input" != "y" ] || [ "$input" != "n" ]; then
        echo "Please enter 'y' or 'n'."
    fi
done

echo "Cloning the configs repo..."
git clone git@github.com:mikoxyz/linux-uwu-configs
echo "Copying the config to .config..."
cp linux-uwu-configs/config-5.10.4-uwu .config
echo "Starting the build..."
make -j`nproc` bindeb-pkg LOCALVERSION=-uwu
echo "Done!"

exit 0
