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
}
