# # # # # # # #!/bin/bash

# # # # # # # jfrog rt-cleanup clean common-maven-shared-libraries-local --time-unit=month --no-dl=1

# # # # # # #!/bin/bash


# # # # # # # Artifactory details
# # # # # # USERNAME="ram.pasula@teliacompany.com"
# # # # # # PASSWORD="cmVmdGtuOjAxOjE3NjMxMDAwNDE6aVgxb3MyU2lHaUhnYllHYXV2ekxXZE5IbXdX"
# # # # # # ARTIFACTORY_URL="https://jfrog.teliacompany.io/artifactory";

# # # # # # # Convert 1GB to bytes
# # # # # # THRESHOLD_SIZE=$((1 * 1024 * 1024 * 1024))

# # # # # # # Fetch repository details using Artifactory API
# # # # # # repo_list=$(curl -u $USERNAME:$PASSWORD "$ARTIFACTORY_URL/api/storageinfo" | jq -r '.repositories[] | select(.repositoryType == "LOCAL") | .repoKey')

# # # # # # # Loop through the list of repositories
# # # # # # for repo in $repo_list; do
# # # # # #     # Get repository size
# # # # # #     repo_size=$(curl -u $USERNAME:$PASSWORD "$ARTIFACTORY_URL/api/storage/$repo" | jq '.children[]? | .size' | paste -sd+ - | bc)

# # # # # #     # Check if repository size is greater than 1GB
# # # # # #     if [ "$repo_size" -gt "$THRESHOLD_SIZE" ]; then
# # # # # #         echo "Cleaning up repository: $repo"
# # # # # #         # Execute cleanup command
# # # # # #         jfrog rt-cleanup clean $repo --time-unit=month --no-dl=1
# # # # # #     fi
# # # # # # done


# # # # # #!/bin/bash

# # # # # # Artifactory details
# # # # # USERNAME="ram.pasula@teliacompany.com"
# # # # # PASSWORD="cmVmdGtuOjAxOjE3NjMxMDAwNDE6aVgxb3MyU2lHaUhnYllHYXV2ekxXZE5IbXdX"
# # # # # ARTIFACTORY_URL="https://jfrog.teliacompany.io/artifactory";


# # # # # # Fetch repository details using Artifactory API
# # # # # repo_list=$(curl -s -u $USERNAME:$PASSWORD "$ARTIFACTORY_URL/api/repositories" | jq -r '.[] | select(.type == "LOCAL") | .key')

# # # # # # Loop through the list of repositories
# # # # # for repo in $repo_list; do
# # # # #     # Get repository size (use the appropriate API if needed)
# # # # #     repo_size=$(curl -s -u $USERNAME:$PASSWORD "$ARTIFACTORY_URL/api/storage/$repo" | jq '.repositorySize')

# # # # #     # Threshold size in bytes for 1GB
# # # # #     THRESHOLD_SIZE=$((1 * 1024 * 1024 * 1024))

# # # # #     # Check if repository size is greater than 1GB
# # # # #     if [ "$repo_size" -gt "$THRESHOLD_SIZE" ]; then
# # # # #         echo "Cleaning up repository: $repo"
# # # # #         # Execute cleanup command
# # # # #         jfrog rt-cleanup clean $repo --time-unit=month --no-dl=1
# # # # #     fi
# # # # # done


# # # # #!/bin/bash

# # # # # Artifactory details
# # # # USERNAME="ram.pasula@teliacompany.com"
# # # # PASSWORD="cmVmdGtuOjAxOjE3NjMxMDAwNDE6aVgxb3MyU2lHaUhnYllHYXV2ekxXZE5IbXdX"
# # # # ARTIFACTORY_URL="https://jfrog.teliacompany.io/artifactory";

# # # # # Fetch repository details using Artifactory API
# # # # repo_list=$(curl -s -u $USERNAME:$PASSWORD "$ARTIFACTORY_URL/api/repositories" | jq -r '.[] | select(.type == "LOCAL") | .key')

# # # # # Loop through the list of repositories
# # # # for repo in $repo_list; do
# # # #     # Get repository size (use the appropriate API if needed)
# # # #     repo_size_json=$(curl -s -u $USERNAME:$PASSWORD "$ARTIFACTORY_URL/api/storage/$repo")
# # # #     repo_size=$(echo $repo_size_json | jq '.repositorySize')

# # # #     echo "Repository: $repo Size: $repo_size"

# # # #     # Check if repo_size is numeric
# # # #     if ! [[ "$repo_size" =~ ^[0-9]+$ ]]; then
# # # #         echo "Error: Repository size for $repo is not a valid integer."
# # # #         continue
# # # #     fi

# # # #     # Threshold size in bytes for 1GB
# # # #     THRESHOLD_SIZE=$((1 * 1024 * 1024 * 1024))

# # # #     # Check if repository size is greater than 1GB
# # # #     if [ "$repo_size" -gt "$THRESHOLD_SIZE" ]; then
# # # #         echo "Cleaning up repository: $repo"
# # # #         # Execute cleanup command
# # # #         jfrog rt-cleanup clean $repo --time-unit=month --no-dl=1
# # # #     fi
# # # # done


# # # #!/bin/bash

# # # # Artifactory details
# # # USERNAME="ram.pasula@teliacompany.com"
# # # PASSWORD="cmVmdGtuOjAxOjE3NjMxMDAwNDE6aVgxb3MyU2lHaUhnYllHYXV2ekxXZE5IbXdX"
# # # ARTIFACTORY_URL="https://jfrog.teliacompany.io/artifactory";

# # # # Fetch repository details using Artifactory API
# # # repo_list=$(curl -s -u $USERNAME:$PASSWORD "$ARTIFACTORY_URL/api/repositories" | jq -r '.[] | select(.type == "LOCAL") | .key')

# # # # Loop through the list of repositories
# # # for repo in $repo_list; do
# # #     # Get repository size (use the appropriate API if needed)
# # #     repo_size_json=$(curl -s -u $USERNAME:$PASSWORD "$ARTIFACTORY_URL/api/storage/$repo")
# # #     repo_size=$(echo $repo_size_json | jq '.children | map(.size | tonumber) | add')

# # #     # Check if repo_size is numeric
# # #     if [[ -z "$repo_size" ]] || ! [[ "$repo_size" =~ ^[0-9]+$ ]]; then
# # #         echo "Repository: $repo Size: $repo_size is not a valid integer."
# # #         continue
# # #     fi

# # #     echo "Repository: $repo Size: $repo_size"

# # #     # Threshold size in bytes for 1GB
# # #     THRESHOLD_SIZE=$((1 * 1024 * 1024 * 1024))

# # #     # Check if repository size is greater than 1GB
# # #     if [ "$repo_size" -gt "$THRESHOLD_SIZE" ]; then
# # #         echo "Cleaning up repository: $repo"
# # #         # Execute cleanup command
# # #         jfrog rt-cleanup clean $repo --time-unit=month --no-dl=1
# # #     fi
# # # done


# # #!/bin/bash

# # # Artifactory details

# # USERNAME="ram.pasula@teliacompany.com"
# # PASSWORD="cmVmdGtuOjAxOjE3NjMxMDAwNDE6aVgxb3MyU2lHaUhnYllHYXV2ekxXZE5IbXdX"
# # ARTIFACTORY_URL="https://jfrog.teliacompany.io/artifactory";

# # # Fetch repository details using Artifactory API
# # repo_list=$(curl -s -u $USERNAME:$PASSWORD "$ARTIFACTORY_URL/api/repositories" | jq -r '.[] | select(.type == "LOCAL") | .key')

# # # Loop through the list of repositories
# # for repo in $repo_list; do
# #     # Get repository size (use the appropriate API if needed)
# #     repo_size_json=$(curl -s -u $USERNAME:$PASSWORD "$ARTIFACTORY_URL/api/storage/$repo")
# #     # Adjust the jq command according to your JSON structure
# #     repo_size=$(echo $repo_size_json | jq 'YOUR_JQ_COMMAND_HERE')

# #     # Output for debugging
# #     echo "Repository: $repo, Size: $repo_size"

# #     # Validation of Size
# #     if ! [[ "$repo_size" =~ ^[0-9]+$ ]]; then
# #         echo "Invalid size for repository: $repo"
# #         continue
# #     fi

# #     # Threshold size in bytes for 1GB
# #     THRESHOLD_SIZE=$((1 * 1024 * 1024 * 1024))

# #     # Check if repository size is greater than 1GB
# #     if [ "$repo_size" -gt "$THRESHOLD_SIZE" ]; then
# #         echo "Cleaning up repository: $repo"
# #         # Execute cleanup command
# #         jfrog rt-cleanup clean $repo --time-unit=month --no-dl=1
# #     fi
# # done


# #!/bin/bash

# # Artifactory details
# USERNAME="ram.pasula@teliacompany.com"
# PASSWORD="cmVmdGtuOjAxOjE3NjMxMDAwNDE6aVgxb3MyU2lHaUhnYllHYXV2ekxXZE5IbXdX"
# ARTIFACTORY_URL="https://jfrog.teliacompany.io/artifactory";

# # Fetch repository details using Artifactory API
# repo_list=$(curl -s -u $USERNAME:$PASSWORD "$ARTIFACTORY_URL/api/repositories" | jq -r '.[] | select(.type == "LOCAL") | .key')

# # Loop through the list of repositories
# for repo in $repo_list; do
#     # Get repository size (use the appropriate API if needed)
#     repo_size_json=$(curl -s -u $USERNAME:$PASSWORD "$ARTIFACTORY_URL/api/storage/$repo")
#     # Extract the correct size from JSON using jq
#     repo_size=$(echo $repo_size_json | jq '.YOUR_CORRECT_JQ_PATH')

#     # Output for debugging
#     echo "Repository: $repo, Size: $repo_size"

#     # Validation of Size
#     if ! [[ "$repo_size" =~ ^[0-9]+$ ]]; then
#         echo "Invalid size for repository: $repo"
#         continue
#     fi

#     # Threshold size in bytes for 1GB
#     THRESHOLD_SIZE=$((1 * 1024 * 1024 * 1024))

#     # Check if repository size is greater than 1GB
#     if [ "$repo_size" -gt "$THRESHOLD_SIZE" ]; then
#         echo "Cleaning up repository: $repo"
#         # Execute cleanup command
#         jfrog rt-cleanup clean $repo --time-unit=month --no-dl=1
#     fi
# done
#!/bin/bash

# Artifactory details
USERNAME="ram.pasula@teliacompany.com"
PASSWORD="cmVmdGtuOjAxOjE3NjMxMDAwNDE6aVgxb3MyU2lHaUhnYllHYXV2ekxXZE5IbXdX"
ARTIFACTORY_URL="https://jfrog.teliacompany.io/artifactory";
# Fetch repository details using Artifactory API
repo_list=$(curl -s -u $USERNAME:$PASSWORD "$ARTIFACTORY_URL/api/repositories" | jq -r '.[] | select(.type == "LOCAL") | .key')

# Loop through the list of repositories
for repo in $repo_list; do
    # Get repository details including size
    repo_details=$(curl -s -u $USERNAME:$PASSWORD "$ARTIFACTORY_URL/api/storage/$repo")
    repo_size=$(echo $repo_details | jq -r '.storageSize | numbers')

    # Output for debugging
    echo "Repository: $repo, Size: $repo_size"

    # Validation of Size
    if [[ -z "$repo_size" ]] || ! [[ "$repo_size" =~ ^[0-9]+$ ]]; then
        echo "Invalid size for repository: $repo"
        continue
    fi

    # Threshold size in bytes for 1GB
    THRESHOLD_SIZE=$((1 * 1024 * 1024 * 1024))

    # Check if repository size is greater than 1GB
    if [ "$repo_size" -gt "$THRESHOLD_SIZE" ]; then
        echo "Cleaning up repository: $repo"
        # Execute cleanup command
        jfrog rt-cleanup clean $repo --time-unit=month --no-dl=1
    fi
done


