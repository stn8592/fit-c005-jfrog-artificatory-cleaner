# Define Paths
$repoListPath = "C:\Users\2755916\JFROG-CLEANUP\repositories.json" # Path to the JSON file containing repository details
$outputJsonPath = "C:\Users\2755916\JFROG-CLEANUP\artifacts_to_delete.json" # Temporary output file for AQL results
$queryFilePath = "C:\Users\2755916\JFROG-CLEANUP\temp_aql_query.aql" # Temporary file to store AQL query

# Load Repository List from JSON
$repositories = Get-Content -Path $repoListPath | ConvertFrom-Json

# Filter for LOCAL repositories only
$localRepos = $repositories | Where-Object { $_.type -eq "LOCAL" }

# Iterate Over Each Local Repository
foreach ($repo in $localRepos) {
    Write-Host "Processing repository: $($repo.key)"

    # Define the AQL Query as Plain JSON in a File
    $aqlQuery = @"
{
  "repo": "$($repo.key)",
  "type": "file",
  "created": { "$before": "1mo" },
  "stat.downloads": { "$eq": 0 }
}.include("repo", "path", "name", "created")
"@

    # Write AQL query to temporary file in ASCII encoding to avoid BOM issues
    $aqlQuery | Set-Content -Path $queryFilePath -Encoding ASCII

    # Execute AQL Query by Using the File Directly in JFrog CLI
    Write-Host "Executing AQL query for repository $($repo.key)..."
    & jfrog rt curl -XPOST /api/search/aql -H "Content-Type: text/plain" -T $queryFilePath -o $outputJsonPath

    # Verify JSON Output
    if ((Get-Content -Path $outputJsonPath | Out-String).Trim() -eq "") {
        Write-Host "Error: The output JSON file is empty for repository $($repo.key). The AQL query might have failed or returned no results."
        continue
    }

    # Load JSON Output
    try {
        $jsonOutput = Get-Content -Path $outputJsonPath | ConvertFrom-Json
    } catch {
        Write-Host "Error: Failed to parse JSON for repository $($repo.key). Content of output file:"
        Get-Content -Path $outputJsonPath
        continue
    }

    # Check if results array is empty
    if (!$jsonOutput.results -or $jsonOutput.results.Count -eq 0) {
        Write-Host "No artifacts found matching the criteria for repository $($repo.key)."
        continue
    }

    # Iterate Over Results and Delete Artifacts
    $jsonOutput.results | ForEach-Object {
        # Check if all required fields are present
        if ($_.repo -and $_.path -and $_.name) {
            $artifactPath = "$($_.repo)/$($_.path)/$($_.name)"
            Write-Host "Deleting artifact: $artifactPath"
            
            # Delete Artifact
            $deleteOutput = & jfrog rt del $artifactPath --quiet
            if ($LASTEXITCODE -eq 0) {
                Write-Host "Successfully deleted: $artifactPath"
            } else {
                Write-Host "Failed to delete: $artifactPath"
            }
        } else {
            Write-Host "Error: Missing required fields in JSON response for item in repository $($repo.key). Skipping."
        }
    }
}

# Cleanup Temporary Files
Remove-Item -Path $outputJsonPath -Force
Remove-Item -Path $queryFilePath -Force

Write-Host "Cleanup script completed."
