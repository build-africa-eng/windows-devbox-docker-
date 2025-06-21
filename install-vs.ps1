# install-vs.ps1
# This script installs Visual Studio 2022 Build Tools with specified workloads.

$installerPath = "C:\temp\vs_BuildTools.exe"
$installPath = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools"
$logPath = "C:\temp\vs_install.log"
$errorLogPath = "C:\temp\vs_error.log"

# Check if the installer exists
if (-not (Test-Path $installerPath)) {
    Write-Error "Visual Studio installer not found at $installerPath"
    exit 1
}

# Define the workloads required for C++, .NET Desktop, and .NET Core build tools.
$workloads = @(
    "--add Microsoft.VisualStudio.Workload.VCTools",
    "--add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools",
    "--add Microsoft.VisualStudio.Workload.NetCoreBuildTools",
    "--includeRecommended"
)

# Construct the command-line arguments
$arguments = @(
    "--quiet",
    "--wait",
    "--norestart",
    "--nocache",
    "--installPath `"$installPath`""
) + $workloads

Write-Host "Starting installation with arguments: $($arguments -join ' ')"

# Execute the installer and wait for it to complete
$process = Start-Process -FilePath $installerPath -ArgumentList $arguments -NoNewWindow -Wait -PassThru -RedirectStandardOutput $logPath -RedirectStandardError $errorLogPath

# Check the exit code of the installer
if ($process.ExitCode -ne 0) {
    Write-Error "Installation failed with exit code $($process.ExitCode)."
    Write-Host "Displaying install log:"
    Get-Content $logPath -ErrorAction SilentlyContinue | Write-Host
    Write-Host "Displaying error log:"
    Get-Content $errorLogPath -ErrorAction SilentlyContinue | Write-Host
    exit $process.ExitCode
}

Write-Host "Visual Studio Build Tools installed successfully."

# Clean up installer files after a successful installation
Write-Host "Cleaning up installer..."
Remove-Item $installerPath -Force -ErrorAction SilentlyContinue

exit 0