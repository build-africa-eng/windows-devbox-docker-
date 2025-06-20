FROM mcr.microsoft.com/windows/servercore:20348

SHELL ["powershell", "-Command"]

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

### --- Install Chocolatey ---
RUN Set-ExecutionPolicy Bypass -Scope Process -Force ; `
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

ENV PATH="C:\\ProgramData\\chocolatey\\bin;${PATH}"

### --- Core Dev & CLI Tools ---
RUN choco install -y `
    git `
    nodejs-lts `
    python `
    openjdk `
    golang `
    rust `
    dotnet-sdk `
    vscode.install `
    7zip `
    winrar `
    curl `
    wget `
    unzip `
    make `
    mingw `
    cmake `
    visualstudio2022buildtools `
    --ignore-checksums

### --- Install Debugging Tools ---
RUN choco install -y `
    sysinternals `
    windbg `
    processhacker `
    dbgview `
    --ignore-checksums

### --- Install MSYS2 ---
RUN Invoke-WebRequest https://github.com/msys2/msys2-installer/releases/latest/download/msys2-x86_64-20240107.exe -OutFile msys2.exe ; `
    Start-Process msys2.exe -ArgumentList '--root C:\\msys64 --script C:\\' -NoNewWindow -Wait ; `
    Remove-Item msys2.exe

ENV PATH="C:\\msys64\\usr\\bin;C:\\msys64\\mingw64\\bin;${PATH}"
ENV MSYSTEM=MINGW64

### --- Install Cygwin ---
RUN Invoke-WebRequest https://cygwin.com/setup-x86_64.exe -OutFile cygwin.exe ; `
    Start-Process cygwin.exe -ArgumentList '--quiet-mode --root C:\\cygwin64 --site http://mirrors.kernel.org/sourceware/cygwin/ --packages unzip,tar,gzip,xz,zstd,make,git,gcc-core,bash' -NoNewWindow -Wait ; `
    Remove-Item cygwin.exe

ENV PATH="C:\\cygwin64\\bin;${PATH}"

### --- Create Dev Workspace ---
RUN mkdir C:\\dev
WORKDIR C:\\dev

CMD ["C:\\msys64\\usr\\bin\\bash.exe", "--login", "-i"]