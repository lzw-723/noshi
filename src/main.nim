import noshi, windows, linux


when isMainModule:
  when system.hostOS == "windows":
    echo "Platform: ", getCurrentPlatform()
    echo "isX86: ", isX86()
    echo "isWow: ", isWow()
    echo "SystemUptime: ", getSystemUptime()
    echo "isElevated: ", isElevated()
    echo "ProcessId: ", getProcessId()
    echo "ThreadId: ", windows.getThreadId()
    echo "HandleCount: ", getHandleCount()
    echo "ProcessCount: ", getProcessCount()
    echo "ThreadCount: ", getThreadCount()
  elif system.hostOS == "linux":
    echo "sysname: ", getSysname()
    echo "nodename: ", getNodename()
    echo "release: ", getRelease()
    echo "version: ", getVersion()
    echo "machine: ", getMachine()
    echo "uptime: ", linux.getSystemUptime()
