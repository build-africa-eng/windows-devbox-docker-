FROM mcr.microsoft.com/windows/servercore:20348

SHELL ["powershell", "-Command"]

RUN Set-ExecutionPolicy Bypass -Scope Process -Force ; `
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12 ; `
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

RUN choco --version