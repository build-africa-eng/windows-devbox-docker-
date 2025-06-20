# This script installs Visual Studio Build Tools and performs robust error checking.

Write-Host "Starting Visual Studio Build Tools installation..."
$ErrorActionPreference = "Stop" # Make the script exit on any error

try {
    # Execute the installer and wait for it to complete
    $process = Start-Process -FilePath "C:\vs_BuildTools.exe" -ArgumentList @(
        '--quiet',
        '--wait',
        '--norestart',
        '--nocache',
        '--installPath', 'C:\BuildTools',
        '--add', 'Microsoft.VisualStudio.Workload.VCTools',
        '--add', 'Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools',
        '--add', 'Microsoft.VisualStudio.Workload.NetCoreBuildTools',
        '--includeRecommended'
    ) -Wait -PassThru

    # Check the exit code from the installer
    if ($process.ExitCode -ne 0) {
        # Create a specific error message and throw an exception, which will be caught by the 'catch' block
        throw "Visual Studio installer failed with exit code $($process.ExitCode)"
    }

    Write-Host "Visual Studio Build Tools installed successfully."

} catch {
    # This block runs if Start-Process fails or if the 'throw' above is executed
    Write-Host "##[error]An error occurred during Visual Studio Build Tools installation."
    
    # Attempt to find and display the official installer logs for debugging
    $logPath = "$env:TEMP\dd_setup*.log"
    $logs = Get-Item -Path $logPath -ErrorAction SilentlyContinue

    if ($logs) {
        Write-Host "Installer logs found at $($logs.FullName):"
        Get-Content -Path $logs.FullName | Write-Host
    } else {
        Write-Host "##[warning]Could not find Visual Studio installer logs at '$logPath'."
    }

    # Exit with a non-zero code to fail the Docker build
    exit 1
} finally {
    # This block runs regardless of success or failure, ensuring cleanup happens
    Write-Host "Cleaning up installer and cache files..."
    Remove-Item "C:\vs_BuildTools.exe" -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Program Files (x86)\Microsoft Visual Studio\Installer" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\ProgramData\Microsoft\VisualStudio" -Recurse -Force -ErrorAction SilentlyContinue
}