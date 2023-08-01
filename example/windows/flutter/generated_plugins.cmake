#
# Generated file, do not edit.
#

list(APPEND FLUTTER_PLUGIN_LIST
  audio_device_desktop
  bitsdojo_window_windows
  connectivity_plus
  dart_vlc
  desktop_drop
  desktop_lifecycle
  desktop_open_file
  fc_native_video_thumbnail
  flutter_image_view
  flutter_native_view
  media_kit_libs_windows_video
  media_kit_video
  pasteboard
  permission_handler_windows
  screen_capture_assistant
  screen_retriever
  url_launcher_windows
  win_toast
  window_manager
  zego_express_engine
)

list(APPEND FLUTTER_FFI_PLUGIN_LIST
  media_kit_native_event_loop
)

set(PLUGIN_BUNDLED_LIBRARIES)

foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_subdirectory(flutter/ephemeral/.plugin_symlinks/${plugin}/windows plugins/${plugin})
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin}_plugin)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES $<TARGET_FILE:${plugin}_plugin>)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${plugin}_bundled_libraries})
endforeach(plugin)

foreach(ffi_plugin ${FLUTTER_FFI_PLUGIN_LIST})
  add_subdirectory(flutter/ephemeral/.plugin_symlinks/${ffi_plugin}/windows plugins/${ffi_plugin})
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${ffi_plugin}_bundled_libraries})
endforeach(ffi_plugin)
