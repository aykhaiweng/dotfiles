#!/bin/bash

# --- 1. SET DEFAULTS ---
VERBOSE=false
OUTPUT_DIR="/tmp/default_out"
URL_PATH=""
TOKEN="$GOOGLE_IAP_ID_TOKEN"

# --- 2. SHELL-SAFE HELP FUNCTION ---
usage() {
    cat <<EOF >&2
Usage: test_google_iap.sh <url_path> [options]

Options:
  -h, --help        Show this help message
  --token           Specify the token to be used for testing

EOF
    [[ "${BASH_SOURCE[0]}" != "${0}" ]] && return 1 || exit 1
}

# --- 2. PARSE ARGUMENTS ---
# The -- means "end of options"
PARSED_ARGUMENTS=$(getopt -o h: --long help: -- "$@")
if [ $? -ne 0 ]; then
    usage
    [[ "${BASH_SOURCE[0]}" != "${0}" ]] && return 1 || exit 1
fi

eval set -- "$PARSED_ARGUMENTS"

# --- 3. HANDLE FLAGS ---
while :; do
    case "$1" in
    -h | --help)
        usage
        # If usage returns (sourced mode), we must stop the loop/script here
        [[ "${BASH_SOURCE[0]}" != "${0}" ]] && return 1 || exit 1
        ;;

    --token) 
        TOKEN="$2" ; shift 2 
        ;;
    --)
        shift
        break
        ;;
    *)
        echo "Error" >&2
        exit 1
        ;;
    esac
done

# --- 4. HANDLE POSITIONAL ARGUMENTS ---
# After 'shift' in the loop, $1 is now the first non-option argument
URL_PATH="$1"

# --- 5. VALIDATION ---
if [ -z "$TOKEN" ]; then
    echo "Please run $DOTFILES/extras/gcloud/gcloud_get_bearer_token_for_service_account.sh first"
    return 1
fi

# --- 7. FINAL OUTPUT ---
# Execute GET request
curl -i -X GET "$URL_PATH" \
    -H "Authorization: Bearer $GOOGLE_IAP_ID_TOKEN"
