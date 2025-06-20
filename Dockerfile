# Base Windows-native development image
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Set PowerShell as default shell
SHELL ["powershell", "-Command"]

# Install Chocolatey with TLS 1.2 enabled, non-interactively
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; \
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')); \
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }; \
    $env:PATH = 'C:\ProgramData\chocolatey\bin;' + $env:PATH; \
    [System.Environment]::SetEnvironmentVariable('PATH', $env:PATH, [System.EnvironmentVariableTarget]::Machine); \
    choco config set --name commandExecutionTimeoutSeconds --value 2700; \
    choco feature enable --name allowGlobalConfirmation; \
    choco feature disable --name showNonElevatedWarnings; \
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) { Write-Error 'Chocolatey not found in PATH'; exit 1 }

# Install core Windows-native tools
RUN choco install -y --no-progress --timeout 2700 \
    git \
    7zip \
    curl \
    wget; \
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# Create a working development directory and verify
RUN New-Item -ItemType Directory -Path C:\dev -Force; \
    if (-not (Test-Path C:\dev)) { Write-Error 'Failed to create C:\dev directory'; exit 1 }

# Set working directory
WORKDIR C:/dev

# Default to PowerShell for Windows-native experience
CMD ["powershell", "-NoExit", "-Command", "$PSVersionTable"]