export-env {
    $env.config = (
        $env.config?
        | default {}
        | upsert menus { default [] }
        | upsert keybindings { default [] }
    )

    $env.config.menus ++= [{
        name: commands_with_description_menu
        only_buffer_difference: true
        marker: "# "
        type: {
            layout: description
            columns: 4
            col_width: 20
            col_padding: 2
            selection_rows: 4
            description_rows: 10
        }
        style: {
            text: green                   
            selected_text: green_reverse       
            description_text: yellow
        }
        source: { |buffer, position|
            scope commands
            | where name =~ $buffer
            | each { |it| {value: $it.name description: $it.description} }
        }
    }]

    $env.config.keybindings ++= [{
        name: commands_with_description_menu
        modifier: control
        keycode: char_s
        mode: [emacs, vi_normal, vi_insert]
        event: { send: menu name: commands_with_description_menu }
    }]
}