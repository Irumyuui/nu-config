# def __current_session_history_menu [] {
#     {
#         # session menu
#         name: current_session_history_menu
#         only_buffer_difference: false
#         marker: "# "
#         type: {
#             layout: list
#             page_size: 10
#         }
#         style: {
#             text: green
#             selected_text: green_reverse
#             description_text: yellow
#         }
#         source: { |buffer, position|
#             history -l 
#             | where session_id == (history session)
#             | select command
#             | where command =~ $buffer
#             | each { |it| {value: $it.command } }
#             | reverse
#             | uniq
#         }
#     }
# }

# def __current_session_history_menu_keybinding [] {
#     {
#         name: current_session_history_menu
#         modifier: alt,
#         keycode: char_r,
#         mode: emacs,
#         event: {
#             send: menu name: current_session_history_menu
#         }
#     }
# }

# export-env {
#     $env.config = (
#         $env.config
#         | upsert menus ($env.config.menus | append (__current_session_history_menu))
#         | upsert keybindings ($env.config.keybindings | append [(__current_session_history_menu_keybinding)])
#     )
# }