//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <audio_device_desktop/audio_device_desktop_plugin_c_api.h>
#include <bitsdojo_window_windows/bitsdojo_window_plugin.h>
#include <connectivity_plus/connectivity_plus_windows_plugin.h>
#include <dart_vlc/dart_vlc_plugin.h>
#include <desktop_drop/desktop_drop_plugin.h>
#include <desktop_lifecycle/desktop_lifecycle_plugin.h>
#include <desktop_open_file/desktop_open_file_plugin.h>
#include <fc_native_video_thumbnail/fc_native_video_thumbnail_plugin_c_api.h>
#include <flutter_image_view/flutter_image_view_plugin.h>
#include <flutter_native_view/flutter_native_view_plugin.h>
#include <media_kit_libs_windows_video/media_kit_libs_windows_video_plugin_c_api.h>
#include <media_kit_video/media_kit_video_plugin_c_api.h>
#include <pasteboard/pasteboard_plugin.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <screen_capture_assistant/screen_capture_assistant_plugin_c_api.h>
#include <screen_retriever/screen_retriever_plugin.h>
#include <url_launcher_windows/url_launcher_windows.h>
#include <win_toast/win_toast_plugin.h>
#include <window_manager/window_manager_plugin.h>
#include <zego_express_engine/zego_express_engine_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  AudioDeviceDesktopPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("AudioDeviceDesktopPluginCApi"));
  BitsdojoWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("BitsdojoWindowPlugin"));
  ConnectivityPlusWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ConnectivityPlusWindowsPlugin"));
  DartVlcPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DartVlcPlugin"));
  DesktopDropPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopDropPlugin"));
  DesktopLifecyclePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopLifecyclePlugin"));
  DesktopOpenFilePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopOpenFilePlugin"));
  FcNativeVideoThumbnailPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FcNativeVideoThumbnailPluginCApi"));
  FlutterImageViewPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterImageViewPlugin"));
  FlutterNativeViewPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterNativeViewPlugin"));
  MediaKitLibsWindowsVideoPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("MediaKitLibsWindowsVideoPluginCApi"));
  MediaKitVideoPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("MediaKitVideoPluginCApi"));
  PasteboardPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PasteboardPlugin"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  ScreenCaptureAssistantPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ScreenCaptureAssistantPluginCApi"));
  ScreenRetrieverPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ScreenRetrieverPlugin"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
  WinToastPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WinToastPlugin"));
  WindowManagerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowManagerPlugin"));
  ZegoExpressEnginePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ZegoExpressEnginePlugin"));
}
