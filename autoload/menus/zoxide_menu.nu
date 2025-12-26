export-env {
  $env.config = (
    $env.config?
    | default {}
    | upsert menus { default [] }
    | upsert keybindings { default [] }
  )

  $env.config.menus ++= [{
    name: zoxide_menu
    only_buffer_difference: true
    marker: "z > "
    type: {
      layout: list
      page_size: 20
    }
    style: {
      text: green                   
      selected_text: green_reverse       
      description_text: yellow
    }
    source: {
      |buffer, position|
        zoxide query -ls $buffer | parse -r '(?P<description>[0-9]+) (?P<value>.+)'
    }
  }]

  $env.config.keybindings ++= [
    {
      name: zoxide_menu
      modifier: control
      keycode: char_o
      mode: [emacs, vi_normal, vi_insert]
      event: [
        { send: menu name: zoxide_menu }
      ]
    },
    {
      name: edit
      modifier: alt
      keycode: char_e
      mode: [emacs, vi_normal, vi_insert]
      event: [
        { send: OpenEditor }
      ]
    }
  ]
}