

type PlatformEnum = enum
  AIX
  ANDROID
  FREEBSD
  GUN
  KFREEBSD
  LINUX
  MACOS
  NETBSD
  OPENBSD
  SOLARIS
  UNKNOWN
  WINDOWS
  WINDOWSCE

# Gets the PlatformEnum value representing this system.
proc getCurrentPlatform*(): PlatformEnum =
  when system.hostOS == "windows":
    return WINDOWS
  elif system.hostOS == "linux":
    return LINUX
  elif system.hostOS == "macosx":
    return MACOS
  elif system.hostOS == "aix":
    return AIX
  elif system.hostOS == "solaris":
    return SOLARIS
  elif system.hostOS == "freebsd":
    return FREEBSD
  elif system.hostOS == "netbsd":
    return NETBSD
  elif system.hostOS == "openbsd":
    return OPENBSD
  else:
    return UNKNOWN

# Creates a new instance of the appropriate platform-specific OperatingSystem.
proc getHardware*() =
  discard

# Creates a new instance of the appropriate platform-specific HardwareAbstractionLayer.
proc getOperatingSystem*() =
  discard
