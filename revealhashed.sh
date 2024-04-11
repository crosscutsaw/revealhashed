#!/bin/bash

bblue='\033[1;34m'
bbred='\033[1;31m'
bgreen='\033[1;32m'
bwhite='\033[1;37m'
reset='\033[0m'

echo -e "${bblue}revealhashed v1.1${reset}"
echo ''

echo -e "${bbred}removing old files if they are exist or not${reset}"
rm -rf /tmp/rh2cracked.txt, /tmp/revealhashed.txt, /tmp/hashcat.potfile
echo ''

echo -e "${bgreen}ntds file: default path (/root/.nxc/logs/) or would you provide?${reset}"
echo -e "${bwhite}type n to use default path"
echo -e "type y to provide ntds file${reset}"
read response1

if [ "$response1" = "n" ]; then
    echo -e "${bwhite}using default path${reset}"
    cat /root/.nxc/logs/*.ntds | awk -F: '{print $4}' | awk '!/31d6cfe0d16ae931b73c59d7e0c089c0/' |  sort | uniq >> /tmp/rh2cracked.txt
    
elif [ "$response1" = "y" ]; then
    echo -e "${bwhite}provide the ntds file${reset}"
    read file
    echo -e "${bwhite}script will use $file${reset}"
    cat $file | awk -F: '{print $4}' | awk '!/31d6cfe0d16ae931b73c59d7e0c089c0/' | sort | uniq >> /tmp/rh2cracked.txt

else
    echo 'deadass???'
fi

echo ''
echo -e "${bgreen}hashes sorted and available at /tmp/rh2cracked.txt${reset}"
echo ''
echo -e "${bgreen}do you want to remove hashcat potfile?${reset}"
echo -e "${bwhite}type y to remove (recommended)"
echo -e "type n to dont remove${reset}"
read response2
echo ''

if [ "$response2" = "y" ]; then
    echo -e "${bwhite}removing hashcat potfile${reset}"
    find / -name 'hashcat.potfile' -exec rm -rf {} \;
    echo -e "${bwhite}done${reset}"
    
elif [ "$response2" = "n" ]; then
    echo ''

else
    echo 'deadass???'
fi

echo ''
echo -e "${bgreen}script will start hashcat in quiet mode. you can stop cracking by pressing q.${reset}"
echo ''
echo -e "${bwhite}provide your wordlist${reset}"
read wordlist
echo -e "${bwhite}$wordlist will be used with hashcat${reset}"
echo ''
hashcat -m1000 /tmp/rh2cracked.txt $wordlist --quiet
echo ''
echo -e "${bgreen}hashcat session is completed.${reset}"
echo ''
echo -e "${bgreen}copying hashcat.potfile to /tmp/${reset}"
find / -name 'hashcat.potfile' -exec cp {} /tmp/ \;
echo -e "${bwhite}done${reset}"
echo ''
while IFS=: read -r h1 h2
do
  grep "$h1" /root/.nxc/logs/*.ntds | sed -e "s/$/ $h2/" >> /tmp/revealhashed.txt
done < /tmp/hashcat.potfile
echo -e "${bgreen}revealing results${reset}"
echo ''
awk -F':' '{gsub(/\(status=Enabled\)|\(status=Disabled\)/, ""); print $1, $7}' /tmp/revealhashed.txt | awk '!x[$0]++' | sort -k2

# revealhashed 1.1
# 
# contact options
# mail: https://blog.zurrak.com/contact.html
# twitter: https://twitter.com/tasiyanci
# linkedin: https://linkedin.com/in/aslanemreaslan