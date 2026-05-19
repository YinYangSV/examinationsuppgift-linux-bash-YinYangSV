#!/bin/bash
#Kontrolerear root, $EUID är en befintlig variablem, "-ne 0" kollar om den är 0, det vill säga om värdet är 0 är det en root användare,
#om rootanvändaren finns kommer medelandet "upp kör som root!", annars forsätter den med koden
if [ "$EUID" -ne 0 ]; then
    echo "Kör som root!"
    exit "Användaren är ej root!"
fi
#kontrollerar att minst ett argument skickats in
if [ "$#" -eq 0 ]; then
    echo "Användning $0 <användare1> <användare2>..."
    return 1
fi
    
#Här börjar loopen för användarskapandet
#Första delen kollar om användaren finns i systemet och därefter antingen fortsätter med att skapa en användare eller,
#att avsluta koden med ett felmeddelande att användaren redan finns
for user in $@; do
    
if id "$user" &>/dev/null; then
    echo "Användaren $user finns redan i systemet, testa ett annat namn"
    return 1
fi
#Skapar användare och lägger till /home i direktory med -m, samt undviker stikta regler med --badname
    useradd --badname -m "$user"
#mkdir skapar vi undermapparna för användaren och då skapar vi,Documents, Downloads, Work. Sedan ifall undermapparna redan finns så skapas dem inte och de skickas inget felmeddelande via -p
    mkdir -p "/home/$user/Documents"
    mkdir -p "/home/$user/Downloads"
    mkdir -p "/home/$user/Work"

#Nu sätter vi att användaren blir ägaren över undermapparna, och tillsammans med chown senare äger användaren hela sin användarflik och allt inom de också
    chmod 700 "/home/$user/Documents"
    chmod 700 "/home/$user/Downloads"
    chmod 700 "/home/$user/Work"

echo "Välkommen $user" > /home/$user/welcome.txt

#Cut hämtar första fältet i /etc/passwd, alltså användaren och tar bort den aktuella användaren från listan "| grep -v
    cut -d: -f1 /etc/passwd | grep -v "^$user$" >> "/home/$user/welcome.txt"

    chown -R "$user:$user" "/home/$user"

#skickar ut välkommen meddelantet
    cat /home/$user/welcome.txt

done
