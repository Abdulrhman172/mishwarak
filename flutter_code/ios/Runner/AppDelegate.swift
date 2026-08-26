import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // ═══ مفتاح Google Maps ═══
    // يُقرأ من Info.plist الذي يملؤه ios/Flutter/Secrets.xcconfig
    // (مُستثنى من Git). كان مكتوباً هنا مباشرةً، وهذا الملف متتبَّع —
    // أي أن أول لصق للمفتاح كان سيُسرّبه في تاريخ المستودع.
    //
    // بلا مفتاح لا نستدعي provideAPIKey إطلاقاً: تمريره فارغاً يجعل
    // الحزمة تُسجّل خطأً في كل إقلاع، بينما التطبيق مُعدّ أصلاً لعرض
    // خريطة بديلة عند غيابه (راجع MapView.isAvailable).
    if let key = Bundle.main.object(forInfoDictionaryKey: "GMSApiKey") as? String,
       !key.isEmpty,
       !key.hasPrefix("$(") {
      GMSServices.provideAPIKey(key)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
