#ifndef FLUTTER_PLUGIN_SPLASH_SCREEN_PLUGIN_H_
#define FLUTTER_PLUGIN_SPLASH_SCREEN_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace splash_screen {

class SplashScreenPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  SplashScreenPlugin();

  virtual ~SplashScreenPlugin();

  // Disallow copy and assign.
  SplashScreenPlugin(const SplashScreenPlugin&) = delete;
  SplashScreenPlugin& operator=(const SplashScreenPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace splash_screen

#endif  // FLUTTER_PLUGIN_SPLASH_SCREEN_PLUGIN_H_
