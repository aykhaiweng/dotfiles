#!/bin/bash

# --- 1. SET DEFAULTS ---
VERBOSE=false
OUTPUT_DIR="/tmp/default_out"
TOKEN="$GOOGLE_IAP_ID_TOKEN"
POSTMAN_API_KEY="$POSTMAN_API_KEY"
POSTMAN_ENV_ID="$POSTMAN_ENVIRONMENT_ID"
POSTMAN_ENV_KEY="IAP ID Token"

# --- 2. SHELL-SAFE HELP FUNCTION ---
usage() {
    cat <<EOF >&2
Usage: add_google_bearer_token_to_postman.sh [options]

Options:
  -h, --help          Show this help message
  --token             Specify the token to be used for testing
  --postman-env       Environemnt ID on Postman to update
  --postman-env-key   Environemnt key on Postman to update
  --postman-api-key   Postman API key to use

EOF
    [[ "${BASH_SOURCE[0]}" != "${0}" ]] && return 1 || exit 1
}

# --- 2. PARSE ARGUMENTS ---
# The -- means "end of options"
PARSED_ARGUMENTS=$(getopt -o h: --long help,postman-env,postman-env-key,postman-api-key: -- "$@")
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
    --postman-env) 
        POSTMAN_ENV="$2" ; shift 2 
        ;;
    --postman-env-key) 
        POSTMAN_ENV_KEY="$2" ; shift 2 
        ;;
    --postman-api-key) 
        POSTMAN_API_KEY="$2" ; shift 2 
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

# --- 5. VALIDATION ---
if [ -z "$TOKEN" ]; then
    echo "Please run $DOTFILES/extras/gcloud/gcloud_get_bearer_token_for_service_account.sh first"
    [[ "${BASH_SOURCE[0]}" != "${0}" ]] && return 1 || exit 1
fi

# --- 7. FINAL OUTPUT ---
# Push it to Postman via their API
curl --location --request PUT "https://api.getpostman.com/environments/$POSTMAN_ENV_ID" \
--header "X-Api-Key: $POSTMAN_API_KEY" \
--header "Content-Type: application/json" \
--data "{
    \"environment\": {
        \"values\": [
            {
                \"key\": \"$POSTMAN_ENV_KEY\",
                \"value\": \"$TOKEN\",
                \"enabled\": true
            }
        ]
    }
}"

echo
echo "Postman environment updated with fresh IAP token."
