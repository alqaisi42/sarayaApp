

import 'constants.dart';

// Auth Api
const String loginUrl = "$apiUrl/firebaseauth";
const String createAccountUrl = "$apiUrl/register?";
const String loginWIthEmail = "$apiUrl/login?";

// Home Page Api
const String sliderUrl = "$apiUrl/fetch-feeds/banner";
const String popularNewsAllUrl = "$apiUrl/fetch-feeds/populer";
const String channelsUrl = "$apiUrl/fetch-feeds/channels";
const String favoritesURL = "$apiUrl/favorites";
const String favoritesAddURL = "$apiUrl/favorites/add";
const String favoritesRemoveURL = "$apiUrl/favorites/remove";
const String recommendationNewsURL = "$apiUrl/fetch-feeds/recommended";
const String newsTopicUrl = "$apiUrl/fetch-feeds/topics";
const String breakingNewsUrl = "$apiUrl/fetch-feeds/topic/12";
const String categoryUrl = "$apiUrl/fetch-feeds/topic/";
const String getChannelPageUrl = "$apiUrl/fetch-feeds/channels";
const String channelPageDataUrl = "$apiUrl/fetch-feeds/channel/posts";
const String notificationUrl = "$apiUrl/notifications";
const String storeFcmUrl = "$apiUrl/store-fcm";
const String followedChannelsPostUrl = "$apiUrl/fetch-feeds/followerd-channels-post";
const String getStoriesUrl = "$apiUrl/stories";
const String newsLanguagesUrl = "$apiUrl/news-languages";
const String getPostsLanguageUrl = "$apiUrl/get-posts-by-language";

// Detail Page Api
const String detailPageUrl = "$apiUrl/fetch-post/descriptions/";
const String postCommentUrl = "$apiUrl/commets";
const String getCommentUrl = "$apiUrl/commets";
const String getCommentReplyUrl = "$apiUrl/commets/replies";
const String deleteCommentUrl = "$apiUrl/delete-comment";
const String editCommentUrl = "$apiUrl/commets/update";
const String reportCommentUrl = "$apiUrl/commets/report";
const String postEmojiUrl = "$apiUrl/react";
const String userReactorsUrl = "$apiUrl/get-reactors";

// Bookmark Page Api
const String bookmarkUrl = "$apiUrl/favorites/posts";

// Discover Page Api
const String discoverNewsUrl = "$apiUrl/discover/posts";
const String suggestionUrl = "$apiUrl/search/suggestion";
const String searchUrl = "$apiUrl/search/result";

const String followAndUnfolloeUrl = "$apiUrl/subscribe-channel";
const String followChannelUrl = "$apiUrl/channel/subscribe";
const String unFollowChannelUrl = "$apiUrl/channel/unsubscribe";

// Profile Page Api
const String updateUserProfileUrl = "$apiUrl/user-profile-update";
const String getUserProfileUrl = "$apiUrl/get-profile";
const String userChannelsFollowedListUrl = "$apiUrl/user-channel-list";
const String contactUsUrl = "$apiUrl/contacts";
const String memberShipPlanUrl = "$apiUrl/membership_plan";
const String createStripeUrl = "$apiUrl/create-stripe-session";
const String transactionHistoryUrl = "$apiUrl/transaction-history";

// Delete User Api
const String deleteUserUrl = "$apiUrl/remove-account?device_id";

// Forgot Password Api
const String forgatePasswordUrl = "$apiUrl/password/email";

// Get Settings Api
const String getSettingUrl = "$apiUrl/get-system-settings";
const String paymentSettingUrl = "$apiUrl/payment-settings";
const String generateSignatureUrl = "$apiUrl/razorpay/generate-signature";
const String verifyPaymentUrl = "$apiUrl/razorpay/verify-payment";
const String subscriptionCountsUrl = "$apiUrl/content";
// Weather API
const String getWeatherUrl = "https://api.openweathermap.org/data/2.5/weather";



// Video API

const String getVideoNews = "$apiUrl/videos";












