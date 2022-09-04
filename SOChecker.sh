#!/bin/bash

function installtool()
{ 
# Install all relevant applications, if exists, the commands will upgrade the package list/dependency trees (if any)
	sudo apt-get update && sudo apt-get upgrade
	sudo apt-get install nmap
	sudo apt-get install masscan
	sudo apt-get install hydra
}

function chkme ()
{
	read -p "Would you like to scan an IP Address or execute an attack? A) Nmap B) Masscan C) Hydra (SSH) D) Metasploit- SMB Login Enumeration E) Exit  " checker
	case $checker in
	
	A) 
#Perform nmap to view the available open ports
		read -p "Please provide an IP Address for scannning: " ipadd
		nmap "$ipadd" -Pn -sV -oN ./CheckerOutput/nmap.txt
		echo " "
		echo " "
		cd CheckerOutput
		echo "The result is saved into a file named nmap.txt and it can found at location below."
		pwd
		cd ..
		echo " "
		echo " "
		chkme
	
	;;
	
	B)
#Perform masscan to view the available open ports
		echo "Please provide an IP Address for scannning: "
		read ipadd				
		sudo masscan "$ipadd" -p0-80 -oX ./CheckerOutput/masscan.xml
		echo " "
		echo " "
		cd CheckerOutput
		echo "The result is saved into a file named masscan.xml and it can found at location below."
		pwd
		cd ..
		echo " "
		echo " "
		chkme
		
	;;
	
	C)
#Perform brute force using hydra(SSH)
		location=$(pwd)
		echo "Please provide username file (filename: user.txt) and password file (filename: passwd.txt) at $location for Hydra to brute force" 
		echo "Please provide an IP Address for brute force: "
		read ipadd	
		hydra -L user.txt -P passwd.txt "$ipadd" ssh -vV -o ./CheckerOutput/hydra.txt
		echo " "
		echo " "
		cd CheckerOutput
		echo "The result is saved into a file named hydra.txt and it can found at location below."
		pwd
		cd ..
		echo " "
		echo " "
		chkme
		
	;;
#Section D	
	D)
#Perform Metasploit- SMB login enumeration 
		echo "Please provide username file (filename: user.txt) and password file (filename: passwd.txt) at $location for Metasploit to brute force" 
		echo "Default IP Address set to brute force is 10.0.0.1. Please amend the IP Address in the script (under Section D-rhosts) if you wish to use another IP Address."
		
		echo 'use auxiliary/scanner/smb/smb_login' > smb_enum_scripttest.rc
#Default IP Address as below
		echo 'set rhosts 10.0.0.1' >> smb_enum_scripttest.rc
		echo 'set user_file user.txt' >> smb_enum_scripttest.rc
		echo 'set pass_file passwd.txt' >> smb_enum_scripttest.rc
		echo 'run' >> smb_enum_scripttest.rc
		echo 'exit' >> smb_enum_scripttest.rc
		
		msfconsole -r smb_enum_scripttest.rc -o ./CheckerOutput/SMBenum.txt
		echo " "
		echo " "
		cd CheckerOutput
		echo "The result is saved into a file named SMBenum.txt and it can found at location below."
		pwd
		cd ..
		echo " "
		echo " "
		chkme
	
	;;
	
	E) 
		exit
	
	;;
	
	esac
}
mkdir CheckerOutput   #create a new directory/folder called CheckerOutput
installtool			  #install all relevant tools which will be used in this script
chkme				  #Performing various scans and attacks
		
