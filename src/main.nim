import noshi, windows


when isMainModule:
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
