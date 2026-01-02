# $env.config.buffer_editor = "code"

$env.config.buffer_editor = "hx"
$env.config.history.max_size = 1000000
$env.config.display_errors.exit_code = true

$env.RUSTC_WRAPPER = "sccache"
$env.RUST_BACKTRACE = 1
$env.RUSTUP_DIST_SERVER = "https://rsproxy.cn"
$env.RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup"

$env.FZF_DEFAULT_COMMAND = "fd --exclude={.git,.idea,.sass-cache,node_modules,build} --type f"
$env.FZF_DEFAULT_OPTS = '--preview "bat --style=numbers --color=always --line-range :500 {}"'

$env.DOTNET_CLI_TELEMETRY_OPTOUT = 1

if $nu.os-info.name == "windows" {
  alias atuin = atuin.exe
 }
