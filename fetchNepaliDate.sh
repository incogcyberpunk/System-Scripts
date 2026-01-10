# Description: A bash script to fetch and store the Nepali date daily using a JS script.
#!/usr/bin/env bash

FILE="$HOME/nepaliDate"

# Function to store the Nepali date
storeNepaliDate(){
    if [[ $(bun ~/sysScripts/getDate.js) ]]; then 
    nepaliDate=$(bun ~/sysScripts/getDate.js | xargs echo)
    echo -e "$(date +%d)\n$nepaliDate" >> "$FILE"
else
    notify-send "Error running script using Bun" "Check the terminal for more details."
    echo "Error running script using Bun, try running the script manually to debug."
    exit
fi
}

displayNepaliDate(){
    echo -e "\n"
    echo -e "\t\t $(tail -n 1 "$FILE")"
    notify-send "DATE" "$(tail -n 1 "$FILE")"
}

# Check if the file containing the Nepali date exists or if the date has changed
if [ ! -f "$FILE" ]; then
    storeNepaliDate
    displayNepaliDate
else
    if [[ $(head -n 1 "$FILE") != $(date +%d) ]]; then
        rm "$FILE"
        storeNepaliDate
        notify-send "Stored new Nepali Date"
        displayNepaliDate
    else
    displayNepaliDate
    fi
fi
 
