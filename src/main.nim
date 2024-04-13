import noshi


when isMainModule:
  when system.hostOS == "windows":
    import windows
    echo "Platform: ", getCurrentPlatform()
    echo "isX86: ", isX86()
    echo "isWow: ", isWow()
    echo "SystemUptime: ", windows.getSystemUptime()
    echo "isElevated: ", isElevated()
    echo "ProcessId: ", getProcessId()
    echo "ThreadId: ", windows.getThreadId()
    echo "HandleCount: ", getHandleCount()
    echo "ProcessCount: ", getProcessCount()
    echo "ThreadCount: ", getThreadCount()
    echo "ComputerName: ", getHostName()
  elif system.hostOS == "linux":
    import linux
    echo "sysname: ", getSysname()
    echo "nodename: ", getNodename()
    echo "release: ", getRelease()
    echo "version: ", getVersion()
    echo "machine: ", getMachine()
    echo "uptime: ", linux.getSystemUptime()
    echo "cpuusage: ", linux.getCpuUsage()
