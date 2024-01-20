import std/strutils

const utsnameh = "<sys/utsname.h>"

type
  utsname {.header: utsnameh, importc: "struct utsname"} = object
    sysname: cstring
    nodename: cstring
    release: cstring
    version: cstring
    machine: cstring


proc uname(u: var utsname): int {.header: utsnameh, importc: "uname".}

proc getSysname*(): string =
  var u: utsname
  discard uname(u)
  return $ u.sysname

proc getNodename*(): string =
  var u: utsname
  discard uname(u)
  return $ u.nodename

proc getRelease*(): string =
  var u: utsname
  discard uname(u)
  return $ u.release

proc getVersion*(): string =
  var u: utsname
  discard uname(u)
  return $ u.version

proc getMachine*(): string =
  var u: utsname
  discard uname(u)
  return $ u.machine

proc getSystemUptime*(): int =
  let str = readFile("/proc/uptime")
  let uptime = toInt(parseFloat(str.splitWhitespace()[0]))
  return uptime
