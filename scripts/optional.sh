#!/bin/bash
# This script will download and add domains from the rep to whitelist.txt file.
# Project homepage: https://github.com/anudeepND/whitelist
# Licence: https://github.com/anudeepND/whitelist/blob/master/LICENSE
# Created by Anudeep
#================================================================================
TICK="[\e[32m ✔ \e[0m]"
PIHOLE_LOCATION="/etc/pihole"
GRAVITY_UPDATE_COMMAND="pihole -g"
echo -e " \e[1m This file contains tracking and adserving domains. Run this script if you use specific service that require certain adserving domains to be whitelisted. If you don't use such service, please run ./whitelist.sh  \e[0m"
read -p "Do you want to continue (Y/N)? " -n 1 -r
echo   
if [[ $REPLY =~ ^[Yy]$ ]]
then

	echo -e " \e[1m This script will download and add domains from the repo to whitelist.txt \e[0m"
	sleep 1
	echo -e "\n"

	if [ "$(id -u)" != "0" ] ; then
		echo "This script requires root permissions. Please run this as root!"
		exit 2
	fi


	curl -sS https://raw.githubusercontent.com/jsodeman/whitelist_js/master/domains/optional-list.txt | sudo tee -a "${PIHOLE_LOCATION}"/whitelist.txt >/dev/null
	echo -e " ${TICK} \e[32m Adding domains to whitelist... \e[0m"
	sleep 0.5
	echo -e " ${TICK} \e[32m Removing duplicates... \e[0m"

	mv "${PIHOLE_LOCATION}"/whitelist.txt /etc/pihole/whitelist.txt.old && cat "${PIHOLE_LOCATION}"/whitelist.txt.old | sort | uniq >> "${PIHOLE_LOCATION}"/whitelist.txt

	wait
	echo -e " [...] \e[32m Pi-hole gravity rebuilding lists. This may take a while \e[0m"
	${GRAVITY_UPDATE_COMMAND} > /dev/null
	wait
	echo -e " ${TICK} \e[32m Pi-hole's gravity updated \e[0m"
	echo -e " ${TICK} \e[32m Done! \e[0m"

	echo -e " \e[1m  Star me on GitHub, https://github.com/anudeepND/whitelist \e[0m"
	echo -e " \e[1m  Happy AdBlocking :)\e[0m"
	echo -e "\n\n"

fi
