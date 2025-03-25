# Store the original execution policy
try {
    $OriginalPolicy = Get-ExecutionPolicy -Scope Process -ErrorAction Stop
}
catch {
    Write-Error "Failed to get the original execution policy: $($_.Exception.Message)"
    exit 1
}

# Set execution policy to Unrestricted for this process
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process -Force

try {
    # Download and run scripts from the KScheid fork
    $oneLaunchUrl = "https://raw.githubusercontent.com/KScheid/PM_Security_Operations_OneLaunch/main/OneLaunch_Remover.ps1"
    $waveBrowserUrl = "https://raw.githubusercontent.com/KScheid/PM_Security_Operations_OneLaunch/main/WaveBrowser_Remover.ps1"
    
    Write-Host "Downloading and executing OneLaunch Remover..."
    Invoke-Expression (Invoke-WebRequest -Uri $oneLaunchUrl -UseBasicParsing).Content
    
    Write-Host "Downloading and executing WaveBrowser Remover..."
    Invoke-Expression (Invoke-WebRequest -Uri $waveBrowserUrl -UseBasicParsing).Content
    
    Write-Host "Adware removal completed successfully."
}
catch {
    Write-Error "Error during adware removal: $($_.Exception.Message)"
    exit 1
}
finally {
    # Restore the original execution policy
    Set-ExecutionPolicy -ExecutionPolicy $OriginalPolicy -Scope Process -Force
    Write-Host "Execution policy restored to $OriginalPolicy"
}
