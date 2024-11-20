#!/bin/bash

# Path to the cleaned JSON file containing repository details
repoListPath="C:/Users/2755916/JFROG-CLEANUP/repositories_clean.json"

# Set the AQL criteria
TIME_CRITERIA="3mo"    # Specify the time criteria, e.g., "3mo" for artifacts older than 3 months
DOWNLOADS_CRITERIA=0   # Specify the download count criteria

# Debug: Show JSON content for verification
echo "Contents of $repoListPath:"
cat "$repoListPath"

# Load only "LOCAL" repositories from the JSON file
repos=$(jq -r '.[] | select(.type == "LOCAL") | .key' "$repoListPath")

# Debug: Show extracted repositories
echo "Repositories to process:"
echo "$repos"

# Check if repos list is empty
if [ -z "$repos" ]; then
    echo "No LOCAL repositories found in the JSON file."
    exit 1
fi

# Iterate over each "LOCAL" repository in repositories_clean.json
for REPO in $repos; do
    echo "Processing repository: $REPO"

    # Define the AQL query for the current repository
    AQL="items.find({
        \"repo\": \"$REPO\",
        \"created\": {\"\$before\": \"$TIME_CRITERIA\"},
        \"stat.downloads\": {\"\$eq\": $DOWNLOADS_CRITERIA}
    }).include(\"repo\", \"path\", \"name\")"

    # Debug: Show AQL query
    echo "AQL Query for $REPO:"
    echo "$AQL"

    # Save the AQL to a temporary file
    echo "$AQL" > cleanup.aql

    # Execute the AQL query and save output
    jfrog rt curl -XPOST /api/search/aql -T cleanup.aql > artifacts_to_delete.json

    # Debug: Show AQL query results
    echo "AQL Query Output for $REPO:"
    cat artifacts_to_delete.json

    # Check if the output JSON contains results
    if [ ! -s artifacts_to_delete.json ] || ! jq -e '.results' artifacts_to_delete.json > /dev/null; then
        echo "No artifacts found matching the criteria in repository: $REPO."
        continue
    fi

    # Parse the output JSON and delete artifacts
    jq -r '.results[] | .repo + "/" + .path + "/" + .name' artifacts_to_delete.json | while read artifact_path; do
        echo "Deleting artifact: $artifact_path"
        jfrog rt del "$artifact_path"
    done

    # Clean up temporary files
    rm cleanup.aql artifacts_to_delete.json

done

echo "Cleanup process completed for all repositories."
