#!/bin/bash

# Config
REPO="Techplain-Ltd/kareco-iac"
DEV_ENV="dev"
PROD_ENV="prod"
ACCEPT_HEADER="application/vnd.github+json"

# Fetch all variables from DEV
echo "Fetching environment variables from $DEV_ENV..."
gh api repos/$REPO/environments/$DEV_ENV/variables --jq '.variables' \
  -H "Accept: $ACCEPT_HEADER" |
  jq -c '.[]' |
  while read -r var; do
    var_name=$(echo "$var" | jq -r '.name')
    var_value=$(echo "$var" | jq -r '.value')

    echo "Copying variable: $var_name"

    gh api --method PUT repos/$REPO/environments/$PROD_ENV/variables/$var_name \
      -H "Accept: $ACCEPT_HEADER" \
      -f name="$var_name" \
      -f value="$var_value"
done

echo "✅ Done copying variables to PROD."