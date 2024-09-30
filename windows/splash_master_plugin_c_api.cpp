#include "include/splash_master/splash_master_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "splash_master_plugin.h"

void SplashMasterPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  splash_master::SplashMasterPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
