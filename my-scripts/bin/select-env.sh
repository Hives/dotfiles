#!/usr/bin/env bash

# 1. Define the menu options for Rofi and prompt the user first
OPTIONS="web-plp-scaffold (flex)
web-plp-scaffold (prod)
web-pdp-scaffold (flex)
web-pdp-scaffold (prod)"

CHOICE=$(echo "$OPTIONS" | $HOME/bin/menu.sh)

# Parse the choice and set variables
case "$CHOICE" in
    "web-plp-scaffold (flex)")
        SERVICE="web-plp-scaffold"
        CLUSTER="flex"
        ;;
    "web-plp-scaffold (prod)")
        SERVICE="web-plp-scaffold"
        CLUSTER="prod"
        ;;
    "web-pdp-scaffold (flex)")
        SERVICE="web-pdp-scaffold"
        CLUSTER="flex"
        ;;
    "web-pdp-scaffold (prod)")
        SERVICE="web-pdp-scaffold"
        CLUSTER="prod"
        ;;
    *)
        echo "No valid selection made. Exiting."
        exit 0
        ;;
esac

PROJECT_ID="jl-${SERVICE}-${CLUSTER}"

# 2. Check if the user is TRULY logged into gcloud with valid tokens
echo "Checking Google Cloud authentication status..."

if ! gcloud auth print-access-token &>/dev/null; then
    echo "No valid active login session found. Launching login..."
    gcloud auth login
    
    # Re-check after the login attempt to ensure it succeeded
    if ! gcloud auth print-access-token &>/dev/null; then
        echo "Authentication failed or was cancelled. Exiting."
        exit 1
    fi
fi

echo "Authentication valid! Proceeding with configuration..."

# 3. Execute the configuration commands
echo "Switching to Service: $SERVICE | Cluster: $CLUSTER"

# Fixes the ADC quota project warning by aligning it with your target project
gcloud config set billing/quota_project "$PROJECT_ID"
gcloud config set project "$PROJECT_ID"

kubectx "$CLUSTER"
kubens "$SERVICE"

echo "Successfully connected to $PROJECT_ID!"
