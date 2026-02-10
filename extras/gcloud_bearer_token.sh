#!/bin/bash

# Get the Client ID: Go to the Security > Identity-Aware Proxy page in the Google Cloud Console. 
# Click the three dots next to your backend service and select Edit OAuth Client. Copy the Client ID.

export IAP_CLIENT_ID="your-client-id.apps.googleusercontent.com"
export TOKEN=$(gcloud auth print-identity-token --audiences=$IAP_CLIENT_ID)
echo $TOKEN

