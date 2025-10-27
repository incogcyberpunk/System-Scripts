# Description: A bash script to fetch and store the Nepali date daily using a Node.js script.
#!/usr/bin/env bash

FILE="$HOME/nepaliDate"

# Function to store the Nepali date
storeNepaliDate(){
    if [[ $(node ~/sysScripts/getDate.js) ]]; then 
    nepaliDate=$(node ~/sysScripts/getDate.js | xargs echo)
    echo -e "$(date +%d)\n$nepaliDate" >> "$FILE"
else
    notify-send "Error running Node.js script" "Check the terminal for more details."
    echo "Error running Node.js script, try running the node.js script manually to debug."
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
    else
    displayNepaliDate
    fi
fi
 
