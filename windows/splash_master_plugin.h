#ifndef FLUTTER_PLUGIN_SPLASH_MASTER_PLUGIN_H_
#define FLUTTER_PLUGIN_SPLASH_MASTER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace splash_master {

class SplashMasterPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  SplashMasterPlugin();

  virtual ~SplashMasterPlugin();

  // Disallow copy and assign.
  SplashMasterPlugin(const SplashMasterPlugin&) = delete;
  SplashMasterPlugin& operator=(const SplashMasterPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace splash_master

#endif  // FLUTTER_PLUGIN_SPLASH_MASTER_PLUGIN_H_
