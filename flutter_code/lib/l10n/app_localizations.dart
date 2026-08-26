import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'مِشوارَك'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In ar, this message translates to:
  /// **'توصيل ركاب في اليمن'**
  String get appTagline;

  /// No description provided for @currency.
  ///
  /// In ar, this message translates to:
  /// **'ر.ي'**
  String get currency;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get confirm;

  /// No description provided for @next.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In ar, this message translates to:
  /// **'تخطي'**
  String get skip;

  /// No description provided for @settings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settings;

  /// No description provided for @add.
  ///
  /// In ar, this message translates to:
  /// **'إضافة'**
  String get add;

  /// No description provided for @notAddedYet.
  ///
  /// In ar, this message translates to:
  /// **'لم يُضف بعد'**
  String get notAddedYet;

  /// No description provided for @loading.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ التحميل...'**
  String get loading;

  /// No description provided for @retryLater.
  ///
  /// In ar, this message translates to:
  /// **'حاول مرة أخرى.'**
  String get retryLater;

  /// No description provided for @onboardTitle1.
  ///
  /// In ar, this message translates to:
  /// **'اطلب مشوارك بضغطة زر'**
  String get onboardTitle1;

  /// No description provided for @onboardBody1.
  ///
  /// In ar, this message translates to:
  /// **'سائقون موثوقون في عدن حول الساعة، جاهزون لخدمتك'**
  String get onboardBody1;

  /// No description provided for @onboardTitle2.
  ///
  /// In ar, this message translates to:
  /// **'أسعار شفافة قبل الرحلة'**
  String get onboardTitle2;

  /// No description provided for @onboardBody2.
  ///
  /// In ar, this message translates to:
  /// **'اعرف السعر قبل تأكيد الطلب. بدون مفاجآت.'**
  String get onboardBody2;

  /// No description provided for @onboardTitle3.
  ///
  /// In ar, this message translates to:
  /// **'أمانك أولويتنا'**
  String get onboardTitle3;

  /// No description provided for @onboardBody3.
  ///
  /// In ar, this message translates to:
  /// **'شارك رحلتك مع عائلتك، وزر SOS للطوارئ، وخيار سائقة للنساء'**
  String get onboardBody3;

  /// No description provided for @onboardStart.
  ///
  /// In ar, this message translates to:
  /// **'يلا نبدأ'**
  String get onboardStart;

  /// No description provided for @welcome.
  ///
  /// In ar, this message translates to:
  /// **'أهلاً بك 👋'**
  String get welcome;

  /// No description provided for @loginPrompt.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم جوالك لإرسال رمز التحقق'**
  String get loginPrompt;

  /// No description provided for @sendOtp.
  ///
  /// In ar, this message translates to:
  /// **'إرسال رمز التحقق'**
  String get sendOtp;

  /// No description provided for @termsNotice.
  ///
  /// In ar, this message translates to:
  /// **'بمتابعتك أنت توافق على شروط الاستخدام وسياسة الخصوصية'**
  String get termsNotice;

  /// No description provided for @sendOtpFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر إرسال رمز التحقق. حاول مرة أخرى.'**
  String get sendOtpFailed;

  /// No description provided for @otpTitle.
  ///
  /// In ar, this message translates to:
  /// **'رمز التحقق'**
  String get otpTitle;

  /// No description provided for @otpEnter.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الرمز'**
  String get otpEnter;

  /// No description provided for @otpSentTo.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال رمز مكوّن من 6 أرقام إلى '**
  String get otpSentTo;

  /// No description provided for @otpInvalid.
  ///
  /// In ar, this message translates to:
  /// **'رمز التحقق غير صحيح. حاول مرة أخرى.'**
  String get otpInvalid;

  /// No description provided for @otpResend.
  ///
  /// In ar, this message translates to:
  /// **'إعادة إرسال الرمز'**
  String get otpResend;

  /// No description provided for @otpResendFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر إعادة إرسال الرمز.'**
  String get otpResendFailed;

  /// No description provided for @otpResendIn.
  ///
  /// In ar, this message translates to:
  /// **'إعادة الإرسال بعد {seconds} ثانية'**
  String otpResendIn(int seconds);

  /// No description provided for @greeting.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً، {name} 👋'**
  String greeting(String name);

  /// No description provided for @whereTo.
  ///
  /// In ar, this message translates to:
  /// **'إلى أين تريد أن تذهب اليوم؟'**
  String get whereTo;

  /// No description provided for @locating.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ تحديد موقعك...'**
  String get locating;

  /// No description provided for @searchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن وجهتك...'**
  String get searchHint;

  /// No description provided for @bookNow.
  ///
  /// In ar, this message translates to:
  /// **'احجز الآن'**
  String get bookNow;

  /// No description provided for @newPlace.
  ///
  /// In ar, this message translates to:
  /// **'مكان جديد'**
  String get newPlace;

  /// No description provided for @myLocation.
  ///
  /// In ar, this message translates to:
  /// **'موقعي'**
  String get myLocation;

  /// No description provided for @emergencyTitle.
  ///
  /// In ar, this message translates to:
  /// **'حالة طوارئ؟'**
  String get emergencyTitle;

  /// No description provided for @emergencyBody.
  ///
  /// In ar, this message translates to:
  /// **'سيتم إرسال موقعك للسلطات وجهات الطوارئ المحفوظة.'**
  String get emergencyBody;

  /// No description provided for @emergencyAction.
  ///
  /// In ar, this message translates to:
  /// **'طلب المساعدة'**
  String get emergencyAction;

  /// No description provided for @chooseDestination.
  ///
  /// In ar, this message translates to:
  /// **'اختر وجهتك'**
  String get chooseDestination;

  /// No description provided for @destinationHint.
  ///
  /// In ar, this message translates to:
  /// **'إلى أين؟'**
  String get destinationHint;

  /// No description provided for @useAsDestination.
  ///
  /// In ar, this message translates to:
  /// **'استخدام هذا النص كوجهة'**
  String get useAsDestination;

  /// No description provided for @savedPlaces.
  ///
  /// In ar, this message translates to:
  /// **'العناوين المحفوظة'**
  String get savedPlaces;

  /// No description provided for @noSavedPlaces.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد عناوين محفوظة بعد'**
  String get noSavedPlaces;

  /// No description provided for @savedPlacesFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر جلب العناوين'**
  String get savedPlacesFailed;

  /// No description provided for @recentDestinations.
  ///
  /// In ar, this message translates to:
  /// **'الوجهات الأخيرة'**
  String get recentDestinations;

  /// No description provided for @noRecentTrips.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد رحلات سابقة'**
  String get noRecentTrips;

  /// No description provided for @historyFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر جلب السجل'**
  String get historyFailed;

  /// No description provided for @chooseVehicle.
  ///
  /// In ar, this message translates to:
  /// **'اختر مركبتك'**
  String get chooseVehicle;

  /// No description provided for @loadingOptions.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ تحميل الخيارات...'**
  String get loadingOptions;

  /// No description provided for @optionsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} خيارات متاحة'**
  String optionsCount(int count);

  /// No description provided for @optionsWithDistance.
  ///
  /// In ar, this message translates to:
  /// **'{count} خيارات · {km} كم'**
  String optionsWithDistance(int count, String km);

  /// No description provided for @wallet.
  ///
  /// In ar, this message translates to:
  /// **'محفظة'**
  String get wallet;

  /// No description provided for @cash.
  ///
  /// In ar, this message translates to:
  /// **'نقدي'**
  String get cash;

  /// No description provided for @coupon.
  ///
  /// In ar, this message translates to:
  /// **'كوبون'**
  String get coupon;

  /// No description provided for @schedule.
  ///
  /// In ar, this message translates to:
  /// **'حجز مسبق'**
  String get schedule;

  /// No description provided for @serviceEconomy.
  ///
  /// In ar, this message translates to:
  /// **'اقتصادي'**
  String get serviceEconomy;

  /// No description provided for @serviceVip.
  ///
  /// In ar, this message translates to:
  /// **'VIP'**
  String get serviceVip;

  /// No description provided for @serviceWomen.
  ///
  /// In ar, this message translates to:
  /// **'نساء'**
  String get serviceWomen;

  /// No description provided for @orderVehicle.
  ///
  /// In ar, this message translates to:
  /// **'اطلب {name}'**
  String orderVehicle(String name);

  /// No description provided for @requestFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر إنشاء الطلب. حاول مرة أخرى.'**
  String get requestFailed;

  /// No description provided for @findingDriver.
  ///
  /// In ar, this message translates to:
  /// **'نبحث لك عن أفضل سائق...'**
  String get findingDriver;

  /// No description provided for @findingDriverBody.
  ///
  /// In ar, this message translates to:
  /// **'لحظات وسنجد لك أقرب سائق متاح'**
  String get findingDriverBody;

  /// No description provided for @noDriverTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد سائق متاح الآن'**
  String get noDriverTitle;

  /// No description provided for @noDriverBody.
  ///
  /// In ar, this message translates to:
  /// **'جرّب نوع مركبة آخر أو أعد المحاولة بعد قليل'**
  String get noDriverBody;

  /// No description provided for @cancelRequest.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الطلب'**
  String get cancelRequest;

  /// No description provided for @cancelledByRider.
  ///
  /// In ar, this message translates to:
  /// **'ألغاها الراكب'**
  String get cancelledByRider;

  /// No description provided for @statusAssigned.
  ///
  /// In ar, this message translates to:
  /// **'تم تعيين سائق لك'**
  String get statusAssigned;

  /// No description provided for @statusArriving.
  ///
  /// In ar, this message translates to:
  /// **'السائق في الطريق إليك'**
  String get statusArriving;

  /// No description provided for @statusArrived.
  ///
  /// In ar, this message translates to:
  /// **'السائق وصل — بانتظارك'**
  String get statusArrived;

  /// No description provided for @statusOnTrip.
  ///
  /// In ar, this message translates to:
  /// **'في الطريق إلى وجهتك'**
  String get statusOnTrip;

  /// No description provided for @statusCompleted.
  ///
  /// In ar, this message translates to:
  /// **'انتهت الرحلة'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In ar, this message translates to:
  /// **'أُلغيت الرحلة'**
  String get statusCancelled;

  /// No description provided for @statusRequested.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ تعيين سائق...'**
  String get statusRequested;

  /// No description provided for @loadingDriver.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ جلب بيانات السائق...'**
  String get loadingDriver;

  /// No description provided for @tripShared.
  ///
  /// In ar, this message translates to:
  /// **'تمت مشاركة رحلتك'**
  String get tripShared;

  /// No description provided for @emergencyNotified.
  ///
  /// In ar, this message translates to:
  /// **'تم إبلاغ جهات الطوارئ'**
  String get emergencyNotified;

  /// No description provided for @chatComingSoon.
  ///
  /// In ar, this message translates to:
  /// **'المحادثة قيد الإنشاء'**
  String get chatComingSoon;

  /// No description provided for @callingDriver.
  ///
  /// In ar, this message translates to:
  /// **'جارِ الاتصال بـ {name}'**
  String callingDriver(String name);

  /// No description provided for @fare.
  ///
  /// In ar, this message translates to:
  /// **'السعر'**
  String get fare;

  /// No description provided for @driverTripsCount.
  ///
  /// In ar, this message translates to:
  /// **'· {count} رحلة'**
  String driverTripsCount(int count);

  /// No description provided for @tripDone.
  ///
  /// In ar, this message translates to:
  /// **'وصلت بسلامة!'**
  String get tripDone;

  /// No description provided for @tripDoneBody.
  ///
  /// In ar, this message translates to:
  /// **'نتمنى لك يوماً سعيداً 🌟'**
  String get tripDoneBody;

  /// No description provided for @tripFare.
  ///
  /// In ar, this message translates to:
  /// **'أجرة الرحلة'**
  String get tripFare;

  /// No description provided for @tip.
  ///
  /// In ar, this message translates to:
  /// **'إكرامية'**
  String get tip;

  /// No description provided for @total.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي'**
  String get total;

  /// No description provided for @driver.
  ///
  /// In ar, this message translates to:
  /// **'السائق'**
  String get driver;

  /// No description provided for @rateQuestion.
  ///
  /// In ar, this message translates to:
  /// **'كيف كانت رحلتك مع {name}؟'**
  String rateQuestion(String name);

  /// No description provided for @whatYouLiked.
  ///
  /// In ar, this message translates to:
  /// **'ما الذي أعجبك؟'**
  String get whatYouLiked;

  /// No description provided for @whatWentWrong.
  ///
  /// In ar, this message translates to:
  /// **'ما الذي أزعجك؟'**
  String get whatWentWrong;

  /// No description provided for @addTip.
  ///
  /// In ar, this message translates to:
  /// **'أضف إكرامية للسائق'**
  String get addTip;

  /// No description provided for @noTip.
  ///
  /// In ar, this message translates to:
  /// **'لا شكراً'**
  String get noTip;

  /// No description provided for @submitRating.
  ///
  /// In ar, this message translates to:
  /// **'إرسال التقييم'**
  String get submitRating;

  /// No description provided for @ratingSent.
  ///
  /// In ar, this message translates to:
  /// **'شكراً لك! تم إرسال تقييمك ({stars} نجوم)'**
  String ratingSent(int stars);

  /// No description provided for @ratingFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر إرسال التقييم. حاول مرة أخرى.'**
  String get ratingFailed;

  /// No description provided for @ratingSentTipSuffix.
  ///
  /// In ar, this message translates to:
  /// **' مع إكرامية {amount} {currency}'**
  String ratingSentTipSuffix(String amount, String currency);

  /// No description provided for @tagSafeDriving.
  ///
  /// In ar, this message translates to:
  /// **'قيادة آمنة'**
  String get tagSafeDriving;

  /// No description provided for @tagCleanCar.
  ///
  /// In ar, this message translates to:
  /// **'سيارة نظيفة'**
  String get tagCleanCar;

  /// No description provided for @tagFriendly.
  ///
  /// In ar, this message translates to:
  /// **'كلام لطيف'**
  String get tagFriendly;

  /// No description provided for @tagOnTime.
  ///
  /// In ar, this message translates to:
  /// **'في الموعد'**
  String get tagOnTime;

  /// No description provided for @tagFastRoute.
  ///
  /// In ar, this message translates to:
  /// **'طريق سريع'**
  String get tagFastRoute;

  /// No description provided for @tagGoodMusic.
  ///
  /// In ar, this message translates to:
  /// **'موسيقى جيدة'**
  String get tagGoodMusic;

  /// No description provided for @tagReckless.
  ///
  /// In ar, this message translates to:
  /// **'قيادة متهورة'**
  String get tagReckless;

  /// No description provided for @tagDirtyCar.
  ///
  /// In ar, this message translates to:
  /// **'سيارة متسخة'**
  String get tagDirtyCar;

  /// No description provided for @tagRude.
  ///
  /// In ar, this message translates to:
  /// **'غير مهذب'**
  String get tagRude;

  /// No description provided for @tagVeryLate.
  ///
  /// In ar, this message translates to:
  /// **'تأخر كثيراً'**
  String get tagVeryLate;

  /// No description provided for @walletTitle.
  ///
  /// In ar, this message translates to:
  /// **'المحفظة'**
  String get walletTitle;

  /// No description provided for @history.
  ///
  /// In ar, this message translates to:
  /// **'السجل'**
  String get history;

  /// No description provided for @currentBalance.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد الحالي'**
  String get currentBalance;

  /// No description provided for @topUp.
  ///
  /// In ar, this message translates to:
  /// **'شحن الرصيد'**
  String get topUp;

  /// No description provided for @topUpComingSoon.
  ///
  /// In ar, this message translates to:
  /// **'شحن الرصيد قيد الإنشاء'**
  String get topUpComingSoon;

  /// No description provided for @transfer.
  ///
  /// In ar, this message translates to:
  /// **'تحويل'**
  String get transfer;

  /// No description provided for @transferComingSoon.
  ///
  /// In ar, this message translates to:
  /// **'التحويل قيد الإنشاء'**
  String get transferComingSoon;

  /// No description provided for @paymentMethods.
  ///
  /// In ar, this message translates to:
  /// **'طرق الدفع'**
  String get paymentMethods;

  /// No description provided for @recentTransactions.
  ///
  /// In ar, this message translates to:
  /// **'آخر المعاملات'**
  String get recentTransactions;

  /// No description provided for @transactionsFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر جلب المعاملات'**
  String get transactionsFailed;

  /// No description provided for @noTransactions.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد معاملات بعد'**
  String get noTransactions;

  /// No description provided for @addCard.
  ///
  /// In ar, this message translates to:
  /// **'إضافة بطاقة'**
  String get addCard;

  /// No description provided for @defaultLabel.
  ///
  /// In ar, this message translates to:
  /// **'الافتراضي'**
  String get defaultLabel;

  /// No description provided for @myTrips.
  ///
  /// In ar, this message translates to:
  /// **'رحلاتي'**
  String get myTrips;

  /// No description provided for @tripsFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر جلب سجل الرحلات'**
  String get tripsFailed;

  /// No description provided for @tripsCount.
  ///
  /// In ar, this message translates to:
  /// **'رحلات'**
  String get tripsCount;

  /// No description provided for @totalSpent.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي الإنفاق'**
  String get totalSpent;

  /// No description provided for @avgRating.
  ///
  /// In ar, this message translates to:
  /// **'متوسط التقييم'**
  String get avgRating;

  /// No description provided for @noTripsYet.
  ///
  /// In ar, this message translates to:
  /// **'لم تقم بأي رحلة بعد'**
  String get noTripsYet;

  /// No description provided for @cancelledTrip.
  ///
  /// In ar, this message translates to:
  /// **'ملغاة'**
  String get cancelledTrip;

  /// No description provided for @profile.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get profile;

  /// No description provided for @defaultUserName.
  ///
  /// In ar, this message translates to:
  /// **'مستخدم مِشوارَك'**
  String get defaultUserName;

  /// No description provided for @yourPoints.
  ///
  /// In ar, this message translates to:
  /// **'نقاطك المتاحة'**
  String get yourPoints;

  /// No description provided for @points.
  ///
  /// In ar, this message translates to:
  /// **'نقطة'**
  String get points;

  /// No description provided for @goldReached.
  ///
  /// In ar, this message translates to:
  /// **'وصلت للمستوى الذهبي 🎉'**
  String get goldReached;

  /// No description provided for @pointsToGold.
  ///
  /// In ar, this message translates to:
  /// **'{count} نقطة لمستوى ذهبي'**
  String pointsToGold(String count);

  /// No description provided for @memberSince.
  ///
  /// In ar, this message translates to:
  /// **'· عضو منذ {year}'**
  String memberSince(int year);

  /// No description provided for @personalInfo.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات الشخصية'**
  String get personalInfo;

  /// No description provided for @name.
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In ar, this message translates to:
  /// **'الجوال'**
  String get phone;

  /// No description provided for @email.
  ///
  /// In ar, this message translates to:
  /// **'البريد'**
  String get email;

  /// No description provided for @addAddress.
  ///
  /// In ar, this message translates to:
  /// **'إضافة عنوان'**
  String get addAddress;

  /// No description provided for @emergencyContacts.
  ///
  /// In ar, this message translates to:
  /// **'جهات الطوارئ'**
  String get emergencyContacts;

  /// No description provided for @addContact.
  ///
  /// In ar, this message translates to:
  /// **'إضافة جهة اتصال'**
  String get addContact;

  /// No description provided for @notifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notifications;

  /// No description provided for @markAllRead.
  ///
  /// In ar, this message translates to:
  /// **'تحديد الكل مقروء'**
  String get markAllRead;

  /// No description provided for @notificationsFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر جلب الإشعارات'**
  String get notificationsFailed;

  /// No description provided for @noNotifications.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إشعارات'**
  String get noNotifications;

  /// No description provided for @locationServiceDisabled.
  ///
  /// In ar, this message translates to:
  /// **'خدمة الموقع مغلقة. فعّلها من إعدادات الجهاز.'**
  String get locationServiceDisabled;

  /// No description provided for @locationDenied.
  ///
  /// In ar, this message translates to:
  /// **'نحتاج إذن الموقع لتحديد نقطة انطلاقك.'**
  String get locationDenied;

  /// No description provided for @locationDeniedForever.
  ///
  /// In ar, this message translates to:
  /// **'إذن الموقع مرفوض نهائياً. افتح الإعدادات واسمح بالوصول.'**
  String get locationDeniedForever;

  /// No description provided for @locationFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحديد موقعك. حاول مرة أخرى.'**
  String get locationFailed;

  /// No description provided for @menuWalletBalance.
  ///
  /// In ar, this message translates to:
  /// **'رصيد المحفظة'**
  String get menuWalletBalance;

  /// No description provided for @menuTopUp.
  ///
  /// In ar, this message translates to:
  /// **'شحن'**
  String get menuTopUp;

  /// No description provided for @menuPromos.
  ///
  /// In ar, this message translates to:
  /// **'الكوبونات'**
  String get menuPromos;

  /// No description provided for @menuRewards.
  ///
  /// In ar, this message translates to:
  /// **'نظام النقاط'**
  String get menuRewards;

  /// No description provided for @menuRewardsBadge.
  ///
  /// In ar, this message translates to:
  /// **'جديد'**
  String get menuRewardsBadge;

  /// No description provided for @menuVip.
  ///
  /// In ar, this message translates to:
  /// **'اشتراك VIP'**
  String get menuVip;

  /// No description provided for @menuHelp.
  ///
  /// In ar, this message translates to:
  /// **'المساعدة'**
  String get menuHelp;

  /// No description provided for @signOut.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get signOut;

  /// No description provided for @signOutConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد تسجيل الخروج من حسابك؟'**
  String get signOutConfirm;

  /// No description provided for @comingSoon.
  ///
  /// In ar, this message translates to:
  /// **'{feature} قيد الإنشاء'**
  String comingSoon(String feature);

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @remove.
  ///
  /// In ar, this message translates to:
  /// **'إزالة'**
  String get remove;

  /// No description provided for @close.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق'**
  String get close;

  /// No description provided for @apply.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق'**
  String get apply;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @fieldRequired.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحقل مطلوب'**
  String get fieldRequired;

  /// No description provided for @saved.
  ///
  /// In ar, this message translates to:
  /// **'تم الحفظ'**
  String get saved;

  /// No description provided for @saveFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر الحفظ. حاول مرة أخرى.'**
  String get saveFailed;

  /// No description provided for @deleteFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر الحذف. حاول مرة أخرى.'**
  String get deleteFailed;

  /// No description provided for @signInRequired.
  ///
  /// In ar, this message translates to:
  /// **'سجّل الدخول أولاً.'**
  String get signInRequired;

  /// No description provided for @dateToday.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get dateToday;

  /// No description provided for @dateYesterday.
  ///
  /// In ar, this message translates to:
  /// **'أمس'**
  String get dateYesterday;

  /// No description provided for @relativeNow.
  ///
  /// In ar, this message translates to:
  /// **'الآن'**
  String get relativeNow;

  /// No description provided for @relativeMinutes.
  ///
  /// In ar, this message translates to:
  /// **'قبل {count} دقيقة'**
  String relativeMinutes(int count);

  /// No description provided for @relativeHours.
  ///
  /// In ar, this message translates to:
  /// **'قبل {count} ساعة'**
  String relativeHours(int count);

  /// No description provided for @relativeDays.
  ///
  /// In ar, this message translates to:
  /// **'قبل {count} يوم'**
  String relativeDays(int count);

  /// No description provided for @settingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageArabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get settingsLanguageArabic;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsAppearance.
  ///
  /// In ar, this message translates to:
  /// **'المظهر'**
  String get settingsAppearance;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In ar, this message translates to:
  /// **'حسب النظام'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In ar, this message translates to:
  /// **'فاتح'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In ar, this message translates to:
  /// **'داكن'**
  String get settingsThemeDark;

  /// No description provided for @settingsAbout.
  ///
  /// In ar, this message translates to:
  /// **'عن التطبيق'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In ar, this message translates to:
  /// **'الإصدار'**
  String get settingsVersion;

  /// No description provided for @settingsDiagnostics.
  ///
  /// In ar, this message translates to:
  /// **'حالة الخدمات'**
  String get settingsDiagnostics;

  /// No description provided for @settingsBackendOn.
  ///
  /// In ar, this message translates to:
  /// **'قاعدة البيانات: متصلة'**
  String get settingsBackendOn;

  /// No description provided for @settingsBackendOff.
  ///
  /// In ar, this message translates to:
  /// **'قاعدة البيانات: غير مهيّأة'**
  String get settingsBackendOff;

  /// No description provided for @settingsMapsOn.
  ///
  /// In ar, this message translates to:
  /// **'الخرائط: مفعّلة'**
  String get settingsMapsOn;

  /// No description provided for @settingsMapsOff.
  ///
  /// In ar, this message translates to:
  /// **'الخرائط: بديلة'**
  String get settingsMapsOff;

  /// No description provided for @settingsTerms.
  ///
  /// In ar, this message translates to:
  /// **'شروط الاستخدام'**
  String get settingsTerms;

  /// No description provided for @settingsPrivacy.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get settingsPrivacy;

  /// No description provided for @editProfile.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الملف الشخصي'**
  String get editProfile;

  /// No description provided for @fullNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get fullNameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get emailLabel;

  /// No description provided for @emailInvalid.
  ///
  /// In ar, this message translates to:
  /// **'بريد إلكتروني غير صالح'**
  String get emailInvalid;

  /// No description provided for @phoneNotEditable.
  ///
  /// In ar, this message translates to:
  /// **'رقم الجوال هو وسيلة الدخول ولا يمكن تغييره هنا.'**
  String get phoneNotEditable;

  /// No description provided for @addPlaceTitle.
  ///
  /// In ar, this message translates to:
  /// **'عنوان جديد'**
  String get addPlaceTitle;

  /// No description provided for @editPlaceTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعديل العنوان'**
  String get editPlaceTitle;

  /// No description provided for @placeNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم المكان'**
  String get placeNameLabel;

  /// No description provided for @placeAddressLabel.
  ///
  /// In ar, this message translates to:
  /// **'العنوان'**
  String get placeAddressLabel;

  /// No description provided for @placeKindHome.
  ///
  /// In ar, this message translates to:
  /// **'المنزل'**
  String get placeKindHome;

  /// No description provided for @placeKindWork.
  ///
  /// In ar, this message translates to:
  /// **'العمل'**
  String get placeKindWork;

  /// No description provided for @placeKindOther.
  ///
  /// In ar, this message translates to:
  /// **'آخر'**
  String get placeKindOther;

  /// No description provided for @deletePlaceConfirm.
  ///
  /// In ar, this message translates to:
  /// **'حذف \"{name}\" من عناوينك المحفوظة؟'**
  String deletePlaceConfirm(String name);

  /// No description provided for @addContactTitle.
  ///
  /// In ar, this message translates to:
  /// **'جهة اتصال للطوارئ'**
  String get addContactTitle;

  /// No description provided for @editContactTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعديل جهة الاتصال'**
  String get editContactTitle;

  /// No description provided for @contactNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get contactNameLabel;

  /// No description provided for @contactPhoneLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم الجوال'**
  String get contactPhoneLabel;

  /// No description provided for @phoneInvalid.
  ///
  /// In ar, this message translates to:
  /// **'رقم جوال غير صالح'**
  String get phoneInvalid;

  /// No description provided for @deleteContactConfirm.
  ///
  /// In ar, this message translates to:
  /// **'حذف \"{name}\" من جهات الطوارئ؟'**
  String deleteContactConfirm(String name);

  /// No description provided for @promosTitle.
  ///
  /// In ar, this message translates to:
  /// **'الكوبونات والعروض'**
  String get promosTitle;

  /// No description provided for @promoCodeLabel.
  ///
  /// In ar, this message translates to:
  /// **'رمز الكوبون'**
  String get promoCodeLabel;

  /// No description provided for @promoApplied.
  ///
  /// In ar, this message translates to:
  /// **'طُبِّق الكوبون — خصم {amount} {currency}'**
  String promoApplied(String amount, String currency);

  /// No description provided for @promoNotFound.
  ///
  /// In ar, this message translates to:
  /// **'رمز الكوبون غير موجود.'**
  String get promoNotFound;

  /// No description provided for @promoExpired.
  ///
  /// In ar, this message translates to:
  /// **'انتهت صلاحية هذا الكوبون.'**
  String get promoExpired;

  /// No description provided for @promoNotStarted.
  ///
  /// In ar, this message translates to:
  /// **'هذا الكوبون لم يبدأ بعد.'**
  String get promoNotStarted;

  /// No description provided for @promoExhausted.
  ///
  /// In ar, this message translates to:
  /// **'استُنفد هذا الكوبون.'**
  String get promoExhausted;

  /// No description provided for @promoAlreadyUsed.
  ///
  /// In ar, this message translates to:
  /// **'استخدمت هذا الكوبون من قبل.'**
  String get promoAlreadyUsed;

  /// No description provided for @promoRideClosed.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن تطبيق كوبون على رحلة منتهية.'**
  String get promoRideClosed;

  /// No description provided for @promoFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر التحقّق من الكوبون. حاول مرة أخرى.'**
  String get promoFailed;

  /// No description provided for @promoNone.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد عروض متاحة حالياً.'**
  String get promoNone;

  /// No description provided for @promoValidUntil.
  ///
  /// In ar, this message translates to:
  /// **'صالح حتى {date}'**
  String promoValidUntil(String date);

  /// No description provided for @promoOffPercent.
  ///
  /// In ar, this message translates to:
  /// **'خصم {percent}%'**
  String promoOffPercent(int percent);

  /// No description provided for @promoOffAmount.
  ///
  /// In ar, this message translates to:
  /// **'خصم {amount} {currency}'**
  String promoOffAmount(String amount, String currency);

  /// No description provided for @promoCopy.
  ///
  /// In ar, this message translates to:
  /// **'نسخ الرمز'**
  String get promoCopy;

  /// No description provided for @promoCopied.
  ///
  /// In ar, this message translates to:
  /// **'نُسخ الرمز {code}'**
  String promoCopied(String code);

  /// No description provided for @promoRemoved.
  ///
  /// In ar, this message translates to:
  /// **'أُزيل الكوبون'**
  String get promoRemoved;

  /// No description provided for @discount.
  ///
  /// In ar, this message translates to:
  /// **'الخصم'**
  String get discount;

  /// No description provided for @totalAfterDiscount.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي بعد الخصم'**
  String get totalAfterDiscount;

  /// No description provided for @rewardsTitle.
  ///
  /// In ar, this message translates to:
  /// **'نظام النقاط'**
  String get rewardsTitle;

  /// No description provided for @rewardsIntro.
  ///
  /// In ar, this message translates to:
  /// **'تكسب نقطة عن كل 100 ريال تدفعها في رحلاتك.'**
  String get rewardsIntro;

  /// No description provided for @rewardsBalance.
  ///
  /// In ar, this message translates to:
  /// **'رصيدك الحالي'**
  String get rewardsBalance;

  /// No description provided for @rewardsTierSilver.
  ///
  /// In ar, this message translates to:
  /// **'فضّي'**
  String get rewardsTierSilver;

  /// No description provided for @rewardsTierGold.
  ///
  /// In ar, this message translates to:
  /// **'ذهبي'**
  String get rewardsTierGold;

  /// No description provided for @rewardsTierPlatinum.
  ///
  /// In ar, this message translates to:
  /// **'بلاتيني'**
  String get rewardsTierPlatinum;

  /// No description provided for @rewardsTierAt.
  ///
  /// In ar, this message translates to:
  /// **'عند {points} نقطة'**
  String rewardsTierAt(String points);

  /// No description provided for @rewardsPerkFreeRide.
  ///
  /// In ar, this message translates to:
  /// **'رحلة مجانية كل 5000 نقطة'**
  String get rewardsPerkFreeRide;

  /// No description provided for @rewardsPerkPriority.
  ///
  /// In ar, this message translates to:
  /// **'أولوية في إيجاد السائق'**
  String get rewardsPerkPriority;

  /// No description provided for @rewardsPerkSupport.
  ///
  /// In ar, this message translates to:
  /// **'دعم مخصّص على مدار الساعة'**
  String get rewardsPerkSupport;

  /// No description provided for @rewardsCurrentTier.
  ///
  /// In ar, this message translates to:
  /// **'مستواك الحالي: {tier}'**
  String rewardsCurrentTier(String tier);

  /// No description provided for @vipTitle.
  ///
  /// In ar, this message translates to:
  /// **'اشتراك VIP'**
  String get vipTitle;

  /// No description provided for @vipIntro.
  ///
  /// In ar, this message translates to:
  /// **'مزايا إضافية لركّاب مِشوارَك الدائمين.'**
  String get vipIntro;

  /// No description provided for @vipPerkDiscount.
  ///
  /// In ar, this message translates to:
  /// **'خصم دائم 10% على كل رحلة'**
  String get vipPerkDiscount;

  /// No description provided for @vipPerkCars.
  ///
  /// In ar, this message translates to:
  /// **'سيارات الفئة المريحة بسعر الاقتصادي'**
  String get vipPerkCars;

  /// No description provided for @vipPerkCancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء مجاني بلا رسوم'**
  String get vipPerkCancel;

  /// No description provided for @vipNotAvailable.
  ///
  /// In ar, this message translates to:
  /// **'الاشتراك غير متاح في منطقتك بعد. سنُعلمك فور إطلاقه.'**
  String get vipNotAvailable;

  /// No description provided for @notifyMe.
  ///
  /// In ar, this message translates to:
  /// **'أعلمني عند الإطلاق'**
  String get notifyMe;

  /// No description provided for @notifyMeDone.
  ///
  /// In ar, this message translates to:
  /// **'سنُعلمك فور توفّر الميزة.'**
  String get notifyMeDone;

  /// No description provided for @helpTitle.
  ///
  /// In ar, this message translates to:
  /// **'المساعدة'**
  String get helpTitle;

  /// No description provided for @helpFaqTitle.
  ///
  /// In ar, this message translates to:
  /// **'أسئلة شائعة'**
  String get helpFaqTitle;

  /// No description provided for @helpContactTitle.
  ///
  /// In ar, this message translates to:
  /// **'تواصل معنا'**
  String get helpContactTitle;

  /// No description provided for @helpCall.
  ///
  /// In ar, this message translates to:
  /// **'اتصال بالدعم'**
  String get helpCall;

  /// No description provided for @helpWhatsapp.
  ///
  /// In ar, this message translates to:
  /// **'واتساب'**
  String get helpWhatsapp;

  /// No description provided for @helpEmail.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get helpEmail;

  /// No description provided for @helpQ1.
  ///
  /// In ar, this message translates to:
  /// **'كيف أطلب رحلة؟'**
  String get helpQ1;

  /// No description provided for @helpA1.
  ///
  /// In ar, this message translates to:
  /// **'من الشاشة الرئيسية اختر وجهتك، ثم نوع المركبة، ثم اضغط زر الطلب. سيُعيَّن أقرب سائق متاح تلقائياً.'**
  String get helpA1;

  /// No description provided for @helpQ2.
  ///
  /// In ar, this message translates to:
  /// **'كيف أدفع؟'**
  String get helpQ2;

  /// No description provided for @helpA2.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك الدفع من رصيد المحفظة أو نقداً للسائق عند نهاية الرحلة. تختار الطريقة قبل تأكيد الطلب.'**
  String get helpA2;

  /// No description provided for @helpQ3.
  ///
  /// In ar, this message translates to:
  /// **'كيف ألغي رحلة؟'**
  String get helpQ3;

  /// No description provided for @helpA3.
  ///
  /// In ar, this message translates to:
  /// **'اضغط \"إلغاء الطلب\" أثناء البحث عن سائق، أو زر الإلغاء في شاشة الرحلة قبل بدايتها.'**
  String get helpA3;

  /// No description provided for @helpQ4.
  ///
  /// In ar, this message translates to:
  /// **'ماذا يفعل زر الطوارئ؟'**
  String get helpQ4;

  /// No description provided for @helpA4.
  ///
  /// In ar, this message translates to:
  /// **'يفتح اتصالاً مباشراً بالطوارئ، أو يرسل رسالة بموقعك الحالي إلى جهات الطوارئ التي أضفتها في ملفك الشخصي.'**
  String get helpA4;

  /// No description provided for @helpQ5.
  ///
  /// In ar, this message translates to:
  /// **'كيف أستخدم كوبون خصم؟'**
  String get helpQ5;

  /// No description provided for @helpA5.
  ///
  /// In ar, this message translates to:
  /// **'من شاشة اختيار المركبة اضغط \"كوبون\" وأدخل الرمز قبل تأكيد الطلب.'**
  String get helpA5;

  /// No description provided for @emergencyCallPolice.
  ///
  /// In ar, this message translates to:
  /// **'اتصال بالطوارئ ({number})'**
  String emergencyCallPolice(String number);

  /// No description provided for @emergencyNotifyContacts.
  ///
  /// In ar, this message translates to:
  /// **'إرسال موقعي لجهات الطوارئ'**
  String get emergencyNotifyContacts;

  /// No description provided for @emergencyNoContacts.
  ///
  /// In ar, this message translates to:
  /// **'لم تُضف جهات طوارئ بعد.'**
  String get emergencyNoContacts;

  /// No description provided for @emergencyAddContact.
  ///
  /// In ar, this message translates to:
  /// **'إضافة جهة اتصال'**
  String get emergencyAddContact;

  /// No description provided for @emergencySmsBody.
  ///
  /// In ar, this message translates to:
  /// **'أحتاج مساعدة. موقعي الحالي: {url}'**
  String emergencySmsBody(String url);

  /// No description provided for @emergencySmsNoLocation.
  ///
  /// In ar, this message translates to:
  /// **'أحتاج مساعدة. لم يتوفّر موقعي الحالي.'**
  String get emergencySmsNoLocation;

  /// No description provided for @emergencyOpenFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر فتح تطبيق الاتصال على هذا الجهاز.'**
  String get emergencyOpenFailed;

  /// No description provided for @callDriverFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر بدء الاتصال بالسائق.'**
  String get callDriverFailed;

  /// No description provided for @shareTripText.
  ///
  /// In ar, this message translates to:
  /// **'أنا في رحلة مع {driver} · سيارة {car} · لوحة {plate}'**
  String shareTripText(String driver, String car, String plate);

  /// No description provided for @shareTripCopied.
  ///
  /// In ar, this message translates to:
  /// **'نُسخت تفاصيل الرحلة — أرسلها لمن تثق به.'**
  String get shareTripCopied;

  /// No description provided for @cancelRide.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الرحلة'**
  String get cancelRide;

  /// No description provided for @cancelRideConfirm.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء هذه الرحلة؟ قد تُطبَّق رسوم إلغاء إذا كان السائق في طريقه إليك.'**
  String get cancelRideConfirm;

  /// No description provided for @cancelRideFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر إلغاء الرحلة. حاول مرة أخرى.'**
  String get cancelRideFailed;

  /// No description provided for @keepRide.
  ///
  /// In ar, this message translates to:
  /// **'متابعة الرحلة'**
  String get keepRide;

  /// No description provided for @vehicleEta.
  ///
  /// In ar, this message translates to:
  /// **'{minutes} دقائق'**
  String vehicleEta(int minutes);

  /// No description provided for @rateThisTrip.
  ///
  /// In ar, this message translates to:
  /// **'قيّم هذه الرحلة'**
  String get rateThisTrip;

  /// No description provided for @tripRated.
  ///
  /// In ar, this message translates to:
  /// **'مُقيَّمة'**
  String get tripRated;

  /// No description provided for @noPaymentMethods.
  ///
  /// In ar, this message translates to:
  /// **'لم تُضف طريقة دفع بعد.'**
  String get noPaymentMethods;

  /// No description provided for @paymentSetDefault.
  ///
  /// In ar, this message translates to:
  /// **'جعله الافتراضي'**
  String get paymentSetDefault;

  /// No description provided for @paymentRemove.
  ///
  /// In ar, this message translates to:
  /// **'إزالة البطاقة'**
  String get paymentRemove;

  /// No description provided for @paymentRemoveConfirm.
  ///
  /// In ar, this message translates to:
  /// **'إزالة هذه البطاقة من حسابك؟'**
  String get paymentRemoveConfirm;

  /// No description provided for @paymentDefaultSet.
  ///
  /// In ar, this message translates to:
  /// **'أصبحت الطريقة الافتراضية'**
  String get paymentDefaultSet;

  /// No description provided for @searchingPlaces.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ البحث...'**
  String get searchingPlaces;

  /// No description provided for @searchNoResults.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نتائج لهذا البحث.'**
  String get searchNoResults;

  /// No description provided for @searchFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر البحث عن العنوان.'**
  String get searchFailed;

  /// No description provided for @searchOnWebUnsupported.
  ///
  /// In ar, this message translates to:
  /// **'البحث الجغرافي غير متاح على المتصفّح — اختر من العناوين المحفوظة أو الأخيرة.'**
  String get searchOnWebUnsupported;

  /// No description provided for @destinationNeedsLocation.
  ///
  /// In ar, this message translates to:
  /// **'لم نتمكن من تحديد إحداثيات هذه الوجهة، لذا الأجرة تقديرية.'**
  String get destinationNeedsLocation;

  /// No description provided for @notifRideCompleted.
  ///
  /// In ar, this message translates to:
  /// **'اكتملت رحلتك'**
  String get notifRideCompleted;

  /// No description provided for @notifPromo.
  ///
  /// In ar, this message translates to:
  /// **'عرض جديد'**
  String get notifPromo;

  /// No description provided for @notifPoints.
  ///
  /// In ar, this message translates to:
  /// **'نقاط جديدة'**
  String get notifPoints;

  /// No description provided for @notifRating.
  ///
  /// In ar, this message translates to:
  /// **'قيّم رحلتك'**
  String get notifRating;

  /// No description provided for @notifRoute.
  ///
  /// In ar, this message translates to:
  /// **'{from} ← {to}'**
  String notifRoute(String from, String to);

  /// No description provided for @serviceSchedulePrompt.
  ///
  /// In ar, this message translates to:
  /// **'الحجز المسبق قادم قريباً — يمكنك الطلب الآن مباشرة.'**
  String get serviceSchedulePrompt;

  /// No description provided for @profileUpdated.
  ///
  /// In ar, this message translates to:
  /// **'حُدِّث ملفك الشخصي'**
  String get profileUpdated;

  /// No description provided for @placeSaved.
  ///
  /// In ar, this message translates to:
  /// **'حُفظ العنوان'**
  String get placeSaved;

  /// No description provided for @placeDeleted.
  ///
  /// In ar, this message translates to:
  /// **'حُذف العنوان'**
  String get placeDeleted;

  /// No description provided for @contactSaved.
  ///
  /// In ar, this message translates to:
  /// **'حُفظت جهة الاتصال'**
  String get contactSaved;

  /// No description provided for @contactDeleted.
  ///
  /// In ar, this message translates to:
  /// **'حُذفت جهة الاتصال'**
  String get contactDeleted;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return L10nAr();
    case 'en':
      return L10nEn();
  }

  throw FlutterError(
      'L10n.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
