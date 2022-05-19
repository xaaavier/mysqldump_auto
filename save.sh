#!/bin/bash
date=`date +%d.%m.%Y`
time=`date +%H-%M`
pwd=`pwd`
echo -e "\e[36mServer's address ?\e[0m"
read srvip
echo -e "\e[36mServer's login ?\e[0m"
read srvuser
echo -e "\e[36mServer password ?\e[0m"
read -s srvpwd
echo -e "\e[36mDatabase's name ? \e[37m(save as MySQL dump)\e[0m"
read bddname
echo -e "\e[36mDatabase's user ?\e[0m"
read bdduser
echo -e "\e[36mDatabase's password ?\e[0m"
read -s bddpasswd
mkdir $bddname 2> /dev/null
mkdir $bddname/$date 2> /dev/null
touch /tmp/mysqldump 2> /dev/null
# checks if the server is online
ping  -c 1 $srvip &> /dev/null
# if the server is online, checks if it accepts ssh connections
if [ $? -eq 0 ]
	then
	`sshpass -p$srvpwd ssh -q -o StrictHostKeyChecking=no $srvuser@$srvip :`
	if [ $? -eq 0 ]
		then
# if the connexion is possible, do local database dump
		``sshpass -p$srvpwd ssh -q $srvuser@$srvip mysqldump --user=$bdduser --password=$bddpasswd $bddname > "$pwd"/"$bddname"/"$date"/"$time"_glpi_dump.SQL & sleep 10` &> /dev/null`
			if [ $? -eq 0 ]
				then
				echo -e "\e[32mSuccessfull dump\e[0m"
				else
				echo -e "\e[31mUnable to dump $bddname\e[0m"
				echo "$date - $time : backup failed" >> /tmp/mysqldump
			fi
		else 
		echo -e "\e[31mConnexion failed\e[0m"
		echo "$date - $time : connexion failed" >> /tmp/mysqldump
	fi
	else
	echo -e "\e[31mServer unreachable\e[0m"
	echo "$date - $time : Server Unreachable" >> /tmp/mysqldump
fi
