{ config, lib, pkgs, ... }:

let
  interval      = 30;     # seconds between checks
  dataPath      = "/data"; # ZFS mount to probe (a hung ZFS shows up as a timeout here)
  memFullMax    = 5;      # PSI memory "full avg10" threshold (%)
  ioFullMax     = 10;     # PSI io "full avg10" threshold (%)
  dStateMax     = 3;      # number of processes in uninterruptible sleep
  availMinMiB   = 512;    # MemAvailable below this triggers a dump
  slowMs        = 2000;   # disk write / stat latency threshold
  dumpCooldown  = 300;    # min seconds between detailed dumps
  keepDumps     = 50;

  script = pkgs.writeShellScript "hang-monitor" ''
    LOG_DIR=/var/lib/hang-monitor
    last_dump=0

    # psi <cpu|memory|io> <some|full>  -> avg10 value
    psi() { awk -v k="$2" '$1==k { split($2, a, "="); print a[2] }' "/proc/pressure/$1"; }

    # probe <timeout-seconds> <command...>  -> latency in ms, TIMEOUT, or FAIL
    probe() {
      local t=$1 s e rc
      shift
      s=$(date +%s%N)
      timeout "$t" "$@" >/dev/null 2>&1
      rc=$?
      e=$(date +%s%N)
      if [ "$rc" -eq 0 ]; then echo $(( (e - s) / 1000000 ))
      elif [ "$rc" -eq 124 ]; then echo TIMEOUT
      else echo FAIL; fi
    }

    over() { awk -v v="$1" -v t="$2" 'BEGIN { exit !(v + 0 >= t + 0) }'; }

    slow() {  # slow <label> <value>: flags TIMEOUT/FAIL or latency above threshold
      case "$2" in
        TIMEOUT|FAIL) reasons="$reasons $1=$2" ;;
        *) [ "$2" -gt ${toString slowMs} ] && reasons="$reasons $1=''${2}ms" ;;
      esac
    }

    dump() {
      local f="$LOG_DIR/dump-$(date +%Y%m%d-%H%M%S).log"
      {
        echo "=== $(date -Is) reasons:$reasons"
        echo "--- top by RSS";   timeout 10 ps -eo pid,stat,rss,wchan:32,etime,cmd --sort=-rss | head -15
        echo "--- D-state";      timeout 10 ps -eo pid,stat,etime,wchan:32,cmd | awk '$2 ~ /^D/'
        echo "--- meminfo";      head -25 /proc/meminfo
        echo "--- pressure";     grep . /proc/pressure/*
        echo "--- microvm mem";  grep . /sys/fs/cgroup/system.slice/microvm@*.service/memory.current 2>/dev/null
        echo "--- zpool";        timeout 10 zpool list
        echo "--- vmstat";       timeout 10 vmstat 1 3
        echo w > /proc/sysrq-trigger   # dump blocked tasks to the kernel log
        sleep 1
        echo "--- dmesg tail";   timeout 10 dmesg -T | tail -60
      } > "$f" 2>&1
      sync
      ls -1t "$LOG_DIR"/dump-* 2>/dev/null | tail -n +${toString (keepDumps + 1)} | xargs -r rm --
    }

    while true; do
      reasons=""
      now=$(date +%s)

      load=$(cut -d' ' -f1-3 /proc/loadavg)
      cpu_some=$(psi cpu some)
      mem_some=$(psi memory some); mem_full=$(psi memory full)
      io_some=$(psi io some);      io_full=$(psi io full)
      avail=$(awk '/^MemAvailable/ { print int($2 / 1024) }' /proc/meminfo)
      swap=$(awk '/^SwapTotal/ { t = $2 } /^SwapFree/ { f = $2 } END { print int((t - f) / 1024) }' /proc/meminfo)
      arc=$(awk '$1 == "size" { print int($3 / 1048576) }' /proc/spl/kstat/zfs/arcstats 2>/dev/null)
      [ -n "$arc" ] || arc=n/a
      vm=$(cat /sys/fs/cgroup/system.slice/microvm@*.service/memory.current 2>/dev/null | awk '{ s += $1 } END { print int(s / 1048576) }')
      dstate=$(ps -eo stat= | awk '$1 ~ /^D/ { n++ } END { print n + 0 }')

      root_ms=$(probe 10 dd if=/dev/zero of="$LOG_DIR/probe" bs=4k count=1 oflag=dsync conv=notrunc)
      data_ms=$(probe 10 stat -f ${dataPath})
      gw=$(ip -4 route show default | awk '{ print $3; exit }')
      if [ -n "$gw" ]; then gw_ms=$(probe 3 ping -c1 -W2 "$gw"); else gw_ms=n/a; fi

      over "$mem_full" ${toString memFullMax} && reasons="$reasons mem_full=$mem_full"
      over "$io_full"  ${toString ioFullMax}  && reasons="$reasons io_full=$io_full"
      [ "$dstate" -ge ${toString dStateMax} ] && reasons="$reasons dstate=$dstate"
      [ "$avail" -lt ${toString availMinMiB} ] && reasons="$reasons avail=$avail"
      slow root_write "$root_ms"
      slow data_stat  "$data_ms"

      line="load=\"$load\" cpu_some=$cpu_some mem_some=$mem_some mem_full=$mem_full io_some=$io_some io_full=$io_full avail=''${avail}MiB swap=''${swap}MiB arc=''${arc}MiB microvm=''${vm}MiB dstate=$dstate root_write_ms=$root_ms data_stat_ms=$data_ms gw_ping_ms=$gw_ms"
      echo "$line"                                  # -> journal
      echo "$(date -Is) $line" > "$LOG_DIR/last-heartbeat"; sync -f "$LOG_DIR/last-heartbeat"

      if [ -n "$reasons" ]; then
        echo "ALERT:$reasons"
        if [ $(( now - last_dump )) -ge ${toString dumpCooldown} ]; then
          last_dump=$now
          dump
        fi
      fi

      sleep ${toString interval}
    done
  '';
in
{
  systemd.services.hang-monitor = {
    description = "Host hang / resource pressure monitor";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    path = with pkgs; [
      coreutils gawk procps util-linux iproute2 iputils findutils
      config.boot.zfs.package
    ];
    serviceConfig = {
      ExecStart = script;
      Restart = "always";
      RestartSec = 5;
      StateDirectory = "hang-monitor";   # /var/lib/hang-monitor
      Nice = -10;                        # keep running when the box is busy
      OOMScoreAdjust = -900;             # don't let the OOM killer take it first
    };
  };

  # Make the evidence survive the next hang
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;                  # needed for the sysrq-w dump
    "kernel.hung_task_timeout_secs" = 60;
  };
  services.journald.settings.Journal = {
    Storage="persistent";
    SyncIntervalSec="5s";
  };

  # Optional: auto-reboot on a full hang (only works if the hardware has a watchdog)
  systemd.watchdog = {
    runtimeTime = "60s";
    rebootTime = "2min";
  };
}

