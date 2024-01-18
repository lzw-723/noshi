
const windows = "<windows.h>"
{.pragma: kernel32, importc, dynlib: "kernel32".}
{.pragma: advapi32, importc, dynlib: "advapi32".}


## https://learn.microsoft.com/zh-cn/windows/win32/api/sysinfoapi/ns-sysinfoapi-system_info
type
  HANDLE = int32
  BOOL = int

  SystemInfo{.header: windows, importc: "SYSTEM_INFO".} = object
    wProcessorArchitecture: uint16
    dwNumberOfProcessors: uint16

  PERFORMANCE_INFORMATION {.header: "<psapi.h>", importc: "PERFORMANCE_INFORMATION".} = object
    ProcessCount: int
    ThreadCount: int
    HandleCount: int

  TOKEN_ELEVATION {.header: "<winnt.h>", importc: "TOKEN_ELEVATION".} = object
    TokenIsElevated: int

  ARCH = enum
    INTEL = 0, ARM = 5, IA64 = 6, AMD64 = 9, ARM64 = 12, UNKNOWN = 0xffff
  
  TOKEN_INFORMATION_CLASS = enum
    tokenElevation = 20


proc getNativeSystemInfo(sysInfo: var SystemInfo) {.kernel32, importc: "GetNativeSystemInfo".}
proc GetCurrentProcess(): HANDLE {.kernel32, importc: "GetCurrentProcess".}
proc IsWow64Process(h: HANDLE, isWow64: BOOL): BOOL {.kernel32, importc: "IsWow64Process".}
proc GetTickCount64(): int {.kernel32, importc: "GetTickCount64".}
proc OpenProcessToken(processHandle: HANDLE, desiredAccess: int, tokenHandle: var HANDLE): bool {.advapi32, importc: "OpenProcessToken".}
proc GetTokenInformation(tokenHandle: HANDLE, tokenInformationClass: TOKEN_INFORMATION_CLASS, tokenInformation: var TOKEN_ELEVATION, tokenInformationLength: int, returnLength: var int): bool {.advapi32, importc: "GetTokenInformation"}
proc GetCurrentProcessId(): int {.kernel32, importc: "GetCurrentProcessId".}
proc GetCurrentThreadId(): int {.kernel32, importc: "GetCurrentThreadId".}
proc GetPerformanceInfo(info: var PERFORMANCE_INFORMATION, cb: int): bool {.header: "<psapi.h>", importc: "GetPerformanceInfo".}

proc isX86*(): bool =
  ## Is the processor architecture x86?
  ## return true if the processor architecture is Intel x86
  var sys: SystemInfo
  getNativeSystemInfo(sys)
  return sys.wProcessorArchitecture == ord(ARCH.INTEL)

proc isWow*(): bool =
  ## Is the specified process x86 or x86-compatibility mode?
  ## param h is The handle to the processs to check
  ## return true if the process is 32-bit
  var wow: BOOL
  discard IsWow64Process(GetCurrentProcess(), wow)
  return wow == 1

proc getSystemUptime*(): int =
  return int(GetTickCount64() / 1000)

proc isElevated*(): bool =
  let query: int = 0x0008
  var h: HANDLE
  if OpenProcessToken(GetCurrentProcess(), query, h):
    var token: TOKEN_ELEVATION
    var length: int
    if GetTokenInformation(h, TOKEN_INFORMATION_CLASS.tokenElevation, token, sizeof(token), length): return token.TokenIsElevated > 0
  return false

proc getHandleCount*(): int =
  var info: PERFORMANCE_INFORMATION
  discard GetPerformanceInfo(info, sizeof(info))
  return info.HandleCount

proc getProcessId*(): int =
  return GetCurrentThreadId()

proc getProcessCount*(): int =
  var info: PERFORMANCE_INFORMATION
  discard GetPerformanceInfo(info, sizeof(info))
  return info.ProcessCount

proc getThreadId*(): int =
  return GetCurrentThreadId()

proc getThreadCount*(): int =
  var info: PERFORMANCE_INFORMATION
  discard GetPerformanceInfo(info, sizeof(info))
  return info.ThreadCount
