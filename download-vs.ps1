# download-vs.ps1
Write-Host "Downloading Visual Studio Build Tools..."

$vsUrl = "https://aka.ms/vs/17/release/vs_BuildTools.exe"
$vsInstaller = "C:\vs_BuildTools.exe"
$logOut = "C:\vs_install.log"
$logErr = "C:\vs_error.log"

try {
    Invoke-WebRequest -Uri $vsUrl -OutFile $vsInstaller -UseBasicParsing -ErrorAction Stop
    Write-Host "Installing Visual Studio Build Tools..."

    $process = Start-Process -FilePath $vsInstaller `
        -ArgumentList "--quiet --wait --norestart --nocache --installPath C:\BuildTools --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools --add Microsoft.VisualStudio.Workload.NetCoreBuildTools --includeRecommended" `
        -NoNewWindow -PassThru -Wait `
        -RedirectStandardOutput $logOut -RedirectStandardError $logErr

    $exitCode = $process.ExitCode
    Write-Host "Installer exited with code: $exitCode"

    if ($exitCode -ne 0) {
        Write-Error "VS Build Tools installation failed with exit code $exitCode"
        Write-Host "=== stdout ==="
        Get-Content $logOut -ErrorAction SilentlyContinue | Write-Host
        Write-Host "=== stderr ==="
        Get-Content $logErr -ErrorAction SilentlyContinue | Write-Host
        exit $exitCode
    }

} catch {
    Write-Host "##[error] Exception occurred: $($_.Exception.Message)"
    exit 1
} finally {
    Write-Host "Cleaning up installer and logs..."
    Remove-Item $vsInstaller, $logOut, $logErr -Force -ErrorAction SilentlyContinue
}