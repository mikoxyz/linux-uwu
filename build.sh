#!/bin/sh

KVER=5.11
PTCHLVL=13
PKGVER=1

# Check if git is installed
if ! [ -x "$(command -v git)" ]; then
	printf "git is either not installed on your system or in your path.\
Please install git using your package manager or add git to your path.\n"
	exit 1
fi

# Run figlet if it's present
if [ -x "$(command -v figlet)" ]; then
	figlet linux-uwu $KVER.$PTCHLVL
fi

printf "Welcome to the linux-uwu build script!\n\
Do you want to install the build dependencies? [y/n] "

# This is probably really hacky, but it works ¯\_(ツ)_/¯
while true; do
	read input
	if [ "$input" = "y" ]; then
		printf "Installing the build dependencies...\n"
		sudo apt-get update; sudo apt-get install build-essential llvm lld\
		clang -y; sudo apt-get build-dep linux -y
		break
	elif [ "$input" = "n" ]; then
		break
	else
		printf "Please enter 'y' or 'n'.\n"
	fi
done

printf "Cloning the configs repo...\n"
git clone git@github.com:mikoxyz/linux-uwu-configs

# Check the host CPU and use the most appropriate config
# TODO: Check znver
if lscpu | grep -q Ryzen; then
	printf "Copying the Ryzen config to .config...\n"
	cp linux-uwu-configs/config-${KVER}.${PTCHLVL}-uwu-znver1 .config
elif lscpu | grep -q AMD; then
	printf "Copying the AMD-native config to .config...\n"	
	cp linux-uwu-configs/config-${KVER}.${PTCHLVL}-uwu-native-amd .config
elif lscpu | grep -q Intel; then
	printf "Copying the Intel-native config to .config...\n"
	cp linux-uwu-configs/config-${KVER}.${PTCHLVL}-uwu-native-intel .config
fi

printf "Starting the build...\n"
make CC=clang LLVM=1 LLVM_IAS=1 -j`nproc` bindeb-pkg LOCALVERSION=-uwu KDEB_PKGVERSION=${KVER}.${PTCHLVL}-uwu-${PKGVER}
unset KVER
unset PTCHLVL
unset PKGVER
printf "Done!\n"

exit 0
