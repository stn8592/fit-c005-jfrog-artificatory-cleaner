#!/bin/bash

# Set Artifactory details
USERNAME="ram.pasula@teliacompany.com"
PASSWORD="cmVmdGtuOjAxOjE3NjMxMDAwNDE6aVgxb3MyU2lHaUhnYllHYXV2ekxXZE5IbXdX"
ARTIFACTORY_URL="https://jfrog.teliacompany.io/artifactory";

# Fetch all local repository keys using the JFrog CLI or API
repo_list=$(curl -s -u $USERNAME:$PASSWORD "$ARTIFACTORY_URL/api/repositories?type=local" | jq -r '.[] | .key')

echo "Starting cleanup process..."

# Loop through each repository key
for repo in $repo_list; do
    echo "Cleaning up repository: $repo"
    # Assuming 'jfrog rt-cleanup' is a placeholder for your actual cleanup command:
    # Replace 'jfrog rt-cleanup' with your actual JFrog CLI cleanup command or script logic
    jfrog rt repo-clean $repo --quiet
done

echo "Cleanup process completed."