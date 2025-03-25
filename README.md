# OneLaunchNuked_Forked
This is a fork. No changes to the code. This combines remove OneLaunch and Wave Browser into one script file. 
# PowerShell Adware Removal Script (OneLaunch & WaveBrowser)

This repository contains a PowerShell script designed to automate the removal of specific adware programs: OneLaunch and WaveBrowser. It achieves this by downloading and executing specialized removal scripts from a trusted source.

**Disclaimer:** This script modifies the system's execution policy temporarily and executes code downloaded from the internet. Ensure you understand the risks and trust the source repository before running it. Use at your own risk.

## Table of Contents

1.  [Overview](#overview)
2.  [Prerequisites](#prerequisites)
3.  [How it Works](#how-it-works)
4.  [Usage](#usage)
    * [A. Saving the Script](#a-saving-the-script)
    * [B. Running the Script](#b-running-the-script)
5.  [Security Considerations](#security-considerations)
6.  [Error Handling](#error-handling)
7.  [Script Code](#script-code)

---

## Overview

This script simplifies the removal of the OneLaunch and WaveBrowser adware by:

1.  Temporarily adjusting the PowerShell execution policy for the current process to allow script execution.
2.  Downloading the latest removal scripts for OneLaunch and WaveBrowser directly from the `KScheid/PM_Security_Operations_OneLaunch` GitHub repository.
3.  Executing the downloaded removal scripts.
4.  Restoring the original PowerShell execution policy for the current process.

---

## Prerequisites

* **Windows Operating System:** Requires a Windows environment with PowerShell installed.
* **PowerShell Access:** You need to be able to run PowerShell scripts.
* **Administrator Privileges:** Running PowerShell as an Administrator is highly recommended, as removing software often requires elevated permissions. The script attempts to change the execution policy for the *current process*, but removal actions within the downloaded scripts might still fail without admin rights.
* **Internet Connection:** Required to download the removal scripts from GitHub.

---

## How it Works

1.  **Store Original Policy:** The script first queries and stores the current PowerShell execution policy for the running process.
2.  **Set Unrestricted Policy:** It then temporarily sets the execution policy for the *current process* to `Unrestricted`. This allows the downloaded scripts to run without being blocked by policy restrictions. This change only affects the current PowerShell session running the script.
3.  **Download & Execute Removers:**
    * It downloads the content of `OneLaunch_Remover.ps1` from the specified GitHub URL.
    * It executes the downloaded script content immediately using `Invoke-Expression`.
    * It repeats the download and execution process for `WaveBrowser_Remover.ps1`.
4.  **Restore Original Policy:** Regardless of whether the removal scripts succeeded or failed (using a `finally` block), the script attempts to restore the PowerShell execution policy for the current process back to its original state.

---

## Usage

### A. Saving the Script

1.  Copy the entire script code from Section VII below.
2.  Paste the code into a plain text editor (like Notepad).
3.  Save the file with a `.ps1` extension (e.g., `RemoveAdware.ps1`).

### B. Running the Script

1.  **Open PowerShell as Administrator:**
    * Search for "PowerShell" in the Windows Start menu.
    * Right-click on "Windows PowerShell" or "PowerShell 7" and select "Run as administrator".
2.  **Navigate to Script Location:** Use the `cd` command to change the directory to where you saved the `RemoveAdware.ps1` file. For example:
    ```powershell
    cd C:\Users\YourUsername\Downloads
    ```
3.  **Execute the Script:** Run the script by typing its path and name:
    ```powershell
    .\RemoveAdware.ps1
    ```
4.  **Monitor Output:** Observe the output in the PowerShell window. It will indicate download progress and completion status. Check for any error messages.

---

## Security Considerations

* **Executing Remote Code:** This script uses `Invoke-WebRequest` and `Invoke-Expression` to download and run code directly from the internet. This is inherently risky. **Only run this script if you trust the source repository** (`https://github.com/KScheid/PM_Security_Operations_OneLaunch`). Ensure the URLs point to the intended, trusted source. Malicious actors could potentially compromise the source or trick users into running scripts from unsafe locations.
* **Execution Policy:** The script temporarily lowers the execution policy to `Unrestricted` *for the current process only*. This is necessary to run the downloaded scripts but reduces security for the duration of the script's execution. The `finally` block aims to restore the original policy, but errors could potentially prevent this (though unlikely).
* **Administrator Privileges:** Running as administrator grants the script (and the scripts it downloads) broad permissions to modify the system.

---

## Error Handling

* The script uses `try...catch...finally` blocks for basic error handling.
* It attempts to catch errors during the initial policy check and during the download/execution phase, writing error messages to the console.
* The `finally` block ensures that the attempt to restore the original execution policy runs even if errors occur within the `try` block.
* If errors occur, review the messages printed to the PowerShell console for details.

---

## Script Code

```powershell
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
    $oneLaunchUrl = "[https://raw.githubusercontent.com/KScheid/PM_Security_Operations_OneLaunch/main/OneLaunch_Remover.ps1](https://raw.githubusercontent.com/KScheid/PM_Security_Operations_OneLaunch/main/OneLaunch_Remover.ps1)"
    $waveBrowserUrl = "[https://raw.githubusercontent.com/KScheid/PM_Security_Operations_OneLaunch/main/WaveBrowser_Remover.ps1](https://raw.githubusercontent.com/KScheid/PM_Security_Operations_OneLaunch/main/WaveBrowser_Remover.ps1)"

    Write-Host "Downloading and executing OneLaunch Remover..."
    Invoke-Expression (Invoke-WebRequest -Uri $oneLaunchUrl -UseBasicParsing).Content

    Write-Host "Downloading and executing WaveBrowser Remover..."
    Invoke-Expression (Invoke-WebRequest -Uri $waveBrowserUrl -UseBasicParsing).Content

    Write-Host "Adware removal completed successfully."
}
catch {
    Write-Error "Error during adware removal: $($_.Exception.Message)"
    # Consider if exiting here is always desired, or if policy restoration should still happen.
    # The finally block *will* still execute even with exit 1 here.
    exit 1
}
finally {
    # Restore the original execution policy
    # Ensure $OriginalPolicy has a value before attempting to set
    if ($null -ne $OriginalPolicy) {
        Set-ExecutionPolicy -ExecutionPolicy $OriginalPolicy -Scope Process -Force
        Write-Host "Execution policy restored to $OriginalPolicy"
    } else {
        Write-Warning "Original execution policy was not captured; policy may not be restored."
    }
}
