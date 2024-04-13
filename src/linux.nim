import std/strutils,std/strscans, os

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

type
  CpuTime = object
    user: int
    nice: int
    system: int
    idle: int
    iowait: int
    irq: int
    softirq: int
    steal: int
    guest: int
    guest_nice: int

proc get_cputime(): CpuTime =
  var time: CpuTime
  var user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice: int
  let stat = readFile("/proc/stat")
  discard scanf(stat, "cpu  $i $i $i $i $i $i %i $i $i $i",
                user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice)
  time.user = user
  time.nice = nice
  time.system = system
  time.idle = idle
  time.iowait = iowait
  time.irq = irq
  time.softirq = softirq
  time.steal = steal
  time.guest = guest
  time.guest_nice = guest_nice
  return time

proc get_cpu_usage(prev: CpuTime, curr: CpuTime): float =
  let total_prev = prev.user + prev.nice + prev.system + prev.idle + prev.iowait + prev.irq + prev.softirq + prev.steal
  let total_curr = curr.user + curr.nice + curr.system + curr.idle + curr.iowait + curr.irq + curr.softirq + curr.steal
  let idle_prev = prev.idle + prev.iowait
  let idle_curr = curr.idle + curr.iowait
  if total_prev == total_curr:
    return 0.0
  let usage = (total_curr - total_prev - (idle_curr - idle_prev)) / (total_curr - total_prev)
  return usage


proc getCpuUsage*(): float =
  let time1 = get_cputime()
  sleep(1000)
  let time2 = get_cputime()
  return get_cpu_usage(time1, time2)
