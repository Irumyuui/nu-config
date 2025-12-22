export-env {
    $env.config = (
        $env.config?
        | default {}
        | upsert menus { default [] }
        | upsert keybindings { default [] }
    )

    $env.config.menus ++= [{
        name: history_menu
        only_buffer_difference: false
        marker: "? "
        type: {
            layout: list
            # page_size: 10
        }
        style: {
            text: green                   
            selected_text: green_reverse       
            description_text: yellow
        }
        # source: { |buffer, position|
        #     history -l 
        #     | where command =~ $buffer
        #     | each { |it| {value: $it.command } }
        #     | reverse
        #     | uniq
        # }
    }]
    
    $env.config.keybindings ++= [{
        name: history_menu
        modifier: control
        keycode: char_r
        mode: emacs
        event: { send: menu name: history_menu }
    }]
}