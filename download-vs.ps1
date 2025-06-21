# download-vs.ps1

Write-Host "Downloading Visual Studio Build Tools..."

try {
    $url = "https://aka.ms/vs/17/release/vs_BuildTools.exe"
    $outFile = "C:\vs_BuildTools.exe"

    Invoke-WebRequest -Uri $url -OutFile $outFile -UseBasicParsing -ErrorAction Stop

    Write-Host "Installing Visual Studio Build Tools..."
    Start-Process -FilePath $outFile `
        -ArgumentList "--quiet --wait --norestart --nocache --installPath C:\BuildTools --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools --add Microsoft.VisualStudio.Workload.NetCoreBuildTools --includeRecommended" `
        -NoNewWindow -Wait -RedirectStandardOutput "C:\vs_install.log" -RedirectStandardError "C:\vs_error.log"

    if ($LASTEXITCODE -ne 0) {
        Write-Error "VS Build Tools failed with exit code $LASTEXITCODE"
        Get-Content C:\vs_error.log -ErrorAction SilentlyContinue | Write-Host
        exit $LASTEXITCODE
    }

} catch {
    Write-Host "##[error] Exception occurred: $($_.Exception.Message)"
    exit 1
} finally {
    Write-Host "Cleaning up installer files..."
    Remove-Item "C:\vs_BuildTools.exe", "C:\vs_install.log", "C:\vs_error.log" -Force -ErrorAction SilentlyContinue
}