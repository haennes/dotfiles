{...}:
let
  wgg = "/run/wrappers/bin/wgg";
in
''
def to_symbol [dt: number] {
  if last == null {
    "🔵"
  } else {
    if $dt < 150 {
      "🟢"
    } else {
      "🟡"
    }
  }
  
}
let parse =  (${wgg} -f json |
 from json |
 each {|i|  { t_off: ($i.peers | each {|p| ((date now | into int | $in / 1000_000_000) - $p.stats.last_handshake_time.secs_since_epoch )} | math min | math ceil), i: $i.name} } 
)
let mi = ($parse | math max | to_symbol $in.t_off)
let ma = ($parse | math min | to_symbol $in.t_off)
let l = $parse | each {|i|
  let symbol = to_symbol $i.t_off
  $"($i.i) ($symbol): ($i.t_off)s"
} | str join  " | "
{
  text: $"($mi) ($ma)",
  tooltip: $l
} | to json

''
