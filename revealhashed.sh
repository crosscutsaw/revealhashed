#!/bin/bash

bblue='\033[1;34m'
bbred='\033[1;31m'
bgreen='\033[1;32m'
bwhite='\033[1;37m'
reset='\033[0m'

echo ''
echo -e "${bblue}revealhashed v1.1${reset}"
echo ''

echo -e "${bbred}removing old files if they are exist or not.${reset}"
rm -rf /tmp/revealhashed
echo ''

echo -e "${bwhite}current working directory is: $(pwd)${reset}"
echo ''

mkdir /tmp/revealhashed
echo -e "${bgreen}ntds file: default path (/root/.nxc/logs/) or would you provide?${reset}"
echo -e "${bwhite}type n to use default path"
echo -e "type y to provide ntds file${reset}"
read response1

if [ "$response1" = "n" ]; then
    echo ''
    echo -e "${bgreen}using default path.${reset}"
    cp /root/.nxc/logs/*.ntds /tmp/revealhashed/
    cat /tmp/revealhashed/*.ntds | awk -F: '{print $4}' | awk '!/31d6cfe0d16ae931b73c59d7e0c089c0/' | sort | uniq >> /tmp/revealhashed/rh2cracked.txt
    
elif [ "$response1" = "y" ]; then
    echo ''
    echo -e "${bgreen}provide the ntds file${reset}"
    read file
    echo ''
    echo -e "${bgreen}script will use \"$file\".${reset}"    
    cat $file | awk -F: '{print $4}' | awk '!/31d6cfe0d16ae931b73c59d7e0c089c0/' | sort | uniq >> /tmp/revealhashed/rh2cracked.txt
    cat $file > /tmp/revealhashed/individual.ntds

else
    echo 'deadass???'
    exit
fi

echo ''
echo -e "${bgreen}hashes sorted and available at \"/tmp/revealhashed/rh2cracked.txt\".${reset}"
echo ''
echo -e "${bgreen}do you want to remove hashcat potfile?${reset}"
echo -e "${bwhite}type n to don't remove"
echo -e "type y to remove${reset}"
read response2
echo ''

if [ "$response2" = "y" ]; then
    echo -e "${bgreen}removing hashcat potfile.${reset}"
    find / -name 'hashcat.potfile' -exec rm -rf {} \;
    echo -e "${bwhite}done${reset}"
    
elif [ "$response2" = "n" ]; then
    echo -e "${bgreen}not removing hashcat potfile.${reset}"

else
    echo 'deadass???'
    exit
fi

echo ''
echo -e "${bgreen}script will start hashcat in quiet mode. you can stop cracking by pressing \"q\".${reset}"
echo ''
echo -e "${bgreen}provide your wordlist${reset}"
read wordlist
echo ''
echo -e "${bgreen}\"$wordlist\" will be used with hashcat.${reset}"
echo ''
echo -e "${bgreen}hashcat session is starting. $(date)${reset}"
echo ''
hashcat -m1000 /tmp/revealhashed/rh2cracked.txt $wordlist --quiet
echo ''
echo -e "${bgreen}hashcat session is completed. $(date)${reset}"
echo ''
echo -e "${bgreen}copying hashcat.potfile to \"/tmp/revealhashed/\".${reset}"
find / -name 'hashcat.potfile' -exec cp {} /tmp/revealhashed/ 2>/dev/null \;
echo -e "${bwhite}done${reset}"
echo ''
while IFS=: read -r h1 h2
do
    grep "$h1" /tmp/revealhashed/*.ntds | sed -e "s/$/ $h2/" >> /tmp/revealhashed/revealhashed.txt
done < /tmp/revealhashed/hashcat.potfile
echo -e "${bgreen}revealing results${reset}"
echo ''
#if you don't want to see disabled accounts' password then change the line blow with this:
#awk -F ':' '!/\(status=Disabled\)/ {gsub(/\(status=Enabled\)/, ""); print $1, $7}' /tmp/revealhashed/revealhashed.txt | awk '!x[$0]++' | sort -k2
awk -F ':' '{gsub(/\(status=Enabled\)|\(status=Disabled\)/, ""); print $1, $7}' /tmp/revealhashed/revealhashed.txt | awk '!x[$0]++' | sort -k2

# revealhashed v1.1
# 
# contact options
# mail: https://blog.zurrak.com/contact.html
# twitter: https://twitter.com/tasiyanci
# linkedin: https://linkedin.com/in/aslanemreaslan