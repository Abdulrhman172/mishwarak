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

  @override
  String get menuWalletBalance => 'رصيد المحفظة';

  @override
  String get menuTopUp => 'شحن';

  @override
  String get menuPromos => 'الكوبونات';

  @override
  String get menuRewards => 'نظام النقاط';

  @override
  String get menuRewardsBadge => 'جديد';

  @override
  String get menuVip => 'اشتراك VIP';

  @override
  String get menuHelp => 'المساعدة';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get signOutConfirm => 'هل تريد تسجيل الخروج من حسابك؟';

  @override
  String comingSoon(String feature) {
    return '$feature قيد الإنشاء';
  }

  @override
  String get save => 'حفظ';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get remove => 'إزالة';

  @override
  String get close => 'إغلاق';

  @override
  String get apply => 'تطبيق';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get saved => 'تم الحفظ';

  @override
  String get saveFailed => 'تعذّر الحفظ. حاول مرة أخرى.';

  @override
  String get deleteFailed => 'تعذّر الحذف. حاول مرة أخرى.';

  @override
  String get signInRequired => 'سجّل الدخول أولاً.';

  @override
  String get dateToday => 'اليوم';

  @override
  String get dateYesterday => 'أمس';

  @override
  String get relativeNow => 'الآن';

  @override
  String relativeMinutes(int count) {
    return 'قبل $count دقيقة';
  }

  @override
  String relativeHours(int count) {
    return 'قبل $count ساعة';
  }

  @override
  String relativeDays(int count) {
    return 'قبل $count يوم';
  }

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsLanguageArabic => 'العربية';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsAppearance => 'المظهر';

  @override
  String get settingsThemeSystem => 'حسب النظام';

  @override
  String get settingsThemeLight => 'فاتح';

  @override
  String get settingsThemeDark => 'داكن';

  @override
  String get settingsAbout => 'عن التطبيق';

  @override
  String get settingsVersion => 'الإصدار';

  @override
  String get settingsDiagnostics => 'حالة الخدمات';

  @override
  String get settingsBackendOn => 'قاعدة البيانات: متصلة';

  @override
  String get settingsBackendOff => 'قاعدة البيانات: غير مهيّأة';

  @override
  String get settingsMapsOn => 'الخرائط: مفعّلة';

  @override
  String get settingsMapsOff => 'الخرائط: بديلة';

  @override
  String get settingsTerms => 'شروط الاستخدام';

  @override
  String get settingsPrivacy => 'سياسة الخصوصية';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get fullNameLabel => 'الاسم الكامل';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get emailInvalid => 'بريد إلكتروني غير صالح';

  @override
  String get phoneNotEditable =>
      'رقم الجوال هو وسيلة الدخول ولا يمكن تغييره هنا.';

  @override
  String get addPlaceTitle => 'عنوان جديد';

  @override
  String get editPlaceTitle => 'تعديل العنوان';

  @override
  String get placeNameLabel => 'اسم المكان';

  @override
  String get placeAddressLabel => 'العنوان';

  @override
  String get placeKindHome => 'المنزل';

  @override
  String get placeKindWork => 'العمل';

  @override
  String get placeKindOther => 'آخر';

  @override
  String deletePlaceConfirm(String name) {
    return 'حذف \"$name\" من عناوينك المحفوظة؟';
  }

  @override
  String get addContactTitle => 'جهة اتصال للطوارئ';

  @override
  String get editContactTitle => 'تعديل جهة الاتصال';

  @override
  String get contactNameLabel => 'الاسم';

  @override
  String get contactPhoneLabel => 'رقم الجوال';

  @override
  String get phoneInvalid => 'رقم جوال غير صالح';

  @override
  String deleteContactConfirm(String name) {
    return 'حذف \"$name\" من جهات الطوارئ؟';
  }

  @override
  String get promosTitle => 'الكوبونات والعروض';

  @override
  String get promoCodeLabel => 'رمز الكوبون';

  @override
  String promoApplied(String amount, String currency) {
    return 'طُبِّق الكوبون — خصم $amount $currency';
  }

  @override
  String get promoNotFound => 'رمز الكوبون غير موجود.';

  @override
  String get promoExpired => 'انتهت صلاحية هذا الكوبون.';

  @override
  String get promoNotStarted => 'هذا الكوبون لم يبدأ بعد.';

  @override
  String get promoExhausted => 'استُنفد هذا الكوبون.';

  @override
  String get promoAlreadyUsed => 'استخدمت هذا الكوبون من قبل.';

  @override
  String get promoRideClosed => 'لا يمكن تطبيق كوبون على رحلة منتهية.';

  @override
  String get promoFailed => 'تعذّر التحقّق من الكوبون. حاول مرة أخرى.';

  @override
  String get promoNone => 'لا توجد عروض متاحة حالياً.';

  @override
  String promoValidUntil(String date) {
    return 'صالح حتى $date';
  }

  @override
  String promoOffPercent(int percent) {
    return 'خصم $percent%';
  }

  @override
  String promoOffAmount(String amount, String currency) {
    return 'خصم $amount $currency';
  }

  @override
  String get promoCopy => 'نسخ الرمز';

  @override
  String promoCopied(String code) {
    return 'نُسخ الرمز $code';
  }

  @override
  String get promoRemoved => 'أُزيل الكوبون';

  @override
  String get discount => 'الخصم';

  @override
  String get totalAfterDiscount => 'الإجمالي بعد الخصم';

  @override
  String get rewardsTitle => 'نظام النقاط';

  @override
  String get rewardsIntro => 'تكسب نقطة عن كل 100 ريال تدفعها في رحلاتك.';

  @override
  String get rewardsBalance => 'رصيدك الحالي';

  @override
  String get rewardsTierSilver => 'فضّي';

  @override
  String get rewardsTierGold => 'ذهبي';

  @override
  String get rewardsTierPlatinum => 'بلاتيني';

  @override
  String rewardsTierAt(String points) {
    return 'عند $points نقطة';
  }

  @override
  String get rewardsPerkFreeRide => 'رحلة مجانية كل 5000 نقطة';

  @override
  String get rewardsPerkPriority => 'أولوية في إيجاد السائق';

  @override
  String get rewardsPerkSupport => 'دعم مخصّص على مدار الساعة';

  @override
  String rewardsCurrentTier(String tier) {
    return 'مستواك الحالي: $tier';
  }

  @override
  String get vipTitle => 'اشتراك VIP';

  @override
  String get vipIntro => 'مزايا إضافية لركّاب مِشوارَك الدائمين.';

  @override
  String get vipPerkDiscount => 'خصم دائم 10% على كل رحلة';

  @override
  String get vipPerkCars => 'سيارات الفئة المريحة بسعر الاقتصادي';

  @override
  String get vipPerkCancel => 'إلغاء مجاني بلا رسوم';

  @override
  String get vipNotAvailable =>
      'الاشتراك غير متاح في منطقتك بعد. سنُعلمك فور إطلاقه.';

  @override
  String get notifyMe => 'أعلمني عند الإطلاق';

  @override
  String get notifyMeDone => 'سنُعلمك فور توفّر الميزة.';

  @override
  String get helpTitle => 'المساعدة';

  @override
  String get helpFaqTitle => 'أسئلة شائعة';

  @override
  String get helpContactTitle => 'تواصل معنا';

  @override
  String get helpCall => 'اتصال بالدعم';

  @override
  String get helpWhatsapp => 'واتساب';

  @override
  String get helpEmail => 'البريد الإلكتروني';

  @override
  String get helpQ1 => 'كيف أطلب رحلة؟';

  @override
  String get helpA1 =>
      'من الشاشة الرئيسية اختر وجهتك، ثم نوع المركبة، ثم اضغط زر الطلب. سيُعيَّن أقرب سائق متاح تلقائياً.';

  @override
  String get helpQ2 => 'كيف أدفع؟';

  @override
  String get helpA2 =>
      'يمكنك الدفع من رصيد المحفظة أو نقداً للسائق عند نهاية الرحلة. تختار الطريقة قبل تأكيد الطلب.';

  @override
  String get helpQ3 => 'كيف ألغي رحلة؟';

  @override
  String get helpA3 =>
      'اضغط \"إلغاء الطلب\" أثناء البحث عن سائق، أو زر الإلغاء في شاشة الرحلة قبل بدايتها.';

  @override
  String get helpQ4 => 'ماذا يفعل زر الطوارئ؟';

  @override
  String get helpA4 =>
      'يفتح اتصالاً مباشراً بالطوارئ، أو يرسل رسالة بموقعك الحالي إلى جهات الطوارئ التي أضفتها في ملفك الشخصي.';

  @override
  String get helpQ5 => 'كيف أستخدم كوبون خصم؟';

  @override
  String get helpA5 =>
      'من شاشة اختيار المركبة اضغط \"كوبون\" وأدخل الرمز قبل تأكيد الطلب.';

  @override
  String emergencyCallPolice(String number) {
    return 'اتصال بالطوارئ ($number)';
  }

  @override
  String get emergencyNotifyContacts => 'إرسال موقعي لجهات الطوارئ';

  @override
  String get emergencyNoContacts => 'لم تُضف جهات طوارئ بعد.';

  @override
  String get emergencyAddContact => 'إضافة جهة اتصال';

  @override
  String emergencySmsBody(String url) {
    return 'أحتاج مساعدة. موقعي الحالي: $url';
  }

  @override
  String get emergencySmsNoLocation => 'أحتاج مساعدة. لم يتوفّر موقعي الحالي.';

  @override
  String get emergencyOpenFailed => 'تعذّر فتح تطبيق الاتصال على هذا الجهاز.';

  @override
  String get callDriverFailed => 'تعذّر بدء الاتصال بالسائق.';

  @override
  String shareTripText(String driver, String car, String plate) {
    return 'أنا في رحلة مع $driver · سيارة $car · لوحة $plate';
  }

  @override
  String get shareTripCopied => 'نُسخت تفاصيل الرحلة — أرسلها لمن تثق به.';

  @override
  String get cancelRide => 'إلغاء الرحلة';

  @override
  String get cancelRideConfirm =>
      'إلغاء هذه الرحلة؟ قد تُطبَّق رسوم إلغاء إذا كان السائق في طريقه إليك.';

  @override
  String get cancelRideFailed => 'تعذّر إلغاء الرحلة. حاول مرة أخرى.';

  @override
  String get keepRide => 'متابعة الرحلة';

  @override
  String vehicleEta(int minutes) {
    return '$minutes دقائق';
  }

  @override
  String get rateThisTrip => 'قيّم هذه الرحلة';

  @override
  String get tripRated => 'مُقيَّمة';

  @override
  String get noPaymentMethods => 'لم تُضف طريقة دفع بعد.';

  @override
  String get paymentSetDefault => 'جعله الافتراضي';

  @override
  String get paymentRemove => 'إزالة البطاقة';

  @override
  String get paymentRemoveConfirm => 'إزالة هذه البطاقة من حسابك؟';

  @override
  String get paymentDefaultSet => 'أصبحت الطريقة الافتراضية';

  @override
  String get searchingPlaces => 'جارٍ البحث...';

  @override
  String get searchNoResults => 'لا توجد نتائج لهذا البحث.';

  @override
  String get searchFailed => 'تعذّر البحث عن العنوان.';

  @override
  String get searchOnWebUnsupported =>
      'البحث الجغرافي غير متاح على المتصفّح — اختر من العناوين المحفوظة أو الأخيرة.';

  @override
  String get destinationNeedsLocation =>
      'لم نتمكن من تحديد إحداثيات هذه الوجهة، لذا الأجرة تقديرية.';

  @override
  String get notifRideCompleted => 'اكتملت رحلتك';

  @override
  String get notifPromo => 'عرض جديد';

  @override
  String get notifPoints => 'نقاط جديدة';

  @override
  String get notifRating => 'قيّم رحلتك';

  @override
  String notifRoute(String from, String to) {
    return '$from ← $to';
  }

  @override
  String get serviceSchedulePrompt =>
      'الحجز المسبق قادم قريباً — يمكنك الطلب الآن مباشرة.';

  @override
  String get profileUpdated => 'حُدِّث ملفك الشخصي';

  @override
  String get placeSaved => 'حُفظ العنوان';

  @override
  String get placeDeleted => 'حُذف العنوان';

  @override
  String get contactSaved => 'حُفظت جهة الاتصال';

  @override
  String get contactDeleted => 'حُذفت جهة الاتصال';
}
