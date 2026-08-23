// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class L10nAr extends L10n {
  L10nAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'مِشوارَك';

  @override
  String get appTagline => 'توصيل ركاب في اليمن';

  @override
  String get currency => 'ر.ي';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get next => 'التالي';

  @override
  String get skip => 'تخطي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get add => 'إضافة';

  @override
  String get notAddedYet => 'لم يُضف بعد';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get retryLater => 'حاول مرة أخرى.';

  @override
  String get onboardTitle1 => 'اطلب مشوارك بضغطة زر';

  @override
  String get onboardBody1 => 'سائقون موثوقون في عدن حول الساعة، جاهزون لخدمتك';

  @override
  String get onboardTitle2 => 'أسعار شفافة قبل الرحلة';

  @override
  String get onboardBody2 => 'اعرف السعر قبل تأكيد الطلب. بدون مفاجآت.';

  @override
  String get onboardTitle3 => 'أمانك أولويتنا';

  @override
  String get onboardBody3 =>
      'شارك رحلتك مع عائلتك، وزر SOS للطوارئ، وخيار سائقة للنساء';

  @override
  String get onboardStart => 'يلا نبدأ';

  @override
  String get welcome => 'أهلاً بك 👋';

  @override
  String get loginPrompt => 'أدخل رقم جوالك لإرسال رمز التحقق';

  @override
  String get sendOtp => 'إرسال رمز التحقق';

  @override
  String get termsNotice =>
      'بمتابعتك أنت توافق على شروط الاستخدام وسياسة الخصوصية';

  @override
  String get sendOtpFailed => 'تعذّر إرسال رمز التحقق. حاول مرة أخرى.';

  @override
  String get otpTitle => 'رمز التحقق';

  @override
  String get otpEnter => 'أدخل الرمز';

  @override
  String get otpSentTo => 'تم إرسال رمز مكوّن من 6 أرقام إلى ';

  @override
  String get otpInvalid => 'رمز التحقق غير صحيح. حاول مرة أخرى.';

  @override
  String get otpResend => 'إعادة إرسال الرمز';

  @override
  String get otpResendFailed => 'تعذّر إعادة إرسال الرمز.';

  @override
  String otpResendIn(int seconds) {
    return 'إعادة الإرسال بعد $seconds ثانية';
  }

  @override
  String greeting(String name) {
    return 'مرحباً، $name 👋';
  }

  @override
  String get whereTo => 'إلى أين تريد أن تذهب اليوم؟';

  @override
  String get locating => 'جارٍ تحديد موقعك...';

  @override
  String get searchHint => 'ابحث عن وجهتك...';

  @override
  String get bookNow => 'احجز الآن';

  @override
  String get newPlace => 'مكان جديد';

  @override
  String get myLocation => 'موقعي';

  @override
  String get emergencyTitle => 'حالة طوارئ؟';

  @override
  String get emergencyBody =>
      'سيتم إرسال موقعك للسلطات وجهات الطوارئ المحفوظة.';

  @override
  String get emergencyAction => 'طلب المساعدة';

  @override
  String get chooseDestination => 'اختر وجهتك';

  @override
  String get destinationHint => 'إلى أين؟';

  @override
  String get useAsDestination => 'استخدام هذا النص كوجهة';

  @override
  String get savedPlaces => 'العناوين المحفوظة';

  @override
  String get noSavedPlaces => 'لا توجد عناوين محفوظة بعد';

  @override
  String get savedPlacesFailed => 'تعذّر جلب العناوين';

  @override
  String get recentDestinations => 'الوجهات الأخيرة';

  @override
  String get noRecentTrips => 'لا توجد رحلات سابقة';

  @override
  String get historyFailed => 'تعذّر جلب السجل';

  @override
  String get chooseVehicle => 'اختر مركبتك';

  @override
  String get loadingOptions => 'جارٍ تحميل الخيارات...';

  @override
  String optionsCount(int count) {
    return '$count خيارات متاحة';
  }

  @override
  String optionsWithDistance(int count, String km) {
    return '$count خيارات · $km كم';
  }

  @override
  String get wallet => 'محفظة';

  @override
  String get cash => 'نقدي';

  @override
  String get coupon => 'كوبون';

  @override
  String get schedule => 'حجز مسبق';

  @override
  String get serviceEconomy => 'اقتصادي';

  @override
  String get serviceVip => 'VIP';

  @override
  String get serviceWomen => 'نساء';

  @override
  String orderVehicle(String name) {
    return 'اطلب $name';
  }

  @override
  String get requestFailed => 'تعذّر إنشاء الطلب. حاول مرة أخرى.';

  @override
  String get findingDriver => 'نبحث لك عن أفضل سائق...';

  @override
  String get findingDriverBody => 'لحظات وسنجد لك أقرب سائق متاح';

  @override
  String get noDriverTitle => 'لا يوجد سائق متاح الآن';

  @override
  String get noDriverBody => 'جرّب نوع مركبة آخر أو أعد المحاولة بعد قليل';

  @override
  String get cancelRequest => 'إلغاء الطلب';

  @override
  String get cancelledByRider => 'ألغاها الراكب';

  @override
  String get statusAssigned => 'تم تعيين سائق لك';

  @override
  String get statusArriving => 'السائق في الطريق إليك';

  @override
  String get statusArrived => 'السائق وصل — بانتظارك';

  @override
  String get statusOnTrip => 'في الطريق إلى وجهتك';

  @override
  String get statusCompleted => 'انتهت الرحلة';

  @override
  String get statusCancelled => 'أُلغيت الرحلة';

  @override
  String get statusRequested => 'جارٍ تعيين سائق...';

  @override
  String get loadingDriver => 'جارٍ جلب بيانات السائق...';

  @override
  String get tripShared => 'تمت مشاركة رحلتك';

  @override
  String get emergencyNotified => 'تم إبلاغ جهات الطوارئ';

  @override
  String get chatComingSoon => 'المحادثة قيد الإنشاء';

  @override
  String callingDriver(String name) {
    return 'جارِ الاتصال بـ $name';
  }

  @override
  String get fare => 'السعر';

  @override
  String driverTripsCount(int count) {
    return '· $count رحلة';
  }

  @override
  String get tripDone => 'وصلت بسلامة!';

  @override
  String get tripDoneBody => 'نتمنى لك يوماً سعيداً 🌟';

  @override
  String get tripFare => 'أجرة الرحلة';

  @override
  String get tip => 'إكرامية';

  @override
  String get total => 'الإجمالي';

  @override
  String get driver => 'السائق';

  @override
  String rateQuestion(String name) {
    return 'كيف كانت رحلتك مع $name؟';
  }

  @override
  String get whatYouLiked => 'ما الذي أعجبك؟';

  @override
  String get whatWentWrong => 'ما الذي أزعجك؟';

  @override
  String get addTip => 'أضف إكرامية للسائق';

  @override
  String get noTip => 'لا شكراً';

  @override
  String get submitRating => 'إرسال التقييم';

  @override
  String ratingSent(int stars) {
    return 'شكراً لك! تم إرسال تقييمك ($stars نجوم)';
  }

  @override
  String get ratingFailed => 'تعذّر إرسال التقييم. حاول مرة أخرى.';

  @override
  String ratingSentTipSuffix(String amount, String currency) {
    return ' مع إكرامية $amount $currency';
  }

  @override
  String get tagSafeDriving => 'قيادة آمنة';

  @override
  String get tagCleanCar => 'سيارة نظيفة';

  @override
  String get tagFriendly => 'كلام لطيف';

  @override
  String get tagOnTime => 'في الموعد';

  @override
  String get tagFastRoute => 'طريق سريع';

  @override
  String get tagGoodMusic => 'موسيقى جيدة';

  @override
  String get tagReckless => 'قيادة متهورة';

  @override
  String get tagDirtyCar => 'سيارة متسخة';

  @override
  String get tagRude => 'غير مهذب';

  @override
  String get tagVeryLate => 'تأخر كثيراً';

  @override
  String get walletTitle => 'المحفظة';

  @override
  String get history => 'السجل';

  @override
  String get currentBalance => 'الرصيد الحالي';

  @override
  String get topUp => 'شحن الرصيد';

  @override
  String get topUpComingSoon => 'شحن الرصيد قيد الإنشاء';

  @override
  String get transfer => 'تحويل';

  @override
  String get transferComingSoon => 'التحويل قيد الإنشاء';

  @override
  String get paymentMethods => 'طرق الدفع';

  @override
  String get recentTransactions => 'آخر المعاملات';

  @override
  String get transactionsFailed => 'تعذّر جلب المعاملات';

  @override
  String get noTransactions => 'لا توجد معاملات بعد';

  @override
  String get addCard => 'إضافة بطاقة';

  @override
  String get defaultLabel => 'الافتراضي';

  @override
  String get myTrips => 'رحلاتي';

  @override
  String get tripsFailed => 'تعذّر جلب سجل الرحلات';

  @override
  String get tripsCount => 'رحلات';

  @override
  String get totalSpent => 'إجمالي الإنفاق';

  @override
  String get avgRating => 'متوسط التقييم';

  @override
  String get noTripsYet => 'لم تقم بأي رحلة بعد';

  @override
  String get cancelledTrip => 'ملغاة';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get defaultUserName => 'مستخدم مِشوارَك';

  @override
  String get yourPoints => 'نقاطك المتاحة';

  @override
  String get points => 'نقطة';

  @override
  String get goldReached => 'وصلت للمستوى الذهبي 🎉';

  @override
  String pointsToGold(String count) {
    return '$count نقطة لمستوى ذهبي';
  }

  @override
  String memberSince(int year) {
    return '· عضو منذ $year';
  }

  @override
  String get personalInfo => 'المعلومات الشخصية';

  @override
  String get name => 'الاسم';

  @override
  String get phone => 'الجوال';

  @override
  String get email => 'البريد';

  @override
  String get addAddress => 'إضافة عنوان';

  @override
  String get emergencyContacts => 'جهات الطوارئ';

  @override
  String get addContact => 'إضافة جهة اتصال';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get markAllRead => 'تحديد الكل مقروء';

  @override
  String get notificationsFailed => 'تعذّر جلب الإشعارات';

  @override
  String get noNotifications => 'لا توجد إشعارات';

  @override
  String get locationServiceDisabled =>
      'خدمة الموقع مغلقة. فعّلها من إعدادات الجهاز.';

  @override
  String get locationDenied => 'نحتاج إذن الموقع لتحديد نقطة انطلاقك.';

  @override
  String get locationDeniedForever =>
      'إذن الموقع مرفوض نهائياً. افتح الإعدادات واسمح بالوصول.';

  @override
  String get locationFailed => 'تعذّر تحديد موقعك. حاول مرة أخرى.';
}
