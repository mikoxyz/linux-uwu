#!/bin/sh

# Check if git is installed
if ! [ -x "$(command -v git)" ]; then
    echo "git is not installed on your system. Please install git using your package manager."
    exit 1
fi

# Run figlet if it's present (I only added this because I wanted to try out git's gpg signing feature; also, it just looks really neat :p)
if [ -x "$(command -v figlet)" ]; then
    figlet linux-uwu 5.10.8
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
    cp linux-uwu-configs/config-5.10.8-uwu-intel .config
elif :; then
    echo "Copying the normal config to .config..."
    cp linux-uwu-configs/config-5.10.8-uwu .config
fi

echo "Starting the build..."
make -j`nproc` bindeb-pkg LOCALVERSION=-uwu
echo "Done!"

exit 0
