# Use Windows Server 2022 base image
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Set PowerShell as default shell
SHELL ["powershell", "-Command"]

# Install Chocolatey with TLS 1.2 enabled
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; `
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; `
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Add Chocolatey to PATH
ENV PATH="C:\\ProgramData\\chocolatey\\bin;${PATH}"

# Install Windows-native CLI & Development Tools
RUN choco install -y `
    git `
    nodejs-lts `
    python `
    openjdk `
    golang `
    rust `
    dotnet-sdk `
    vscode `
    7zip `
    winrar `
    curl `
    wget `
    unzip `
    cmake `
    visualstudio2022buildtools `
    --no-progress

# Install Windows-native Debugging Tools
RUN choco install -y `
    sysinternals `
    windbg `
    processhacker `
    --no-progress

# Install Windows SDK (optional, for native Windows development)
RUN choco install -y windows-sdk-10.0 --no-progress

# Create a working development directory
RUN New-Item -ItemType Directory -Path C:\dev -Force
WORKDIR C:\dev

# Default to PowerShell for Windows-native experience
CMD ["powershell", "-NoExit", "-Command", "$PSVersionTable"]