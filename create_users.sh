#!/bin/bash'
if [ "$EUID" -ne 0 ]; then
    echo "Kör som root!"
fi

for user in "$@" ; do
    echo "Söker användare för $user"
    id "$user" &>/dev/null
if [ $? -eq 0 ]; then
    echo "Användaren $@ finns redan i systemet"
    continue
fi

useradd -m "$user"
mkdirm /home/$user/Documents /home/$user/Downloads /home/$user/Work
chmod 700 /home/$user/Documents /home/$user/Downloads /home/$user/Work
chown -R $user:$user /home/$user
echo "Välkommen $user" > /home/$user/welcome.txt
cut -d: -f1 /ect/passwd | grep -v "^$user$" >> /home/$user/welcome.txt
cat /home/$user/welcome.txt

done
