// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Mishwarak';

  @override
  String get appTagline => 'Ride-hailing in Yemen';

  @override
  String get currency => 'YER';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get settings => 'Settings';

  @override
  String get add => 'Add';

  @override
  String get notAddedYet => 'Not set yet';

  @override
  String get loading => 'Loading...';

  @override
  String get retryLater => 'Please try again.';

  @override
  String get onboardTitle1 => 'A ride at the tap of a button';

  @override
  String get onboardBody1 => 'Trusted drivers across Aden, around the clock';

  @override
  String get onboardTitle2 => 'Clear pricing up front';

  @override
  String get onboardBody2 => 'See the fare before you confirm. No surprises.';

  @override
  String get onboardTitle3 => 'Your safety comes first';

  @override
  String get onboardBody3 =>
      'Share your trip, an SOS button, and women-only drivers';

  @override
  String get onboardStart => 'Let\'s go';

  @override
  String get welcome => 'Welcome 👋';

  @override
  String get loginPrompt => 'Enter your phone number to receive a code';

  @override
  String get sendOtp => 'Send code';

  @override
  String get termsNotice =>
      'By continuing you agree to the Terms and Privacy Policy';

  @override
  String get sendOtpFailed => 'Couldn\'t send the code. Please try again.';

  @override
  String get otpTitle => 'Verification code';

  @override
  String get otpEnter => 'Enter the code';

  @override
  String get otpSentTo => 'We sent a 6-digit code to ';

  @override
  String get otpInvalid => 'That code isn\'t right. Please try again.';

  @override
  String get otpResend => 'Resend code';

  @override
  String get otpResendFailed => 'Couldn\'t resend the code.';

  @override
  String otpResendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String greeting(String name) {
    return 'Hi $name 👋';
  }

  @override
  String get whereTo => 'Where would you like to go?';

  @override
  String get locating => 'Finding your location...';

  @override
  String get searchHint => 'Search for your destination...';

  @override
  String get bookNow => 'Book now';

  @override
  String get newPlace => 'New place';

  @override
  String get myLocation => 'My location';

  @override
  String get emergencyTitle => 'Emergency?';

  @override
  String get emergencyBody =>
      'Your location will be sent to the authorities and your saved contacts.';

  @override
  String get emergencyAction => 'Get help';

  @override
  String get chooseDestination => 'Choose your destination';

  @override
  String get destinationHint => 'Where to?';

  @override
  String get useAsDestination => 'Use this text as destination';

  @override
  String get savedPlaces => 'Saved places';

  @override
  String get noSavedPlaces => 'No saved places yet';

  @override
  String get savedPlacesFailed => 'Couldn\'t load saved places';

  @override
  String get recentDestinations => 'Recent destinations';

  @override
  String get noRecentTrips => 'No previous trips';

  @override
  String get historyFailed => 'Couldn\'t load history';

  @override
  String get chooseVehicle => 'Choose your ride';

  @override
  String get loadingOptions => 'Loading options...';

  @override
  String optionsCount(int count) {
    return '$count options available';
  }

  @override
  String optionsWithDistance(int count, String km) {
    return '$count options · $km km';
  }

  @override
  String get wallet => 'Wallet';

  @override
  String get cash => 'Cash';

  @override
  String get coupon => 'Coupon';

  @override
  String get schedule => 'Schedule';

  @override
  String get serviceEconomy => 'Economy';

  @override
  String get serviceVip => 'VIP';

  @override
  String get serviceWomen => 'Women';

  @override
  String orderVehicle(String name) {
    return 'Book $name';
  }

  @override
  String get requestFailed => 'Couldn\'t create the request. Please try again.';

  @override
  String get findingDriver => 'Finding your best driver...';

  @override
  String get findingDriverBody =>
      'Matching you with the nearest available driver';

  @override
  String get noDriverTitle => 'No driver available right now';

  @override
  String get noDriverBody => 'Try another vehicle type or check back shortly';

  @override
  String get cancelRequest => 'Cancel request';

  @override
  String get cancelledByRider => 'Cancelled by rider';

  @override
  String get statusAssigned => 'A driver has been assigned';

  @override
  String get statusArriving => 'Your driver is on the way';

  @override
  String get statusArrived => 'Your driver has arrived';

  @override
  String get statusOnTrip => 'On the way to your destination';

  @override
  String get statusCompleted => 'Trip completed';

  @override
  String get statusCancelled => 'Trip cancelled';

  @override
  String get statusRequested => 'Assigning a driver...';

  @override
  String get loadingDriver => 'Loading driver details...';

  @override
  String get tripShared => 'Your trip has been shared';

  @override
  String get emergencyNotified => 'Emergency contacts notified';

  @override
  String get chatComingSoon => 'Chat is coming soon';

  @override
  String callingDriver(String name) {
    return 'Calling $name';
  }

  @override
  String get fare => 'Fare';

  @override
  String driverTripsCount(int count) {
    return '· $count trips';
  }

  @override
  String get tripDone => 'You\'ve arrived safely!';

  @override
  String get tripDoneBody => 'Have a wonderful day 🌟';

  @override
  String get tripFare => 'Trip fare';

  @override
  String get tip => 'Tip';

  @override
  String get total => 'Total';

  @override
  String get driver => 'Driver';

  @override
  String rateQuestion(String name) {
    return 'How was your ride with $name?';
  }

  @override
  String get whatYouLiked => 'What did you like?';

  @override
  String get whatWentWrong => 'What went wrong?';

  @override
  String get addTip => 'Add a tip for your driver';

  @override
  String get noTip => 'No thanks';

  @override
  String get submitRating => 'Submit rating';

  @override
  String ratingSent(int stars) {
    return 'Thank you! Your $stars-star rating was sent';
  }

  @override
  String get ratingFailed => 'Couldn\'t submit your rating. Please try again.';

  @override
  String ratingSentTipSuffix(String amount, String currency) {
    return ' with a $amount $currency tip';
  }

  @override
  String get tagSafeDriving => 'Safe driving';

  @override
  String get tagCleanCar => 'Clean car';

  @override
  String get tagFriendly => 'Friendly';

  @override
  String get tagOnTime => 'On time';

  @override
  String get tagFastRoute => 'Fast route';

  @override
  String get tagGoodMusic => 'Good music';

  @override
  String get tagReckless => 'Reckless';

  @override
  String get tagDirtyCar => 'Dirty car';

  @override
  String get tagRude => 'Rude';

  @override
  String get tagVeryLate => 'Very late';

  @override
  String get walletTitle => 'Wallet';

  @override
  String get history => 'History';

  @override
  String get currentBalance => 'Current balance';

  @override
  String get topUp => 'Top up';

  @override
  String get topUpComingSoon => 'Top-up is coming soon';

  @override
  String get transfer => 'Transfer';

  @override
  String get transferComingSoon => 'Transfers are coming soon';

  @override
  String get paymentMethods => 'Payment methods';

  @override
  String get recentTransactions => 'Recent transactions';

  @override
  String get transactionsFailed => 'Couldn\'t load transactions';

  @override
  String get noTransactions => 'No transactions yet';

  @override
  String get addCard => 'Add card';

  @override
  String get defaultLabel => 'Default';

  @override
  String get myTrips => 'My trips';

  @override
  String get tripsFailed => 'Couldn\'t load your trip history';

  @override
  String get tripsCount => 'Trips';

  @override
  String get totalSpent => 'Total spent';

  @override
  String get avgRating => 'Avg. rating';

  @override
  String get noTripsYet => 'You haven\'t taken a trip yet';

  @override
  String get cancelledTrip => 'Cancelled';

  @override
  String get profile => 'Profile';

  @override
  String get defaultUserName => 'Mishwarak user';

  @override
  String get yourPoints => 'Your points';

  @override
  String get points => 'points';

  @override
  String get goldReached => 'You\'ve reached Gold 🎉';

  @override
  String pointsToGold(String count) {
    return '$count points to Gold';
  }

  @override
  String memberSince(int year) {
    return '· Member since $year';
  }

  @override
  String get personalInfo => 'Personal information';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get email => 'Email';

  @override
  String get addAddress => 'Add address';

  @override
  String get emergencyContacts => 'Emergency contacts';

  @override
  String get addContact => 'Add contact';

  @override
  String get notifications => 'Notifications';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get notificationsFailed => 'Couldn\'t load notifications';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get locationServiceDisabled =>
      'Location services are off. Enable them in device settings.';

  @override
  String get locationDenied =>
      'We need location access to set your pickup point.';

  @override
  String get locationDeniedForever =>
      'Location access is permanently denied. Open settings to allow it.';

  @override
  String get locationFailed =>
      'Couldn\'t determine your location. Please try again.';

  @override
  String get menuWalletBalance => 'Wallet balance';

  @override
  String get menuTopUp => 'Top up';

  @override
  String get menuPromos => 'Promos';

  @override
  String get menuRewards => 'Rewards';

  @override
  String get menuRewardsBadge => 'New';

  @override
  String get menuVip => 'VIP subscription';

  @override
  String get menuHelp => 'Help';

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutConfirm => 'Do you want to sign out of your account?';

  @override
  String comingSoon(String feature) {
    return '$feature is coming soon';
  }

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get remove => 'Remove';

  @override
  String get close => 'Close';

  @override
  String get apply => 'Apply';

  @override
  String get retry => 'Retry';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get saved => 'Saved';

  @override
  String get saveFailed => 'Couldn\'t save. Please try again.';

  @override
  String get deleteFailed => 'Couldn\'t delete. Please try again.';

  @override
  String get signInRequired => 'Please sign in first.';

  @override
  String get dateToday => 'Today';

  @override
  String get dateYesterday => 'Yesterday';

  @override
  String get relativeNow => 'Just now';

  @override
  String relativeMinutes(int count) {
    return '$count min ago';
  }

  @override
  String relativeHours(int count) {
    return '$count h ago';
  }

  @override
  String relativeDays(int count) {
    return '$count d ago';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageArabic => 'العربية';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsDiagnostics => 'Service status';

  @override
  String get settingsBackendOn => 'Database: connected';

  @override
  String get settingsBackendOff => 'Database: not configured';

  @override
  String get settingsMapsOn => 'Maps: enabled';

  @override
  String get settingsMapsOff => 'Maps: fallback';

  @override
  String get settingsTerms => 'Terms of use';

  @override
  String get settingsPrivacy => 'Privacy policy';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get emailLabel => 'Email address';

  @override
  String get emailInvalid => 'Invalid email address';

  @override
  String get phoneNotEditable =>
      'Your phone number is your sign-in method and can\'t be changed here.';

  @override
  String get addPlaceTitle => 'New address';

  @override
  String get editPlaceTitle => 'Edit address';

  @override
  String get placeNameLabel => 'Place name';

  @override
  String get placeAddressLabel => 'Address';

  @override
  String get placeKindHome => 'Home';

  @override
  String get placeKindWork => 'Work';

  @override
  String get placeKindOther => 'Other';

  @override
  String deletePlaceConfirm(String name) {
    return 'Remove \"$name\" from your saved addresses?';
  }

  @override
  String get addContactTitle => 'Emergency contact';

  @override
  String get editContactTitle => 'Edit contact';

  @override
  String get contactNameLabel => 'Name';

  @override
  String get contactPhoneLabel => 'Phone number';

  @override
  String get phoneInvalid => 'Invalid phone number';

  @override
  String deleteContactConfirm(String name) {
    return 'Remove \"$name\" from your emergency contacts?';
  }

  @override
  String get promosTitle => 'Coupons & offers';

  @override
  String get promoCodeLabel => 'Coupon code';

  @override
  String promoApplied(String amount, String currency) {
    return 'Coupon applied — $amount $currency off';
  }

  @override
  String get promoNotFound => 'That coupon code doesn\'t exist.';

  @override
  String get promoExpired => 'This coupon has expired.';

  @override
  String get promoNotStarted => 'This coupon isn\'t active yet.';

  @override
  String get promoExhausted => 'This coupon has been fully redeemed.';

  @override
  String get promoAlreadyUsed => 'You\'ve already used this coupon.';

  @override
  String get promoRideClosed =>
      'A coupon can\'t be applied to a finished ride.';

  @override
  String get promoFailed => 'Couldn\'t check the coupon. Please try again.';

  @override
  String get promoNone => 'No offers available right now.';

  @override
  String promoValidUntil(String date) {
    return 'Valid until $date';
  }

  @override
  String promoOffPercent(int percent) {
    return '$percent% off';
  }

  @override
  String promoOffAmount(String amount, String currency) {
    return '$amount $currency off';
  }

  @override
  String get promoCopy => 'Copy code';

  @override
  String promoCopied(String code) {
    return 'Copied $code';
  }

  @override
  String get promoRemoved => 'Coupon removed';

  @override
  String get discount => 'Discount';

  @override
  String get totalAfterDiscount => 'Total after discount';

  @override
  String get rewardsTitle => 'Points';

  @override
  String get rewardsIntro =>
      'Earn 1 point for every 100 YER you spend on rides.';

  @override
  String get rewardsBalance => 'Your balance';

  @override
  String get rewardsTierSilver => 'Silver';

  @override
  String get rewardsTierGold => 'Gold';

  @override
  String get rewardsTierPlatinum => 'Platinum';

  @override
  String rewardsTierAt(String points) {
    return 'at $points points';
  }

  @override
  String get rewardsPerkFreeRide => 'A free ride every 5,000 points';

  @override
  String get rewardsPerkPriority => 'Priority driver matching';

  @override
  String get rewardsPerkSupport => 'Dedicated 24/7 support';

  @override
  String rewardsCurrentTier(String tier) {
    return 'Your tier: $tier';
  }

  @override
  String get vipTitle => 'VIP membership';

  @override
  String get vipIntro => 'Extra benefits for regular Mishwarak riders.';

  @override
  String get vipPerkDiscount => 'A standing 10% off every ride';

  @override
  String get vipPerkCars => 'Comfort-class cars at economy prices';

  @override
  String get vipPerkCancel => 'Free cancellation, no fees';

  @override
  String get vipNotAvailable =>
      'Membership isn\'t available in your area yet. We\'ll let you know when it launches.';

  @override
  String get notifyMe => 'Notify me at launch';

  @override
  String get notifyMeDone => 'We\'ll let you know as soon as it\'s available.';

  @override
  String get helpTitle => 'Help';

  @override
  String get helpFaqTitle => 'Frequently asked';

  @override
  String get helpContactTitle => 'Contact us';

  @override
  String get helpCall => 'Call support';

  @override
  String get helpWhatsapp => 'WhatsApp';

  @override
  String get helpEmail => 'Email';

  @override
  String get helpQ1 => 'How do I book a ride?';

  @override
  String get helpA1 =>
      'From the home screen pick your destination, choose a vehicle type, then tap the order button. The nearest available driver is assigned automatically.';

  @override
  String get helpQ2 => 'How do I pay?';

  @override
  String get helpA2 =>
      'Pay from your wallet balance, or in cash to the driver at the end of the ride. You choose before confirming the order.';

  @override
  String get helpQ3 => 'How do I cancel a ride?';

  @override
  String get helpA3 =>
      'Tap \"Cancel request\" while a driver is being found, or the cancel button on the ride screen before it starts.';

  @override
  String get helpQ4 => 'What does the emergency button do?';

  @override
  String get helpA4 =>
      'It places a direct call to emergency services, or sends your current location to the emergency contacts saved in your profile.';

  @override
  String get helpQ5 => 'How do I use a coupon?';

  @override
  String get helpA5 =>
      'On the vehicle selection screen tap \"Coupon\" and enter your code before confirming the order.';

  @override
  String emergencyCallPolice(String number) {
    return 'Call emergency ($number)';
  }

  @override
  String get emergencyNotifyContacts =>
      'Send my location to emergency contacts';

  @override
  String get emergencyNoContacts =>
      'You haven\'t added any emergency contacts yet.';

  @override
  String get emergencyAddContact => 'Add a contact';

  @override
  String emergencySmsBody(String url) {
    return 'I need help. My current location: $url';
  }

  @override
  String get emergencySmsNoLocation =>
      'I need help. My location isn\'t available.';

  @override
  String get emergencyOpenFailed =>
      'Couldn\'t open the phone app on this device.';

  @override
  String get callDriverFailed => 'Couldn\'t start the call to the driver.';

  @override
  String shareTripText(String driver, String car, String plate) {
    return 'I\'m on a ride with $driver · $car · plate $plate';
  }

  @override
  String get shareTripCopied =>
      'Ride details copied — send them to someone you trust.';

  @override
  String get cancelRide => 'Cancel ride';

  @override
  String get cancelRideConfirm =>
      'Cancel this ride? A cancellation fee may apply if the driver is already on the way.';

  @override
  String get cancelRideFailed => 'Couldn\'t cancel the ride. Please try again.';

  @override
  String get keepRide => 'Keep the ride';

  @override
  String vehicleEta(int minutes) {
    return '$minutes min';
  }

  @override
  String get rateThisTrip => 'Rate this trip';

  @override
  String get tripRated => 'Rated';

  @override
  String get noPaymentMethods => 'No payment method added yet.';

  @override
  String get paymentSetDefault => 'Make default';

  @override
  String get paymentRemove => 'Remove card';

  @override
  String get paymentRemoveConfirm => 'Remove this card from your account?';

  @override
  String get paymentDefaultSet => 'Set as default';

  @override
  String get searchingPlaces => 'Searching...';

  @override
  String get searchNoResults => 'No results for that search.';

  @override
  String get searchFailed => 'Couldn\'t look up that address.';

  @override
  String get searchOnWebUnsupported =>
      'Address search isn\'t available in the browser — pick a saved or recent address.';

  @override
  String get destinationNeedsLocation =>
      'We couldn\'t pin coordinates for this destination, so the fare is an estimate.';

  @override
  String get notifRideCompleted => 'Your ride is complete';

  @override
  String get notifPromo => 'New offer';

  @override
  String get notifPoints => 'Points earned';

  @override
  String get notifRating => 'Rate your ride';

  @override
  String notifRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String get serviceSchedulePrompt =>
      'Scheduled rides are coming soon — you can book right now instead.';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get placeSaved => 'Address saved';

  @override
  String get placeDeleted => 'Address deleted';

  @override
  String get contactSaved => 'Contact saved';

  @override
  String get contactDeleted => 'Contact deleted';
}
