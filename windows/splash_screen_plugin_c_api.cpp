#include "include/splash_screen/splash_screen_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "splash_screen_plugin.h"

void SplashScreenPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  splash_screen::SplashScreenPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
