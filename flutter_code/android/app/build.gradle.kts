import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// ═══ مفتاح Google Maps ═══
// يُقرأ من android/local.properties وهو ملف مُستثنى من Git، فلا يُرفع
// المفتاح مع الكود. كان مكتوباً مباشرةً في AndroidManifest.xml — وهو
// ملف متتبَّع، أي أن أول لصق للمفتاح كان سيُسرّبه في تاريخ المستودع.
//
// أضف السطر التالي إلى android/local.properties:
//   MAPS_API_KEY=AIza...
//
// القيمة الافتراضية فارغة عمداً: البناء ينجح بلا مفتاح وتظهر الخريطة
// البديلة، بدل أن يفشل البناء على جهاز لم يُعدّ بعد.
val mapsApiKey: String = Properties().apply {
    val file = rootProject.file("local.properties")
    if (file.exists()) file.inputStream().use { load(it) }
}.getProperty("MAPS_API_KEY") ?: ""

android {
    namespace = "com.mishwarak.mishwarak"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.mishwarak.mishwarak"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // يملأ ${MAPS_API_KEY} في AndroidManifest.xml وقت البناء.
        manifestPlaceholders["MAPS_API_KEY"] = mapsApiKey
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
