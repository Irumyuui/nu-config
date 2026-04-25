$env.config.render_right_prompt_on_last_line = true
$env.config.show_banner = false
$env.config.buffer_editor = "hx"
$env.config.history.max_size = 1000000
$env.config.display_errors.exit_code = true
$env.config.rm.always_trash = true
$env.config.table.mode = "reinforced"

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
