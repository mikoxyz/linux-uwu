#!/bin/sh

KERNEL_VER=5.10.12

# Check if git is installed
if ! [ -x "$(command -v git)" ]; then
	printf "git is either not installed on your system or in your path.\
Please install git using your package manager or add git to your path.\n"
	exit 1
fi

# Run figlet if it's present
if [ -x "$(command -v figlet)" ]; then
	figlet linux-uwu $KERNEL_VER
fi

printf "Welcome to the linux-uwu build script!\n\
Do you want to install the build dependencies? [y/n] "

# This is probably really hacky, but it works ¯\_(ツ)_/¯
while true; do
    read input
    if [ "$input" = "y" ]; then
        printf "Installing the build dependencies..."
        sudo apt-get update && sudo apt-get install build-essential -y &&\
        sudo apt-get build-dep linux -y
        break
    elif [ "$input" = "n" ]; then
        break
    elif [ "$input" != "y" ] || [ "$input" != "n" ]; then
        printf "Please enter 'y' or 'n'.\n"
    fi
done

echo "Cloning the configs repo..."
git clone git@github.com:mikoxyz/linux-uwu-configs

# Check if host CPU is Intel and use the Intel config if that's the case. 
# Otherwise, use the normal config
if lscpu | grep -q Intel; then
    echo "Copying the Intel config to .config..."
    cp linux-uwu-configs/config-${KERNEL_VER}-uwu-intel .config
elif :; then
    echo "Copying the normal config to .config..."
    cp linux-uwu-configs/config-${KERNEL_VER}-uwu .config
fi

echo "Starting the build..."
make -j`nproc` bindeb-pkg LOCALVERSION=-uwu
unset KERNEL_VER
echo "Done!"

exit 0
