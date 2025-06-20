# Full Windows Dev & Debug Docker Image

## What's Included

- Git, Node.js, Python, Go, Rust, .NET SDK
- Visual Studio Build Tools (C++, MSBuild)
- Bash (MSYS2 & Cygwin)
- Debuggers: ProcMon, WinDbg, Process Hacker, Sysinternals
- Archive tools: 7-Zip, WinRAR
- choco, curl, wget, make, cmake

## How to Use

```sh
docker build -t windows-devbox .
docker run -it --isolation=process windows-devbox
```

You’ll start in an MSYS2 Bash shell and have access to all dev and debug tools.