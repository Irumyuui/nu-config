# $env.config.buffer_editor = "code"

source ./scripts/network-proxy.nu

$env.config.render_right_prompt_on_last_line = true
$env.config.show_banner = false
$env.config.buffer_editor = "hx"
$env.config.history.max_size = 1000000
$env.config.display_errors.exit_code = true
$env.config.rm.always_trash = true
$env.config.table.mode = 'reinforced'

# $env.RUSTC_WRAPPER = "sccache"
$env.RUST_BACKTRACE = 1
$env.RUSTUP_DIST_SERVER = "https://rsproxy.cn"
$env.RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup"

$env.FZF_DEFAULT_COMMAND = "fd --exclude={.git,.idea,.sass-cache,node_modules,build} --type f"
$env.FZF_DEFAULT_OPTS = '--preview "bat --style=numbers --color=always --line-range :500 {}"'

$env.DOTNET_CLI_TELEMETRY_OPTOUT = 1

$env.config.hooks.command_not_found = {
  |cmd_name| (
    try {
      let attrs = (
        ftype | find $cmd_name | to text | lines | reduce -f [] {
          |line, acc| $line | parse "{type}={path}" | append $acc
        } | group-by path | transpose key value | each {
          |row| {
            path: $row.key,
            types: ($row.value | get type | str join ", ")
          }
        }
      )

      let len = ($attrs | length)
      if $len == 0 {
        return null
      } else {
        return ($attrs | table --collapse)
      }
    }
  )
}

def to-base [base: int] {
  let num = $in
  let digits = "0123456789abcdefghijklmnopqrstuvwxyz"

  if $num == 0 {
    return "0"
  }

  mut result = ""
  mut n = $num

  while $n > 0 {
    let remainder = $n mod $base
    let digit = ($digits | str substring $remainder..$remainder)
    $result = $digit + $result
    $n = ($n / $base) | math floor
  }

  $result
}
