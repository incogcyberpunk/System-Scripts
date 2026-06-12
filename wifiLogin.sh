#!/usr/bin/env bash
# Storage format: username:password (one per line), colon-delimited
# NOTE: passwords containing ':' are not supported

set -uo pipefail # -u treats unset var. as error, -o pipefail causes pipeline makes entire pipeline return exit code of first failed command in pipeline instead

# ── Config ────────────────────────────────────────────────────────────────────

PORTAL_URL="https://10.100.1.1:8090/login.xml"
DB_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/wifiLogin"
DB_FILE="$DB_DIR/db"

mkdir -p "$DB_DIR"
touch "$DB_FILE"

# ── Internal helpers ──────────────────────────────────────────────────────────

_request() {
    curl -skX POST "$PORTAL_URL" \
        -d "mode=191&username=${1}&password=${2}"
}

# Extract CDATA content from a named XML tag
_cdata() {
    local field="$1" xml="$2"
    printf '%s' "$xml" | grep -oP "(?<=<${field}><!\[CDATA\[)[^\]]*" || true
}

_entry_exists() {
    grep -q "^${1}:" "$DB_FILE" 2>/dev/null
}

_store() {
    local username="$1" password="$2"
    if ! _entry_exists "$username"; then
        printf '%s:%s\n' "$username" "$password" >> "$DB_FILE"
        printf '[+] Stored credentials for "%s" → %s\n' "$username" "$DB_FILE"
    else
        printf '[~] "%s" already in store, skipping\n' "$username"
    fi
}

_remove() {
    local username="$1"
    if _entry_exists "$username"; then
        sed -i "/^${username}:/d" "$DB_FILE"
        printf '[-] Removed stale credentials for "%s" from store\n' "$username"
    fi
}

# ── Core login logic ──────────────────────────────────────────────────────────

# attempt_login <username> <password>
# Exit codes:
#   0 — LIVE (logged in)
#   1 — invalid credentials
#   2 — valid credentials, max login limit hit
#   3 — unexpected response
attempt_login() {
    local username="$1" password="$2"
    local response status message

    response=$(_request "$username" "$password")
    status=$(_cdata "status" "$response")
    message=$(_cdata "message" "$response")

    case "$status" in
        LIVE)
            printf '[+] Logged in as "%s"\n' "$username"
            _store "$username" "$password"
            return 0
            ;;
        LOGIN)
            if printf '%s' "$message" | grep -qi "maximum login limit"; then
                printf '[!] Max login limit for "%s" — credentials valid, storing\n' "$username"
                _store "$username" "$password"
                return 2
            elif printf '%s' "$message" | grep -qi "invalid user"; then
                printf '[-] Invalid credentials for "%s"\n' "$username"
                _remove "$username"
                return 1
            else
                printf '[?] Login failed for "%s": %s\n' "$username" "$message"
                return 3
            fi
            ;;
        "")
            printf '[!] Empty response — portal unreachable or curl failed\n'
            return 3
            ;;
        *)
            printf '[?] Unexpected status "%s" for "%s"\n' "$status" "$username"
            return 3
            ;;
    esac
}

# ── No-args mode: cycle stored credentials ────────────────────────────────────

loop_db_login() {
    if [[ ! -s "$DB_FILE" ]]; then
        printf '[-] Credential store is empty: %s\n' "$DB_FILE"
        printf '    Run: %s <username> [password]\n' "$(basename "$0")"
        exit 1
    fi

    printf '[*] Cycling through stored credentials...\n'

    while read -r line; do
        [[ -z "$line" ]] && continue
        local username="${line%%:*}"
        local password="${line#*:}"
        printf '[*] Trying "%s"...\n' "$username"
        if attempt_login "$username" "$password"; then
            exit 0
        fi
    done < "$DB_FILE"

    printf '[-] All stored credentials exhausted — no successful login\n'
    exit 1
}

# ── Usage ─────────────────────────────────────────────────────────────────────

usage() {
    cat <<EOF
Usage: $(basename "$0") [username [password]]

  (no args)            Cycle through all stored credentials until one works
  <arg>                Use <arg> as both the username and password
  <username> <pass>    Explicit username and password

Credentials are stored in: ${DB_FILE}
EOF
    exit 1
}

# ── Entry point ───────────────────────────────────────────────────────────────

# Check if the first argument is a help flag before validating the number of arguments
[[ $# -gt 0 ]] && [[ "$1" == "-h" || "$1" == "--help" ]] && usage

case "$#" in
    0) loop_db_login ;;
    1) attempt_login "$1" "$1" ;;
    2) attempt_login "$1" "$2" ;;
    *) usage ;;
esac
