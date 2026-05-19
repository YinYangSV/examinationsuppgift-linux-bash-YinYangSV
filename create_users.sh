#!/bin/bash

# Kontrollerar root-behörighet
if [ "$EUID" -ne 0 ]; then
    echo "Kör som root!"
    exit 1
fi

# Kontrollerar att minst ett argument skickats in
if [ "$#" -eq 0 ]; then
    echo "Användning: $0 <användare1> <användare2> ..."
    exit 1
fi

# Loopar igenom alla användare som skickats in
for user in "$@"; do

    # Kontrollerar om användaren redan finns
    if id "$user" &>/dev/null; then
        echo "Användaren $user finns redan i systemet, hoppar över."
        continue
    fi

    # Skapar användaren med hemkatalog
    useradd --badname -m "$user"

    # Skapar undermappar
    mkdir -p "/home/$user/Documents"
    mkdir -p "/home/$user/Downloads"
    mkdir -p "/home/$user/Work"

    # Sätter rättigheter på undermappar (endast ägaren kommer åt dem)
    chmod 700 "/home/$user/Documents"
    chmod 700 "/home/$user/Downloads"
    chmod 700 "/home/$user/Work"

    # Skapar en personlig välkomstfil
    echo "Välkommen $user!" > "/home/$user/welcome.txt"
    echo "Ditt konto skapades: $(date)" >> "/home/$user/welcome.txt"
    echo "Dina mappar: Work, Downloads, Documents" >> "/home/$user/welcome.txt"

    # Sätter användaren som ägare av hela hemkatalogen
    chown -R "$user":"$user" "/home/$user"

    # Skriver ut välkomstfilen
    echo "--- Användare $user skapad ---"
    cat "/home/$user/welcome.txt"
    echo ""

done
