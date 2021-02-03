#!/bin/sh

KVER=5.10.12
PKGVER=2

# Check if git is installed
if ! [ -x "$(command -v git)" ]; then
	printf "git is either not installed on your system or in your path.\
Please install git using your package manager or add git to your path.\n"
	exit 1
fi

# Run figlet if it's present
if [ -x "$(command -v figlet)" ]; then
	figlet linux-uwu $KVER
fi

printf "Welcome to the linux-uwu build script!\n\
Do you want to install the build dependencies? [y/n] "

# This is probably really hacky, but it works ¯\_(ツ)_/¯
while true; do
	read input
	if [ "$input" = "y" ]; then
		printf "Installing the build dependencies...\n"
		sudo apt-get update && sudo apt-get install build-essential -y &&\
		sudo apt-get build-dep linux -y
		break
	elif [ "$input" = "n" ]; then
		break
	elif [ "$input" != "y" ] || [ "$input" != "n" ]; then
		printf "Please enter 'y' or 'n'.\n"
	fi
done

printf "Cloning the configs repo...\n"
git clone git@github.com:mikoxyz/linux-uwu-configs

# Check if host CPU is Intel and use the Intel config if that's the case. 
# Otherwise, use the normal config
if lscpu | grep -q Intel; then
	printf "Copying the Intel config to .config...\n"
	cp linux-uwu-configs/config-${KVER}-uwu-intel .config
elif :; then
	printf "Copying the normal config to .config...\n"
	cp linux-uwu-configs/config-${KVER}-uwu .config
fi

printf "Starting the build..."
make -j`nproc` bindeb-pkg LOCALVERSION=-uwu KDEB_PKGVERSION=${KVER}-${PKGVER}
unset KVER
unset PKGVER
printf "Done!\n"

exit 0
