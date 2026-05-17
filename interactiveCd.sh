#!/usr/bin/env bash
# Script that provides a dmenu like rofi interactive menu to type the directory and then open yazi in that provided dir.

# Get the directory to cd into interactively
dir=$(zoxide query --list --score | rofi -dmenu -i | awk '{print $2}')

# Open yazi in that directory
[[ -n "$dir" ]] && ghostty -e yazi "$dir"
