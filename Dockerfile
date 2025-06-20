# Use Windows Server 2022 base image
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Set PowerShell as default shell
SHELL ["powershell", "-Command"]

# Install Chocolatey with TLS 1.2 enabled, non-interactively
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; \
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')); \
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# Add Chocolatey to PATH
ENV PATH="C:\\ProgramData\\chocolatey\\bin;${PATH}"

# Configure Chocolatey to run non-interactively
RUN choco config set --name commandExecutionTimeoutSeconds --value 2700; \
    choco feature enable --name allowGlobalConfirmation; \
    choco feature disable --name showNonElevatedWarnings

# Install Windows-native CLI & Development Tools non-interactively
RUN choco install -y --no-progress --timeout 2700 \
    git \
    nodejs-lts \
    python \
    openjdk \
    golang \
    rust \
    dotnet-sdk \
    vscode \
    7zip \
    winrar \
    curl \
    wget \
    unzip \
    cmake \
    visualstudio2022buildtools; \
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# Install Windows-native Debugging Tools non-interactively
RUN choco install -y --no-progress --timeout 2700 \
    sysinternals \
    windbg \
    processhacker; \
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# Install Windows SDK non-interactively
RUN choco install -y --no-progress --timeout 2700 \
    windows-sdk-10.0; \
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# Create a working development directory
RUN New-Item -ItemType Directory -Path C:\dev -Force
WORKDIR C:\dev

# Default to PowerShell for Windows-native experience
CMD ["powershell", "-NoExit", "-Command", "$PSVersionTable"]