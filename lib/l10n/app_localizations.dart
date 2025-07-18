import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
    Locale('bn'),
    Locale('en'),
    Locale('hi')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Saraya News'**
  String get appName;

  /// No description provided for @popularNews.
  ///
  /// In en, this message translates to:
  /// **'Popular News'**
  String get popularNews;

  /// No description provided for @recommendation.
  ///
  /// In en, this message translates to:
  /// **'Recommendation'**
  String get recommendation;

  /// No description provided for @channelsYouMayLike.
  ///
  /// In en, this message translates to:
  /// **'Channels you may like'**
  String get channelsYouMayLike;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @forYou.
  ///
  /// In en, this message translates to:
  /// **'For You'**
  String get forYou;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @categoryLable.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLable;

  /// No description provided for @discoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discoverTitle;

  /// No description provided for @bookmarkTitle.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarkTitle;

  /// No description provided for @collectionOfNoteworthyReads.
  ///
  /// In en, this message translates to:
  /// **'Collection of noteworthy reads'**
  String get collectionOfNoteworthyReads;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @generalSettings.
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get generalSettings;

  /// No description provided for @bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarks;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @sarayaBotWelcome.
  ///
  /// In en, this message translates to:
  /// **'👋 Welcome! Tell us your issue or feedback clearly, mention the place, issue type, and any important details. Leave your phone if you\'d like a follow-up.'**
  String get sarayaBotWelcome;

  /// No description provided for @breakingNews.
  ///
  /// In en, this message translates to:
  /// **'Breaking News'**
  String get breakingNews;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @stories.
  ///
  /// In en, this message translates to:
  /// **'Stories'**
  String get stories;

  /// No description provided for @followedChannelsPost.
  ///
  /// In en, this message translates to:
  /// **'Followed Channels Post'**
  String get followedChannelsPost;

  /// No description provided for @noFollowedChannels.
  ///
  /// In en, this message translates to:
  /// **'No Followed Channels'**
  String get noFollowedChannels;

  /// No description provided for @nameEmailMobileNumberCannotEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name, email, and mobile number cannot be empty.'**
  String get nameEmailMobileNumberCannotEmpty;

  /// No description provided for @topicsStories.
  ///
  /// In en, this message translates to:
  /// **'Topics Stories'**
  String get topicsStories;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get language;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @urgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgent;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @unlockPremiumExperience.
  ///
  /// In en, this message translates to:
  /// **'Unlock a premium experience tailored to your needs with our flexible subscription options'**
  String get unlockPremiumExperience;

  /// No description provided for @selectYourPlan.
  ///
  /// In en, this message translates to:
  /// **'Select Your Membership Plan'**
  String get selectYourPlan;

  /// No description provided for @joinMillions.
  ///
  /// In en, this message translates to:
  /// **'Join millions of premium users'**
  String get joinMillions;

  /// No description provided for @elevateExperience.
  ///
  /// In en, this message translates to:
  /// **'Elevate Your Experience'**
  String get elevateExperience;

  /// No description provided for @includedBenefits.
  ///
  /// In en, this message translates to:
  /// **'Included Benefits'**
  String get includedBenefits;

  /// No description provided for @selectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get selectPaymentMethod;

  /// No description provided for @choosePaymentOption.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred payment option'**
  String get choosePaymentOption;

  /// No description provided for @fullAccessFor.
  ///
  /// In en, this message translates to:
  /// **'Full access for'**
  String get fullAccessFor;

  /// No description provided for @razorpay.
  ///
  /// In en, this message translates to:
  /// **'Razorpay'**
  String get razorpay;

  /// No description provided for @razorpayDescription.
  ///
  /// In en, this message translates to:
  /// **'Pay using credit/debit cards, UPI, etc.'**
  String get razorpayDescription;

  /// No description provided for @stripe.
  ///
  /// In en, this message translates to:
  /// **'Stripe'**
  String get stripe;

  /// No description provided for @stripeDescription.
  ///
  /// In en, this message translates to:
  /// **'Pay using international cards'**
  String get stripeDescription;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @searchNews.
  ///
  /// In en, this message translates to:
  /// **'Search News'**
  String get searchNews;

  /// No description provided for @like.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get like;

  /// No description provided for @love.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get love;

  /// No description provided for @haha.
  ///
  /// In en, this message translates to:
  /// **'Haha'**
  String get haha;

  /// No description provided for @wow.
  ///
  /// In en, this message translates to:
  /// **'Wow'**
  String get wow;

  /// No description provided for @sad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get sad;

  /// No description provided for @angry.
  ///
  /// In en, this message translates to:
  /// **'Angry'**
  String get angry;

  /// No description provided for @liked.
  ///
  /// In en, this message translates to:
  /// **'Liked'**
  String get liked;

  /// No description provided for @commentOnPost.
  ///
  /// In en, this message translates to:
  /// **'Comment on Post'**
  String get commentOnPost;

  /// No description provided for @yourNotificationFeedisQuiet.
  ///
  /// In en, this message translates to:
  /// **'Your Notification Feed is Quiet'**
  String get yourNotificationFeedisQuiet;

  /// No description provided for @checkNotificationChannels.
  ///
  /// In en, this message translates to:
  /// **'Check back later for the latest notification updates from your favorite channels.'**
  String get checkNotificationChannels;

  /// No description provided for @goToHomeFeed.
  ///
  /// In en, this message translates to:
  /// **'Go to Home Feed'**
  String get goToHomeFeed;

  /// No description provided for @chooseTheme.
  ///
  /// In en, this message translates to:
  /// **'Choose Theme'**
  String get chooseTheme;

  /// No description provided for @systemMode.
  ///
  /// In en, this message translates to:
  /// **'System Mode'**
  String get systemMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// No description provided for @loginLabel.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginLabel;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @followedChannels.
  ///
  /// In en, this message translates to:
  /// **'Followed Channels'**
  String get followedChannels;

  /// No description provided for @bookmarkPost.
  ///
  /// In en, this message translates to:
  /// **'Bookmark Post'**
  String get bookmarkPost;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @sarayaBotTitle.
  ///
  /// In en, this message translates to:
  /// **'Ain Saraya'**
  String get sarayaBotTitle;

  /// No description provided for @logInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Log in with Apple'**
  String get logInWithApple;

  /// No description provided for @removeBookmark.
  ///
  /// In en, this message translates to:
  /// **'Remove Bookmark'**
  String get removeBookmark;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @addComments.
  ///
  /// In en, this message translates to:
  /// **'Add Comments'**
  String get addComments;

  /// No description provided for @channels.
  ///
  /// In en, this message translates to:
  /// **'Channels'**
  String get channels;

  /// No description provided for @youNeedToLogInToViewThisPage.
  ///
  /// In en, this message translates to:
  /// **'You need to login to view this page.'**
  String get youNeedToLogInToViewThisPage;

  /// No description provided for @signInToNewsHunt.
  ///
  /// In en, this message translates to:
  /// **'Sign in to News Hunt'**
  String get signInToNewsHunt;

  /// No description provided for @logInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Log in with Google'**
  String get logInWithGoogle;

  /// No description provided for @logInWithNumber.
  ///
  /// In en, this message translates to:
  /// **'Log in with Number'**
  String get logInWithNumber;

  /// No description provided for @emial.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emial;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @noAccountCreateOne.
  ///
  /// In en, this message translates to:
  /// **'No Account?'**
  String get noAccountCreateOne;

  /// No description provided for @createOne.
  ///
  /// In en, this message translates to:
  /// **'Create one'**
  String get createOne;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @pleaseEnterYourNameAndPhoneNumberToLogIn.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name and phone number to log in'**
  String get pleaseEnterYourNameAndPhoneNumberToLogIn;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @tapFor.
  ///
  /// In en, this message translates to:
  /// **'Tap For'**
  String get tapFor;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'& more'**
  String get more;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @otpVerification.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerification;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @resendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'Resend Code in'**
  String get resendCodeIn;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @reEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter Password'**
  String get reEnterPassword;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @withLogin.
  ///
  /// In en, this message translates to:
  /// **'with Login'**
  String get withLogin;

  /// No description provided for @pleaseEnterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterYourPhoneNumber;

  /// No description provided for @noBookmarksfound.
  ///
  /// In en, this message translates to:
  /// **'No Bookmarks found'**
  String get noBookmarksfound;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get readMore;

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'Login Required'**
  String get loginRequired;

  /// No description provided for @needToLogInToSavePost.
  ///
  /// In en, this message translates to:
  /// **'You need to log in to save this post. Would you like to log in now?'**
  String get needToLogInToSavePost;

  /// No description provided for @youNeedToLoginToUseThisFeature.
  ///
  /// In en, this message translates to:
  /// **'You need to login to use this feature.'**
  String get youNeedToLoginToUseThisFeature;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @pleaseLoginToFollow.
  ///
  /// In en, this message translates to:
  /// **'Please Login to follow'**
  String get pleaseLoginToFollow;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @entertheverificationcodewejustsentonyouremailaddress.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code we just sent on your email address'**
  String get entertheverificationcodewejustsentonyouremailaddress;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// No description provided for @resetPasswordEmailSentSuccessfullyPleaseCheckYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Reset password email sent successfully. Please check your email'**
  String get resetPasswordEmailSentSuccessfullyPleaseCheckYourEmail;

  /// No description provided for @pleaseEnterTheEmailAddressLinkedWithYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Please enter the email address linked with your account'**
  String get pleaseEnterTheEmailAddressLinkedWithYourAccount;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterYourEmail;

  /// No description provided for @sendEmail.
  ///
  /// In en, this message translates to:
  /// **'Send Email'**
  String get sendEmail;

  /// No description provided for @failedToloadUserData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load user data'**
  String get failedToloadUserData;

  /// No description provided for @selectImageSource.
  ///
  /// In en, this message translates to:
  /// **'Select Image Source'**
  String get selectImageSource;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @cropImage.
  ///
  /// In en, this message translates to:
  /// **'Crop Image'**
  String get cropImage;

  /// No description provided for @noChangestoNameandImage.
  ///
  /// In en, this message translates to:
  /// **'No Changes to Name and Image'**
  String get noChangestoNameandImage;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @failedToSaveupdatedProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to save updated profile'**
  String get failedToSaveupdatedProfile;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @updateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfile;

  /// No description provided for @postingComment.
  ///
  /// In en, this message translates to:
  /// **'Posting comment...'**
  String get postingComment;

  /// No description provided for @playbackSpeed.
  ///
  /// In en, this message translates to:
  /// **'Playback Speed'**
  String get playbackSpeed;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @replyingTo.
  ///
  /// In en, this message translates to:
  /// **'Replying to'**
  String get replyingTo;

  /// No description provided for @commentlabel.
  ///
  /// In en, this message translates to:
  /// **'comment'**
  String get commentlabel;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @viewReply.
  ///
  /// In en, this message translates to:
  /// **'View Reply'**
  String get viewReply;

  /// No description provided for @viewMore.
  ///
  /// In en, this message translates to:
  /// **'View More'**
  String get viewMore;

  /// No description provided for @noCommentsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No comments available.'**
  String get noCommentsAvailable;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @newsLabel.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get newsLabel;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @nodatafoundforthissection.
  ///
  /// In en, this message translates to:
  /// **'No data found for this section'**
  String get nodatafoundforthissection;

  /// No description provided for @pleaseCheckYourMobileDataOrWifiConnection.
  ///
  /// In en, this message translates to:
  /// **'Please Check your mobile data or wifi connection'**
  String get pleaseCheckYourMobileDataOrWifiConnection;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No Internet'**
  String get noInternet;

  /// No description provided for @noBookMarkFOund.
  ///
  /// In en, this message translates to:
  /// **'No Bookmarks found'**
  String get noBookMarkFOund;

  /// No description provided for @okLabel.
  ///
  /// In en, this message translates to:
  /// **'ok'**
  String get okLabel;

  /// No description provided for @authenticationFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication Failed'**
  String get authenticationFailed;

  /// No description provided for @newsBy.
  ///
  /// In en, this message translates to:
  /// **'News by'**
  String get newsBy;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @by.
  ///
  /// In en, this message translates to:
  /// **'by'**
  String get by;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @relatedPosts.
  ///
  /// In en, this message translates to:
  /// **'Related Posts'**
  String get relatedPosts;

  /// No description provided for @noChannelsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No channels available'**
  String get noChannelsAvailable;

  /// No description provided for @newest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get newest;

  /// No description provided for @mostViewed.
  ///
  /// In en, this message translates to:
  /// **'Most Viewed'**
  String get mostViewed;

  /// No description provided for @mostRead.
  ///
  /// In en, this message translates to:
  /// **'Most Read'**
  String get mostRead;

  /// No description provided for @noTopicsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No topics available'**
  String get noTopicsAvailable;

  /// No description provided for @underMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Under Maintenance'**
  String get underMaintenance;

  /// No description provided for @sorryTheappisundermaintenance.
  ///
  /// In en, this message translates to:
  /// **'Sorry, the app is under maintenance'**
  String get sorryTheappisundermaintenance;

  /// No description provided for @failedToPickImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image'**
  String get failedToPickImage;

  /// No description provided for @noChangesToNameAndImage.
  ///
  /// In en, this message translates to:
  /// **'No Changes to Name and Image'**
  String get noChangesToNameAndImage;

  /// No description provided for @failedToSaveUpdatedProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to save updated profile'**
  String get failedToSaveUpdatedProfile;

  /// No description provided for @topics.
  ///
  /// In en, this message translates to:
  /// **'Topics'**
  String get topics;

  /// No description provided for @emailIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailIsRequired;

  /// No description provided for @passwordIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordIsRequired;

  /// No description provided for @passwordMustBeAtLeast8CharactersLong.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long'**
  String get passwordMustBeAtLeast8CharactersLong;

  /// No description provided for @passwordMustContainAtLeastOneUppercaseLetter.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get passwordMustContainAtLeastOneUppercaseLetter;

  /// No description provided for @passwordMustContainAtLeastOneLowercaseLetter.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter'**
  String get passwordMustContainAtLeastOneLowercaseLetter;

  /// No description provided for @passwordMustContainAtLeastOneDigit.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one digit'**
  String get passwordMustContainAtLeastOneDigit;

  /// No description provided for @passwordMustContainAtLeastOneSpecialCharacter.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one special character'**
  String get passwordMustContainAtLeastOneSpecialCharacter;

  /// No description provided for @pleaseReEnterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Please re-enter your password'**
  String get pleaseReEnterYourPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @nameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameIsRequired;

  /// No description provided for @validEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get validEmail;

  /// No description provided for @fromChannelsYouFollowed.
  ///
  /// In en, this message translates to:
  /// **'From Channels You Followed'**
  String get fromChannelsYouFollowed;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @wind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get wind;

  /// No description provided for @pressure.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get pressure;

  /// No description provided for @editingComment.
  ///
  /// In en, this message translates to:
  /// **'Editing Comment'**
  String get editingComment;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @reportComment.
  ///
  /// In en, this message translates to:
  /// **'Report Comment'**
  String get reportComment;

  /// No description provided for @yourComment.
  ///
  /// In en, this message translates to:
  /// **'Your Comment'**
  String get yourComment;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @speakLoud.
  ///
  /// In en, this message translates to:
  /// **'Speak Loud'**
  String get speakLoud;

  /// No description provided for @clickHereToReadMore.
  ///
  /// In en, this message translates to:
  /// **'Click here to read more'**
  String get clickHereToReadMore;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @doYouWantToDeleteYourAccountWithThisAction.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete your account with this action?'**
  String get doYouWantToDeleteYourAccountWithThisAction;

  /// No description provided for @currentSize.
  ///
  /// In en, this message translates to:
  /// **'Current Size'**
  String get currentSize;

  /// No description provided for @aLable.
  ///
  /// In en, this message translates to:
  /// **'A'**
  String get aLable;

  /// No description provided for @selectLanguages.
  ///
  /// In en, this message translates to:
  /// **'Select Languages'**
  String get selectLanguages;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noLanguagesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No languages available'**
  String get noLanguagesAvailable;

  /// No description provided for @continueWith.
  ///
  /// In en, this message translates to:
  /// **'Continue with'**
  String get continueWith;

  /// No description provided for @languages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// No description provided for @selectLanguagesToContinue.
  ///
  /// In en, this message translates to:
  /// **'Select languages to continue'**
  String get selectLanguagesToContinue;

  /// No description provided for @signInToAccessAllFeatures.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access all features'**
  String get signInToAccessAllFeatures;

  /// No description provided for @tapToEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Tap to edit profile'**
  String get tapToEditProfile;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @newsLanguages.
  ///
  /// In en, this message translates to:
  /// **'News Languages'**
  String get newsLanguages;

  /// No description provided for @transaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transaction;

  /// No description provided for @textSize.
  ///
  /// In en, this message translates to:
  /// **'Text Size'**
  String get textSize;

  /// No description provided for @supportAndAbout.
  ///
  /// In en, this message translates to:
  /// **'Support & About'**
  String get supportAndAbout;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get month;

  /// No description provided for @adFreeExperience.
  ///
  /// In en, this message translates to:
  /// **'Ad-free experience'**
  String get adFreeExperience;

  /// No description provided for @accessTo.
  ///
  /// In en, this message translates to:
  /// **'Access to'**
  String get accessTo;

  /// No description provided for @articles.
  ///
  /// In en, this message translates to:
  /// **'articles'**
  String get articles;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @selectDuration.
  ///
  /// In en, this message translates to:
  /// **'Select Duration'**
  String get selectDuration;

  /// No description provided for @membership.
  ///
  /// In en, this message translates to:
  /// **'MEMBERSHIP'**
  String get membership;

  /// No description provided for @tapToViewMembershipOptions.
  ///
  /// In en, this message translates to:
  /// **'Tap to view membership options'**
  String get tapToViewMembershipOptions;

  /// No description provided for @buyPlan.
  ///
  /// In en, this message translates to:
  /// **'Buy Plan'**
  String get buyPlan;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @couldNotLoadSubscriptionDetails.
  ///
  /// In en, this message translates to:
  /// **'Could not load subscription details'**
  String get couldNotLoadSubscriptionDetails;

  /// No description provided for @na.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get na;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get months;

  /// No description provided for @expiresOn.
  ///
  /// In en, this message translates to:
  /// **'Expires On'**
  String get expiresOn;

  /// No description provided for @adsFree.
  ///
  /// In en, this message translates to:
  /// **'Ads Free'**
  String get adsFree;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @remainingDays.
  ///
  /// In en, this message translates to:
  /// **'Remaining Days'**
  String get remainingDays;

  /// No description provided for @youreachedPostLimitBuyPlan.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached your free post limit, Buy Plan'**
  String get youreachedPostLimitBuyPlan;

  /// No description provided for @youreachedStoriesLimitBuyPlan.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached your free story limit, Buy Plan'**
  String get youreachedStoriesLimitBuyPlan;

  /// No description provided for @limitReached.
  ///
  /// In en, this message translates to:
  /// **'Limit Reached'**
  String get limitReached;

  /// No description provided for @oKGotIt.
  ///
  /// In en, this message translates to:
  /// **'OK, Got it'**
  String get oKGotIt;

  /// No description provided for @discoverChannels.
  ///
  /// In en, this message translates to:
  /// **'Discover Channels'**
  String get discoverChannels;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @noTransactionsYet.
  ///
  /// In en, this message translates to:
  /// **'No Transactions Yet'**
  String get noTransactionsYet;

  /// No description provided for @onceYouStartMakingTransactions.
  ///
  /// In en, this message translates to:
  /// **'Once you start making transactions, they\'ll show up here.'**
  String get onceYouStartMakingTransactions;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @extraSmall.
  ///
  /// In en, this message translates to:
  /// **'Extra Small'**
  String get extraSmall;

  /// No description provided for @small.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get small;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @large.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get large;

  /// No description provided for @extraLarge.
  ///
  /// In en, this message translates to:
  /// **'Extra Large'**
  String get extraLarge;

  /// No description provided for @selectFontSize.
  ///
  /// In en, this message translates to:
  /// **'Select Font Size'**
  String get selectFontSize;

  /// No description provided for @includedFeatures.
  ///
  /// In en, this message translates to:
  /// **'Included Features'**
  String get includedFeatures;

  /// No description provided for @noPlansAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Plans Available'**
  String get noPlansAvailable;

  /// No description provided for @noPlansDescription.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find any membership plans at the moment. Please try again later.'**
  String get noPlansDescription;

  /// No description provided for @isCurrentlyEmpty.
  ///
  /// In en, this message translates to:
  /// **'is Currently Empty'**
  String get isCurrentlyEmpty;

  /// No description provided for @noContentAvailable.
  ///
  /// In en, this message translates to:
  /// **'Looks like there\'s no content available at the moment. Check back later or try refreshing.'**
  String get noContentAvailable;

  /// No description provided for @youReachThePostLimit.
  ///
  /// In en, this message translates to:
  /// **'You Reach The Post Limit'**
  String get youReachThePostLimit;

  /// No description provided for @youReachTheStoryLimit.
  ///
  /// In en, this message translates to:
  /// **'You Reach The Story Limit'**
  String get youReachTheStoryLimit;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @videoNews.
  ///
  /// In en, this message translates to:
  /// **'Video News'**
  String get videoNews;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'bn', 'en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
