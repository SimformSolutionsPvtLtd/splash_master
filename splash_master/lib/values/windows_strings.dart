import 'desktop_strings.dart';

abstract final class WindowsStrings {
  static const String version = 'version';

  /// Windows paths
  static const String windows = 'windows';
  static const String runner = 'runner';
  static const String resources = 'resources';
  static const String splashMaster = 'splash_master';
  static const String flutterWindowCpp = 'flutter_window.cpp';
  static const String flutterWindowH = 'flutter_window.h';

  static const String windowsRunnerDirectory = '$windows/$runner';
  static const String windowsResourcesDirectory =
      '$windowsRunnerDirectory/$resources';
  static const String windowsSplashResourcesDirectory =
      '$windowsResourcesDirectory/$splashMaster';

  static const String flutterWindowHeaderPath =
      '$windowsRunnerDirectory/$flutterWindowH';
  static const String flutterWindowCppPath =
      '$windowsRunnerDirectory/$flutterWindowCpp';
  static const String mainCppPath = '$windowsRunnerDirectory/main.cpp';
  static const String runnerCmakePath =
      '$windowsRunnerDirectory/CMakeLists.txt';

  static const String windowsSplashHeaderFileName = 'splash_master_splash.h';
  static const String windowsSplashSourceFileName = 'splash_master_splash.cpp';
  static const String windowsSplashHeaderPath =
      '$windowsRunnerDirectory/$windowsSplashHeaderFileName';
  static const String windowsSplashSourcePath =
      '$windowsRunnerDirectory/$windowsSplashSourceFileName';

  static const String windowsSplashConfigFileName =
      'splash_master_windows_config.json';
  static const String windowsSplashConfigPath =
      '$windowsSplashResourcesDirectory/$windowsSplashConfigFileName';

  static const String splashLightAssetFileName = 'splash_light';
  static const String splashDarkAssetFileName = 'splash_dark';
  static const String brandingLightAssetFileName = 'branding_light';
  static const String brandingDarkAssetFileName = 'branding_dark';

  static const String generatedCodeBeginMarker =
      '// BEGIN:SPLASH_MASTER_WINDOWS_GENERATED';
  static const String generatedCodeEndMarker =
      '// END:SPLASH_MASTER_WINDOWS_GENERATED';

  // CMake uses '#' for comments; keep separate markers for CMakeLists.txt.
  static const String generatedCodeBeginMarkerCmake =
      '# BEGIN:SPLASH_MASTER_WINDOWS_GENERATED';
  static const String generatedCodeEndMarkerCmake =
      '# END:SPLASH_MASTER_WINDOWS_GENERATED';

  /// Method channel names and method names for communicating with native Windows code.
  static const String windowsSplashMethodChannelName = 'windows_splash';
  static const String windowsRemoveSplashMethodName = 'removeSplash';

  /// Defaults for desktop splash window/layout behavior (Windows)
  static const int defaultAnimationDurationMs = 50;
  static const String defaultDismissAnimation = 'fade';

  /// ----------Code snippets for modifying Windows runner files-----------
  // main.cpp — #include splash header + call GetSplashMasterInitialWindowSize()
  static const String slashMasterHInclude =
      '#include "$windowsSplashHeaderFileName"';
  static const String flutterWindowHInclude = '#include "flutter_window.h"';
  static const String flutterWindowHWithSplashInclude =
      '#include "flutter_window.h"\n#include "$windowsSplashHeaderFileName"';

  // flutter_window.h — #include win32_window.h + SplashMaster forward decls
  static const String win32WindowHInclude = '#include "win32_window.h"';
  static const String win32WindowHWithSplashForwardDecls =
      '#include "win32_window.h"\n\nclass SplashMasterController;\n\n'
      'namespace flutter {\nclass EncodableValue;\ntemplate <typename T>\n'
      'class MethodChannel;\n}';
  static const String splashControllerForwardDecl =
      'class SplashMasterController;';
  static const String flutterViewControllerMemberDecl =
      '  std::unique_ptr<flutter::FlutterViewController> flutter_controller_;';
  static const String headerGeneratedMembers = '\n  $generatedCodeBeginMarker\n'
      '  std::unique_ptr<SplashMasterController> splash_controller_;\n'
      '  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> splash_channel_;\n'
      '  $generatedCodeEndMarker';

  // flutter_window.cpp — #include <optional> + method-channel headers
  static const String optionalInclude = '#include <optional>';
  static const String optionalWithChannelIncludes = '#include <optional>\n\n'
      '#include <flutter/method_channel.h>\n'
      '#include <flutter/standard_method_codec.h>';
  static const String methodChannelInclude =
      '#include <flutter/method_channel.h>';

  static const String mainCppGeneratedWindowSizeBlock =
      '$generatedCodeBeginMarker\n'
      '  unsigned int splash_width = ${DesktopStrings.defaultSplashWindowWidth};\n'
      '  unsigned int splash_height = ${DesktopStrings.defaultSplashWindowHeight};\n'
      '  GetSplashMasterInitialWindowSize(&splash_width, &splash_height);\n'
      '  Win32Window::Size size(splash_width, splash_height);\n'
      '$generatedCodeEndMarker';

  static const onCreateBlock =
      '  RegisterPlugins(flutter_controller_->engine());\n'
      '  SetChildContent(flutter_controller_->view()->GetNativeWindow());\n\n'
      '  flutter_controller_->engine()->SetNextFrameCallback([&]() {\n'
      '    this->Show();\n'
      '  });\n\n'
      '  // Flutter can complete the first frame before the "show window" callback is\n'
      '  // registered. The following call ensures a frame is pending to ensure the\n'
      '  // window is shown. It is a no-op if the first frame hasn\'t completed yet.\n'
      '  flutter_controller_->ForceRedraw();';

  static const updatedOnCreateBlock =
      '  RegisterPlugins(flutter_controller_->engine());\n'
      '  SetChildContent(flutter_controller_->view()->GetNativeWindow());\n\n'
      '  $generatedCodeBeginMarker\n'
      '  splash_controller_ = std::make_unique<SplashMasterController>();\n'
      '  const bool has_native_splash = splash_controller_->Initialize(GetHandle());\n'
      '  if (!has_native_splash) {\n'
      '    splash_controller_.reset();\n'
      '  }\n\n'
      '  splash_channel_ = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(\n'
      '      flutter_controller_->engine()->messenger(),\n'
      '      "$windowsSplashMethodChannelName",\n'
      '      &flutter::StandardMethodCodec::GetInstance());\n\n'
      '  splash_channel_->SetMethodCallHandler(\n'
      '      [this](const flutter::MethodCall<flutter::EncodableValue>& call,\n'
      '             std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {\n'
      '        if (call.method_name() == "$windowsRemoveSplashMethodName") {\n'
      '          if (splash_controller_) {\n'
      '            splash_controller_->DismissSplash();\n'
      '          }\n'
      '          result->Success(flutter::EncodableValue(true));\n'
      '        } else {\n'
      '          result->NotImplemented();\n'
      '        }\n'
      '      });\n\n'
      '  // Always wait for Flutter\'s first rendered frame before showing the\n'
      '  // Flutter window. With a splash active the popup covers the hidden window\n'
      '  // while Flutter renders; by the time Flutter code calls removeSplash()\n'
      '  // at least one frame is already composited, so the dismiss animation\n'
      '  // content with no black flash.\n'
      '  flutter_controller_->engine()->SetNextFrameCallback([&]() {\n'
      '    this->Show();\n'
      '  });\n'
      '  $generatedCodeEndMarker\n\n'
      '  // Flutter can complete the first frame before the "show window" callback is\n'
      '  // registered. The following call ensures a frame is pending to ensure the\n'
      '  // window is shown. It is a no-op if the first frame hasn\'t completed yet.\n'
      '  flutter_controller_->ForceRedraw();';

  static const onDestroyBlock = 'void FlutterWindow::OnDestroy() {\n'
      '  if (flutter_controller_) {\n'
      '    flutter_controller_ = nullptr;\n'
      '  }\n\n'
      '  Win32Window::OnDestroy();\n'
      '}';

  static const updatedOnDestroyBlock = 'void FlutterWindow::OnDestroy() {\n'
      '  splash_channel_.reset();\n'
      '  splash_controller_.reset();\n'
      '  if (flutter_controller_) {\n'
      '    flutter_controller_ = nullptr;\n'
      '  }\n\n'
      '  Win32Window::OnDestroy();\n'
      '}';

  static const String resourceCopyBlock = '\n'
      '$generatedCodeBeginMarkerCmake\n'
      'add_custom_command(\n'
      '    TARGET \${BINARY_NAME} POST_BUILD\n'
      '    COMMAND "\${CMAKE_COMMAND}" -E copy_directory\n'
      '        "\${CMAKE_CURRENT_SOURCE_DIR}/resources/splash_master"\n'
      '        "\$<TARGET_FILE_DIR:\${BINARY_NAME}>/resources/splash_master"\n'
      '    COMMENT "Copying splash_master resources"\n'
      ')\n'
      '$generatedCodeEndMarkerCmake';

  static final String buildWindowsSplashHeaderContent =
      _applyWindowsDefaultTemplateValues(r'''
#ifndef RUNNER_SPLASH_MASTER_SPLASH_H_
#define RUNNER_SPLASH_MASTER_SPLASH_H_

#include <string>
#include <windows.h>

class SplashMasterController {
 public:
	SplashMasterController();
	~SplashMasterController();

	bool Initialize(HWND parent_window);
	void DismissSplash();

 private:
	struct SplashConfig {
		int splash_window_width = __SPLASH_WINDOW_WIDTH__;
		int splash_window_height = __SPLASH_WINDOW_HEIGHT__;
		int main_window_width = __MAIN_WINDOW_WIDTH__;
		int main_window_height = __MAIN_WINDOW_HEIGHT__;
		int branding_spacing = __BRANDING_SPACING__;
		int animation_duration_ms = __ANIMATION_DURATION_MS__;
		bool borderless = __BORDERLESS__;
		std::wstring dismiss_animation = L"__DISMISS_ANIMATION__";

		COLORREF color = RGB(255, 255, 255);
		COLORREF color_dark = RGB(0, 0, 0);
		bool has_dark_color = false;

		std::wstring image_fit = L"__IMAGE_FIT__";
		std::wstring image_position = L"__IMAGE_POSITION__";
		std::wstring branding_position = L"__BRANDING_POSITION__";

		std::wstring image_path;
		std::wstring image_dark_path;
		std::wstring branding_image_path;
		std::wstring branding_image_dark_path;
	};

	static LRESULT CALLBACK SplashWndProc(HWND window,
																				UINT const message,
																				WPARAM const wparam,
																				LPARAM const lparam) noexcept;

	LRESULT HandleSplashMessage(HWND window,
															UINT const message,
															WPARAM const wparam,
															LPARAM const lparam) noexcept;

	bool LoadConfig();
	bool CreateSplashWindow();
	void DestroySplashWindow();
	void Paint(HDC hdc);
	void StartDismissAnimationIfNeeded();
	void TickDismissAnimation();
	void ResizeMainWindowIfNeeded();

	SplashConfig config_;
	HWND parent_window_ = nullptr;
	HWND splash_window_ = nullptr;
	BYTE alpha_ = 255;
	bool dismissing_ = false;
	int dismiss_elapsed_ms_ = 0;
	POINT dismiss_start_pos_{0, 0};
};

void GetSplashMasterInitialWindowSize(unsigned int* width,
																			unsigned int* height);

#endif  // RUNNER_SPLASH_MASTER_SPLASH_H_
''');

  static const String buildWindowsSplashSourceContent = r'''
#include "splash_master_splash.h"

#include <gdiplus.h>
#include <objidl.h>
#include <shlwapi.h>
#include <windows.h>

#include <algorithm>
#include <cmath>
#include <fstream>
#include <optional>
#include <regex>
#include <sstream>
#include <string>

#pragma comment(lib, "gdiplus.lib")
#pragma comment(lib, "shlwapi.lib")

namespace {

constexpr const wchar_t kSplashWindowClassName[] = L"SPLASH_MASTER_NATIVE_WINDOW";
constexpr UINT_PTR kFadeTimerId = 0x534D;
constexpr int kFadeTickMs = 16;
constexpr const wchar_t kConfigRelativePath[] =
		L"resources\\splash_master\\splash_master_windows_config.json";

ULONG_PTR g_gdiplus_token = 0;
int g_gdiplus_ref_count = 0;

std::wstring Utf16FromUtf8(const std::string& utf8_string) {
	if (utf8_string.empty()) {
		return std::wstring();
	}
	const int length = MultiByteToWideChar(CP_UTF8, 0, utf8_string.c_str(),
																				 static_cast<int>(utf8_string.size()),
																				 nullptr, 0);
	if (length <= 0) {
		return std::wstring();
	}

	std::wstring wide_string(length, 0);
	MultiByteToWideChar(CP_UTF8, 0, utf8_string.c_str(),
											static_cast<int>(utf8_string.size()),
											wide_string.data(), length);
	return wide_string;
}


std::wstring GetExecutableDirectory() {
	wchar_t module_path[MAX_PATH];
	if (GetModuleFileNameW(nullptr, module_path, MAX_PATH) == 0) {
		return L"";
	}
	PathRemoveFileSpecW(module_path);
	return module_path;
}

std::wstring ResolveRuntimePath(const std::wstring& relative_path) {
	auto executable_dir = GetExecutableDirectory();
	if (executable_dir.empty()) {
		return relative_path;
	}

	std::wstring normalized = relative_path;
	std::replace(normalized.begin(), normalized.end(), L'/', L'\\');
	return executable_dir + L"\\" + normalized;
}

std::optional<std::string> ReadFileAsString(const std::wstring& path) {
	std::ifstream file(path, std::ios::in | std::ios::binary);
	if (!file.is_open()) {
		return std::nullopt;
	}

	std::ostringstream buffer;
	buffer << file.rdbuf();
	return buffer.str();
}

std::optional<std::string> ReadJsonString(const std::string& json,
																					const std::string& key) {
	const std::regex pattern('"' + key + '"' + R"##(\s*:\s*"([^"]*)")##");
	std::smatch match;
	if (std::regex_search(json, match, pattern) && match.size() > 1) {
		return match[1].str();
	}
	return std::nullopt;
}

std::optional<int> ReadJsonInt(const std::string& json, const std::string& key) {
	const std::regex pattern('"' + key + '"' + R"(\s*:\s*(-?\d+))");
	std::smatch match;
	if (std::regex_search(json, match, pattern) && match.size() > 1) {
		return std::stoi(match[1].str());
	}
	return std::nullopt;
}

std::optional<bool> ReadJsonBool(const std::string& json,
																 const std::string& key) {
	const std::regex pattern('"' + key + '"' + R"(\s*:\s*(true|false))");
	std::smatch match;
	if (std::regex_search(json, match, pattern) && match.size() > 1) {
		return match[1].str() == "true";
	}
	return std::nullopt;
}

bool IsSystemInDarkMode() {
	// Check for active contrast theme (Accessibility > Contrast themes).
	// When one is enabled, AppsUseLightTheme does not change, so we detect dark
	// by measuring the luminance of the system window-background colour.
	HIGHCONTRAST hc{};
	hc.cbSize = sizeof(HIGHCONTRAST);
	if (SystemParametersInfoW(SPI_GETHIGHCONTRAST, sizeof(HIGHCONTRAST), &hc, 0) &&
			(hc.dwFlags & HCF_HIGHCONTRASTON)) {
		const COLORREF bg = GetSysColor(COLOR_WINDOW);
		const int luminance = (GetRValue(bg) * 299 +
											 GetGValue(bg) * 587 +
											 GetBValue(bg) * 114) / 1000;
		return luminance < 128;
	}

	// Standard light / dark mode toggle.
	const wchar_t* const kRegKey =
			L"Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize";
	const wchar_t* const kRegValue = L"AppsUseLightTheme";

	DWORD light_mode = 1;
	DWORD light_mode_size = sizeof(light_mode);
	const LSTATUS result = RegGetValueW(HKEY_CURRENT_USER, kRegKey, kRegValue,
																			RRF_RT_REG_DWORD, nullptr, &light_mode,
																			&light_mode_size);
	return result == ERROR_SUCCESS && light_mode == 0;
}

std::optional<COLORREF> ParseHexColor(const std::string& value) {
	if (value.empty()) {
		return std::nullopt;
	}

	std::string hex = value;
	if (hex[0] == '#') {
		hex = hex.substr(1);
	}

	if (hex.size() != 6 && hex.size() != 8) {
		return std::nullopt;
	}

	auto parse_component = [](const std::string& text,
														size_t start) -> std::optional<int> {
		if (start + 2 > text.size()) {
			return std::nullopt;
		}
		try {
			return std::stoi(text.substr(start, 2), nullptr, 16);
		} catch (...) {
			return std::nullopt;
		}
	};

	const size_t r_offset = hex.size() == 8 ? 2 : 0;
	const auto r = parse_component(hex, r_offset);
	const auto g = parse_component(hex, r_offset + 2);
	const auto b = parse_component(hex, r_offset + 4);
	if (!r || !g || !b) {
		return std::nullopt;
	}

	return RGB(*r, *g, *b);
}

void DrawImageWithRect(Gdiplus::Graphics* graphics,
											 Gdiplus::Image* image,
											 const RECT& rect,
											 const std::wstring& fit,
											 const std::wstring& position) {
	if (graphics == nullptr || image == nullptr) {
		return;
	}

	const float container_width = static_cast<float>(rect.right - rect.left);
	const float container_height = static_cast<float>(rect.bottom - rect.top);
	if (container_width <= 0 || container_height <= 0) {
		return;
	}

	const float image_width = static_cast<float>(image->GetWidth());
	const float image_height = static_cast<float>(image->GetHeight());
	if (image_width <= 0 || image_height <= 0) {
		return;
	}

	float target_width = image_width;
	float target_height = image_height;

	const float x_ratio = container_width / image_width;
	const float y_ratio = container_height / image_height;

	if (fit == L"fill") {
		target_width = container_width;
		target_height = container_height;
	} else if (fit == L"cover") {
		const float ratio = std::max(x_ratio, y_ratio);
		target_width = image_width * ratio;
		target_height = image_height * ratio;
	} else if (fit == L"fitWidth") {
		target_width = container_width;
		target_height = image_height * x_ratio;
	} else if (fit == L"fitHeight") {
		target_width = image_width * y_ratio;
		target_height = container_height;
	} else if (fit == L"scaleDown") {
		if (image_width > container_width || image_height > container_height) {
			const float ratio = std::min(x_ratio, y_ratio);
			target_width = image_width * ratio;
			target_height = image_height * ratio;
		}
	} else if (fit == L"none") {
		target_width = image_width;
		target_height = image_height;
	} else {
		const float ratio = std::min(x_ratio, y_ratio);
		target_width = image_width * ratio;
		target_height = image_height * ratio;
	}

	float x = (container_width - target_width) / 2.0f;
	float y = (container_height - target_height) / 2.0f;

	if (position == L"top" || position == L"topLeft" || position == L"topRight") {
		y = 0;
	} else if (position == L"bottom" || position == L"bottomLeft" ||
						 position == L"bottomRight") {
		y = container_height - target_height;
	}

	if (position == L"left" || position == L"topLeft" || position == L"bottomLeft") {
		x = 0;
	} else if (position == L"right" || position == L"topRight" ||
						 position == L"bottomRight") {
		x = container_width - target_width;
	}

	graphics->SetInterpolationMode(Gdiplus::InterpolationModeHighQualityBicubic);
	graphics->DrawImage(image, Gdiplus::RectF(x, y, target_width, target_height));
}

Gdiplus::RectF ComputeBrandingRect(Gdiplus::Image* image,
																	 const RECT& rect,
																	 const std::wstring& position,
																	 int spacing) {
	if (image == nullptr) {
		return Gdiplus::RectF(0, 0, 0, 0);
	}

	const float container_width = static_cast<float>(rect.right - rect.left);
	const float container_height = static_cast<float>(rect.bottom - rect.top);
	const float width = static_cast<float>(image->GetWidth());
	const float height = static_cast<float>(image->GetHeight());

	float x = (container_width - width) / 2.0f;
	float y = container_height - height - spacing;

	if (position == L"topLeft") {
		x = static_cast<float>(spacing);
		y = static_cast<float>(spacing);
	} else if (position == L"topCenter") {
		x = (container_width - width) / 2.0f;
		y = static_cast<float>(spacing);
	} else if (position == L"topRight") {
		x = container_width - width - spacing;
		y = static_cast<float>(spacing);
	} else if (position == L"centerLeft") {
		x = static_cast<float>(spacing);
		y = (container_height - height) / 2.0f;
	} else if (position == L"center") {
		x = (container_width - width) / 2.0f;
		y = (container_height - height) / 2.0f;
	} else if (position == L"centerRight") {
		x = container_width - width - spacing;
		y = (container_height - height) / 2.0f;
	} else if (position == L"bottomLeft") {
		x = static_cast<float>(spacing);
		y = container_height - height - spacing;
	} else if (position == L"bottomCenter") {
		x = (container_width - width) / 2.0f;
		y = container_height - height - spacing;
	} else if (position == L"bottomRight") {
		x = container_width - width - spacing;
		y = container_height - height - spacing;
	}

	return Gdiplus::RectF(x, y, width, height);
}

}  // namespace

SplashMasterController::SplashMasterController() {
	if (g_gdiplus_ref_count == 0) {
		Gdiplus::GdiplusStartupInput startup_input;
		Gdiplus::GdiplusStartup(&g_gdiplus_token, &startup_input, nullptr);
	}
	++g_gdiplus_ref_count;
}

SplashMasterController::~SplashMasterController() {
	DestroySplashWindow();
	--g_gdiplus_ref_count;
	if (g_gdiplus_ref_count == 0 && g_gdiplus_token != 0) {
		Gdiplus::GdiplusShutdown(g_gdiplus_token);
		g_gdiplus_token = 0;
	}
}

bool SplashMasterController::Initialize(HWND parent_window) {
	parent_window_ = parent_window;
	if (parent_window_ == nullptr) {
		return false;
	}

	if (!LoadConfig()) {
		return false;
	}

	// Center the parent window on the nearest monitor work area so the splash
	// popup (which copies the parent rect) appears centred on screen.
	{
		RECT wr{};
		GetWindowRect(parent_window_, &wr);
		const int pw = wr.right - wr.left;
		const int ph = wr.bottom - wr.top;
		MONITORINFO mi{};
		mi.cbSize = sizeof(MONITORINFO);
		const HMONITOR mon =
				MonitorFromWindow(parent_window_, MONITOR_DEFAULTTONEAREST);
		GetMonitorInfo(mon, &mi);
		const int cx =
				mi.rcWork.left + (mi.rcWork.right - mi.rcWork.left - pw) / 2;
		const int cy =
				mi.rcWork.top + (mi.rcWork.bottom - mi.rcWork.top - ph) / 2;
		SetWindowPos(parent_window_, nullptr, cx, cy, 0, 0,
						 SWP_NOSIZE | SWP_NOZORDER | SWP_NOACTIVATE | SWP_NOREDRAW);
	}

	return CreateSplashWindow();
}

void SplashMasterController::DismissSplash() {
	if (splash_window_ == nullptr || dismissing_) {
		return;
	}
	// Paint the Flutter window background with the splash color before resize.
	// This camouflages any GDI erase triggered by the resize, mirroring the
	// macOS approach of setting NSWindow backgroundColor to the splash color.
	{
		const COLORREF bg = (IsSystemInDarkMode() && config_.has_dark_color)
				? config_.color_dark : config_.color;
		if (const HDC dc = GetDC(parent_window_)) {
			RECT rc{};
			GetClientRect(parent_window_, &rc);
			HBRUSH brush = CreateSolidBrush(bg);
			FillRect(dc, &rc, brush);
			DeleteObject(brush);
			ReleaseDC(parent_window_, dc);
		}
	}
	// Resize the Flutter window NOW while the splash is still fully opaque.
	// This hides any GPU surface reallocation that would otherwise appear as
	// a brief black frame during the transition.
	ResizeMainWindowIfNeeded();
	StartDismissAnimationIfNeeded();
}

bool SplashMasterController::LoadConfig() {
	const auto json_path = ResolveRuntimePath(kConfigRelativePath);
	const auto json_content = ReadFileAsString(json_path);
	if (!json_content.has_value()) {
		return false;
	}

	if (const auto value = ReadJsonInt(*json_content, "splash_window_width")) {
		config_.splash_window_width = std::max(100, *value);
	}
	if (const auto value = ReadJsonInt(*json_content, "splash_window_height")) {
		config_.splash_window_height = std::max(100, *value);
	}
	if (const auto value = ReadJsonInt(*json_content, "main_window_width")) {
		config_.main_window_width = std::max(100, *value);
	}
	if (const auto value = ReadJsonInt(*json_content, "main_window_height")) {
		config_.main_window_height = std::max(100, *value);
	}
	if (const auto value = ReadJsonInt(*json_content, "branding_spacing")) {
		config_.branding_spacing = std::max(0, *value);
	}
	if (const auto value = ReadJsonInt(*json_content, "animation_duration")) {
		config_.animation_duration_ms = std::max(0, *value);
	}
	if (const auto value = ReadJsonBool(*json_content, "borderless")) {
		config_.borderless = *value;
	}
	if (const auto value = ReadJsonString(*json_content, "dismiss_animation")) {
		config_.dismiss_animation = Utf16FromUtf8(*value);
	}

	if (const auto value = ReadJsonString(*json_content, "image_fit")) {
		config_.image_fit = Utf16FromUtf8(*value);
	}
	if (const auto value = ReadJsonString(*json_content, "image_position")) {
		config_.image_position = Utf16FromUtf8(*value);
	}
	if (const auto value = ReadJsonString(*json_content, "branding_position")) {
		config_.branding_position = Utf16FromUtf8(*value);
	}

	if (const auto value = ReadJsonString(*json_content, "color")) {
		if (const auto parsed = ParseHexColor(*value)) {
			config_.color = *parsed;
		}
	}
	if (const auto value = ReadJsonString(*json_content, "color_dark")) {
		if (const auto parsed = ParseHexColor(*value)) {
			config_.color_dark = *parsed;
			config_.has_dark_color = true;
		}
	}

	const auto image = ReadJsonString(*json_content, "image");
	const auto image_dark = ReadJsonString(*json_content, "image_dark");
	const auto branding = ReadJsonString(*json_content, "branding_image");
	const auto branding_dark = ReadJsonString(*json_content, "branding_image_dark");

	if (image.has_value()) {
		config_.image_path = ResolveRuntimePath(Utf16FromUtf8(*image));
	}
	if (image_dark.has_value()) {
		config_.image_dark_path = ResolveRuntimePath(Utf16FromUtf8(*image_dark));
	}
	if (branding.has_value()) {
		config_.branding_image_path = ResolveRuntimePath(Utf16FromUtf8(*branding));
	}
	if (branding_dark.has_value()) {
		config_.branding_image_dark_path =
				ResolveRuntimePath(Utf16FromUtf8(*branding_dark));
	}

	return true;
}

bool SplashMasterController::CreateSplashWindow() {
	WNDCLASSW window_class{};
	window_class.hCursor = LoadCursor(nullptr, IDC_ARROW);
	window_class.lpszClassName = kSplashWindowClassName;
	window_class.style = CS_HREDRAW | CS_VREDRAW;
	window_class.hInstance = GetModuleHandle(nullptr);
	window_class.hbrBackground = nullptr;
	window_class.lpfnWndProc = SplashWndProc;
	RegisterClassW(&window_class);

	// Use the full window rect (screen coords) so the popup covers the
	// entire Flutter window frame, including the title bar.
	RECT parent_rect{};
	GetWindowRect(parent_window_, &parent_rect);
	const int width = parent_rect.right - parent_rect.left;
	const int height = parent_rect.bottom - parent_rect.top;

	// Create as a top-level popup owned by (not a child of) the Flutter window.
	// WS_EX_TOPMOST guarantees it sits above GPU-rendered
	// Flutter content, which can bypass normal GDI Z-order.
	// WS_EX_TOOLWINDOW hides the splash from the Windows taskbar so the user
	// cannot click away to reveal the unrendered Flutter window behind it.
	const DWORD splash_style = config_.borderless
			? WS_POPUP
			: WS_OVERLAPPEDWINDOW;
	// WS_EX_TOOLWINDOW forces a narrow tool-window title bar, so only use it
	// for borderless (popup) windows. Non-borderless windows are owned by the
	// Flutter window and are already excluded from the taskbar automatically.
	const DWORD splash_ex_style = config_.borderless
			? (WS_EX_LAYERED | WS_EX_TOPMOST | WS_EX_TOOLWINDOW)
			: (WS_EX_LAYERED | WS_EX_TOPMOST);
	splash_window_ = CreateWindowExW(
			splash_ex_style,
			kSplashWindowClassName, L"",
			splash_style,
			parent_rect.left, parent_rect.top,
			width, height,
			parent_window_,
			nullptr,
			GetModuleHandle(nullptr), this);
	if (splash_window_ == nullptr) {
		return false;
	}

	SetLayeredWindowAttributes(splash_window_, 0, alpha_, LWA_ALPHA);

	// Copy the parent window's title and icon so the splash title bar looks
	// identical to the main Flutter window.
	if (!config_.borderless) {
		wchar_t title[256] = {};
		if (GetWindowTextW(parent_window_, title, 256) > 0) {
			SetWindowTextW(splash_window_, title);
		}
		HICON icon_big = reinterpret_cast<HICON>(
				SendMessageW(parent_window_, WM_GETICON, ICON_BIG, 0));
		if (!icon_big) {
			icon_big = reinterpret_cast<HICON>(
					GetClassLongPtrW(parent_window_, GCLP_HICON));
		}
		HICON icon_small = reinterpret_cast<HICON>(
				SendMessageW(parent_window_, WM_GETICON, ICON_SMALL, 0));
		if (!icon_small) {
			icon_small = reinterpret_cast<HICON>(
					GetClassLongPtrW(parent_window_, GCLP_HICONSM));
		}
		if (icon_big) {
			SendMessageW(splash_window_, WM_SETICON, ICON_BIG,
					reinterpret_cast<LPARAM>(icon_big));
		}
		if (icon_small) {
			SendMessageW(splash_window_, WM_SETICON, ICON_SMALL,
					reinterpret_cast<LPARAM>(icon_small));
		}
	}

	// Show immediately without stealing focus so it is visible before the
	// parent Flutter window is shown.
	ShowWindow(splash_window_, SW_SHOWNOACTIVATE);

	// SW_SHOWNOACTIVATE leaves the title bar in inactive (grayed) state.
	// Force it to redraw as active so it matches the main window.
	if (!config_.borderless) {
		SendMessageW(splash_window_, WM_NCACTIVATE, TRUE, 0);
	}
	return true;
}

void SplashMasterController::DestroySplashWindow() {
	if (splash_window_ != nullptr) {
		KillTimer(splash_window_, kFadeTimerId);
		DestroyWindow(splash_window_);
		splash_window_ = nullptr;
	}
}

void SplashMasterController::Paint(HDC hdc) {
	RECT rect{};
	GetClientRect(splash_window_, &rect);

	const bool dark_mode = IsSystemInDarkMode();
	const COLORREF background = dark_mode && config_.has_dark_color
																	? config_.color_dark
																	: config_.color;

	Gdiplus::Graphics graphics(hdc);
	graphics.SetSmoothingMode(Gdiplus::SmoothingModeHighQuality);
	graphics.Clear(
			Gdiplus::Color(GetRValue(background), GetGValue(background), GetBValue(background)));

	std::wstring splash_path = config_.image_path;
	if (dark_mode && !config_.image_dark_path.empty()) {
		splash_path = config_.image_dark_path;
	} else if (splash_path.empty()) {
		splash_path = config_.image_dark_path;
	}

	if (!splash_path.empty()) {
		Gdiplus::Image splash_image(splash_path.c_str());
		if (splash_image.GetLastStatus() == Gdiplus::Ok) {
			DrawImageWithRect(&graphics, &splash_image, rect, config_.image_fit,
												config_.image_position);
		}
	}

	std::wstring branding_path = config_.branding_image_path;
	if (dark_mode && !config_.branding_image_dark_path.empty()) {
		branding_path = config_.branding_image_dark_path;
	} else if (branding_path.empty()) {
		branding_path = config_.branding_image_dark_path;
	}

	if (!branding_path.empty()) {
		Gdiplus::Image branding_image(branding_path.c_str());
		if (branding_image.GetLastStatus() == Gdiplus::Ok) {
			const auto branding_rect = ComputeBrandingRect(
					&branding_image, rect, config_.branding_position,
					config_.branding_spacing);
			graphics.DrawImage(&branding_image, branding_rect);
		}
	}
}

void SplashMasterController::StartDismissAnimationIfNeeded() {
	if (config_.animation_duration_ms <= 0 || config_.dismiss_animation == L"none") {
		DestroySplashWindow();
		return;
	}

	dismissing_ = true;
	dismiss_elapsed_ms_ = 0;
	RECT splash_rect{};
	GetWindowRect(splash_window_, &splash_rect);
	dismiss_start_pos_.x = splash_rect.left;
	dismiss_start_pos_.y = splash_rect.top;
	SetTimer(splash_window_, kFadeTimerId, kFadeTickMs, nullptr);
}

void SplashMasterController::TickDismissAnimation() {
	if (!dismissing_ || splash_window_ == nullptr) {
		return;
	}

	dismiss_elapsed_ms_ += kFadeTickMs;
	const float progress = std::min(
			1.0f,
			static_cast<float>(dismiss_elapsed_ms_) /
					static_cast<float>(config_.animation_duration_ms));

	if (config_.dismiss_animation == L"fade") {
		alpha_ = static_cast<BYTE>(std::round((1.0f - progress) * 255.0f));
		SetLayeredWindowAttributes(splash_window_, 0, alpha_, LWA_ALPHA);
	} else if (config_.dismiss_animation == L"slideUp" ||
					 config_.dismiss_animation == L"slideDown") {
		RECT splash_rect{};
		GetWindowRect(splash_window_, &splash_rect);
		const int height = splash_rect.bottom - splash_rect.top;
		const int direction = config_.dismiss_animation == L"slideUp" ? -1 : 1;
		const int y_offset = static_cast<int>(std::round(height * progress)) * direction;
		SetWindowPos(
				splash_window_,
				nullptr,
				dismiss_start_pos_.x,
				dismiss_start_pos_.y + y_offset,
				0,
				0,
				SWP_NOSIZE | SWP_NOZORDER | SWP_NOACTIVATE);
	}

	if (progress >= 1.0f) {
		KillTimer(splash_window_, kFadeTimerId);
		DestroySplashWindow();
		dismissing_ = false;
	}
}

void SplashMasterController::ResizeMainWindowIfNeeded() {
	if (parent_window_ == nullptr) {
		return;
	}

	const int target_width = config_.main_window_width;
	const int target_height = config_.main_window_height;
	if (target_width <= 0 || target_height <= 0) {
		return;
	}

	// target_width/height are the full window dimensions (matching how
	// Win32Window::Create uses splash_window_width/height directly as the
	// CreateWindow nWidth/nHeight arguments). Do NOT call AdjustWindowRectEx
	// here, or the resized window will be larger than the splash window.
	MONITORINFO monitor_info{};
	monitor_info.cbSize = sizeof(MONITORINFO);
	const HMONITOR monitor = MonitorFromWindow(parent_window_, MONITOR_DEFAULTTONEAREST);
	GetMonitorInfo(monitor, &monitor_info);

	const int x = monitor_info.rcWork.left +
						((monitor_info.rcWork.right - monitor_info.rcWork.left) -
						 target_width) /
								2;
	const int y = monitor_info.rcWork.top +
						((monitor_info.rcWork.bottom - monitor_info.rcWork.top) -
						 target_height) /
								2;

	SetWindowPos(parent_window_, nullptr, x, y, target_width, target_height,
							 SWP_NOZORDER | SWP_NOACTIVATE | SWP_FRAMECHANGED);
}

LRESULT CALLBACK SplashMasterController::SplashWndProc(
		HWND window,
		UINT const message,
		WPARAM const wparam,
		LPARAM const lparam) noexcept {
	if (message == WM_NCCREATE) {
		auto* window_struct = reinterpret_cast<CREATESTRUCT*>(lparam);
		SetWindowLongPtr(window, GWLP_USERDATA,
										 reinterpret_cast<LONG_PTR>(window_struct->lpCreateParams));
	}

	auto* controller = reinterpret_cast<SplashMasterController*>(
			GetWindowLongPtr(window, GWLP_USERDATA));
	if (controller == nullptr) {
		return DefWindowProc(window, message, wparam, lparam);
	}

	return controller->HandleSplashMessage(window, message, wparam, lparam);
}

LRESULT SplashMasterController::HandleSplashMessage(
		HWND window,
		UINT const message,
		WPARAM const wparam,
		LPARAM const lparam) noexcept {
	switch (message) {
		case WM_PAINT: {
			PAINTSTRUCT ps;
			HDC hdc = BeginPaint(window, &ps);
			Paint(hdc);
			EndPaint(window, &ps);
			return 0;
		}
		case WM_TIMER:
			if (wparam == kFadeTimerId) {
				TickDismissAnimation();
				return 0;
			}
			break;
		case WM_NCACTIVATE:
			// Always draw the title bar in active state regardless of focus,
			// so it matches the active main Flutter window behind it.
			return DefWindowProc(window, message, TRUE, lparam);
		case WM_CLOSE:
			// User closed the splash via the title-bar button. Destroy it cleanly
			// so splash_window_ is not left dangling.
			DestroySplashWindow();
			return 0;
		case WM_ERASEBKGND:
			// Suppress the default white background erase to avoid flicker during
			// the dismiss animation and on resize.
			return 1;
		case WM_SIZE:
			InvalidateRect(window, nullptr, TRUE);
			return 0;
		default:
			break;
	}
	return DefWindowProc(window, message, wparam, lparam);
}

void GetSplashMasterInitialWindowSize(unsigned int* width,
																			unsigned int* height) {
	if (width == nullptr || height == nullptr) {
		return;
	}

	const auto json_path = ResolveRuntimePath(kConfigRelativePath);
	const auto json_content = ReadFileAsString(json_path);
	if (!json_content.has_value()) {
		return;
	}

	if (const auto w = ReadJsonInt(*json_content, "splash_window_width")) {
		*width = static_cast<unsigned int>(std::max(100, *w));
	}
	if (const auto h = ReadJsonInt(*json_content, "splash_window_height")) {
		*height = static_cast<unsigned int>(std::max(100, *h));
	}
}
''';

  static String _applyWindowsDefaultTemplateValues(String template) => template
      .replaceAll(
          '__SPLASH_WINDOW_WIDTH__', '${DesktopStrings.defaultSplashWindowWidth}')
      .replaceAll('__SPLASH_WINDOW_HEIGHT__',
          '${DesktopStrings.defaultSplashWindowHeight}')
      .replaceAll(
          '__MAIN_WINDOW_WIDTH__', '${DesktopStrings.defaultMainWindowWidth}')
      .replaceAll(
          '__MAIN_WINDOW_HEIGHT__', '${DesktopStrings.defaultMainWindowHeight}')
      .replaceAll(
          '__BRANDING_SPACING__', '${DesktopStrings.defaultBrandingSpacing}')
      .replaceAll('__ANIMATION_DURATION_MS__', '$defaultAnimationDurationMs')
      .replaceAll('__BORDERLESS__', '${DesktopStrings.defaultBorderless}')
      .replaceAll('__DISMISS_ANIMATION__', defaultDismissAnimation)
      .replaceAll('__IMAGE_FIT__', '${DesktopStrings.defaultImageFit}')
      .replaceAll(
          '__IMAGE_POSITION__', '${DesktopStrings.defaultImagePosition}')
      .replaceAll(
          '__BRANDING_POSITION__', '${DesktopStrings.defaultBrandingPosition}');
}
