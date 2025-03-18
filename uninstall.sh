#!/bin/bash

# Remove az related files
echo "Removing az related files..."
find / -name 'az' -exec sudo rm -rf {} 2>/dev/null
echo "az files removed."

# Remove gcloud related files
echo "Removing gcloud related files..."
find / -name 'gcloud' -exec sudo rm -rf {} 2>/dev/null
echo "gcloud files removed."

echo "Cleanup complete."
