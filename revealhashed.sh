#!/bin/bash

rm -rf /tmp/rh2cracked.txt

echo 'ntds file: default path (/root/.nxc/logs/) or would you provide?'
echo 'type n to use default path'
echo 'type y to provide ntds file'
read response1

if [ "$response1" = "n" ]; then
    echo 'using default path'
    cat /root/.nxc/logs/*.ntds | awk -F: '{print $4}' | awk '!/31d6cfe0d16ae931b73c59d7e0c089c0/' |  sort | uniq >> /tmp/rh2cracked.txt
    
elif [ "$response1" = "y" ]; then
    echo 'provide the ntds file'
    read file
    echo "script will use $file"
    cat $file | awk -F: '{print $4}' | awk '!/31d6cfe0d16ae931b73c59d7e0c089c0/' | sort | uniq >> /tmp/rh2cracked.txt

else
    echo 'deadass???'
fi

echo ''
echo 'hashes sorted and available at /tmp/rh2cracked.txt'
echo 'do you want to delete hashcat potfile?'
echo 'type y to delete (recommended)'
echo 'type n to dont delete'
read response2

if [ "$response2" = "y" ]; then
    echo 'deleting hashcat potfile'
    find / -name 'hashcat.potfile' -exec rm -rf {} \;
    echo 'done'
    
elif [ "$response2" = "n" ]; then
    echo ''

else
    echo 'deadass???'
fi

echo 'now script will start hashcat'
echo 'provide your wordlist'
read wordlist
echo "$wordlist will be used with hashcat"
echo ''
hashcat -m1000 /tmp/rh2cracked.txt $wordlist
echo ''
echo ''
echo 'hashcat session is completed'
echo 'copying hashcat.potfile to /tmp/'
find / -name 'hashcat.potfile' -exec cp {} /tmp/ \;
echo 'done'
echo 'revealing'
while IFS=: read -r h1 h2
do
  grep "$h1" /root/.nxc/logs/*.ntds | sed -e "s/$/ $h2/" >> /tmp/revealhashed.txt
done < /tmp/hashcat.potfile
echo ''
echo 'results'
echo ''
awk -F':' '{gsub(/\(status=Enabled\)|\(status=Disabled\)/, ""); print $1, $7}' /tmp/revealhashed.txt | awk '!x[$0]++'

# revealhashed 1.0
# 
# contact options
# mail: https://blog.zurrak.com/contact.html
# twitter: https://twitter.com/tasiyanci
# linkedin: https://linkedin.com/in/aslanemreaslan
