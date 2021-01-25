#!/bin/sh

KERNEL_VER=5.10.10

# Check if git is installed
if ! [ -x "$(command -v git)" ]; then
    echo "git is not installed on your system. Please install git using your package manager."
    exit 1
fi

# Run figlet if it's present (I only added this because I wanted to try out git's gpg signing feature; also, it just looks really neat :p)
if [ -x "$(command -v figlet)" ]; then
    figlet linux-uwu $KERNEL_VER
fi

echo "Welcome to the linux-uwu build script!\nDo you want to install the build dependencies? [y/n]"

# This is probably really hacky, but it works ¯\_(ツ)_/¯
while true; do
    read input
    if [ "$input" = "y" ]; then
        echo "Installing the build dependencies..."
        sudo apt-get update && sudo apt-get install build-essential -y && sudo apt-get build-dep linux -y
        break
    elif [ "$input" = "n" ]; then
        break
    elif [ "$input" != "y" ] || [ "$input" != "n" ]; then
        echo "Please enter 'y' or 'n'."
    fi
done

echo "Cloning the configs repo..."
git clone git@github.com:mikoxyz/linux-uwu-configs

# Check if host CPU is Intel and use the Intel config if that's the case. Otherwise, use the normal config
if lscpu | grep -q Intel; then
    echo "Copying the Intel config to .config..."
    cp linux-uwu-configs/config-$KERNEL_VER-uwu-intel .config
elif :; then
    echo "Copying the normal config to .config..."
    cp linux-uwu-configs/config-$KERNEL_VER-uwu .config
fi

echo "Starting the build..."
make -j`nproc` bindeb-pkg LOCALVERSION=-uwu
unset KERNEL_VER
echo "Done!"

exit 0
