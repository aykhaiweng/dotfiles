#!/bin/bash

# --- 1. SET DEFAULTS ---
OUTPUT_DIR="/tmp/default_out"
FILE_PATH=""
IAP_CLIENT_ID=$GOOGLE_IAP_CLIENT_ID

usage() {
    cat <<EOF >&2
Usage: get_sa_token.sh <path_to_sa_key_json> [options]

Options:
  -h, --help        Show this help message
  --iap-client-id   Specify the IAP Client ID to set as audience
EOF
    [[ "${BASH_SOURCE[0]}" != "${0}" ]] && return 1 || exit 1
}

# --- 2. PARSE ARGUMENTS ---
# The -- means "end of options"
PARSED_ARGUMENTS=$(getopt -o h: --long help,iap-client-id: -- "$@")
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
    --iap-client-id)
        IAP_CLIENT_ID="${2:-$GOOGLE_IAP_CLIENT_ID}"
        shift 2
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
FILE_PATH="${1:-$CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE}"

# --- 5. VALIDATION ---
if [ -z "$FILE_PATH" ]; then
    echo "Error: Missing file path argument." >&2
    usage
fi

if [ ! -f "$FILE_PATH" ]; then
    echo "Error: File '$FILE_PATH' does not exist." >&2
    [[ "${BASH_SOURCE[0]}" != "${0}" ]] && return 1 || exit 1
fi

# --- 6. EXECUTION ---
# Generate the token using the key file as an override
echo "Generating token using $FILE_PATH for $IAP_CLIENT_ID" >&2
export GOOGLE_IAP_ID_TOKEN=$(CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=$FILE_PATH \
    gcloud auth print-identity-token --audiences="$IAP_CLIENT_ID")

# --- 7. FINAL OUTPUT ---
echo $GOOGLE_IAP_ID_TOKEN
