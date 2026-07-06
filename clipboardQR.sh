#!/usr/bin/env bash
set -euo pipefail

usage() {
    echo "Usage: $(basename "$0") [text/url | -]"
    echo "  <text>      Encode the given text/url directly"
    echo "  -           Read from stdin explicitly"
    echo "  (no arg)    Auto-detect piped stdin, else fall back to clipboard (wl-paste)"
    exit 1
}

checkCommand(){
    command -v "$1" &>/dev/null || {
        echo "Error: $1 not installed." >&2;
        exit 1; 
    }
}

# --- Dependency checks ---
checkCommand "qrencode"
checkCommand "ghostty"

# --- Input handling ---
if [[ $# -ge 1 && "$1" == "-" ]]; then
    # Explicit stdin flag -> read from stdin
    content="$(cat -)"
elif [[ $# -ge 1 ]]; then 
    # Argument provided -> use it directly
    content="$1"
elif [[ ! -t 0 ]]; then
    # if stdin is not a terminal -> data is being piped/redirected in
    content="$(cat -)"
else
    usage
fi

# Validate that some content was provided/captured
[[ -z "$content" ]] && {
    echo "Error: no content to encode." >&2;
    exit 1;
}

# --- Render QR in a ghostty popup, pause so it doesn't vanish instantly ---
ghostty -e bash -c "qrencode -t UTF8i '$content';
echo;
echo 'Press any key to close...';
read -n 1 -s;
"
