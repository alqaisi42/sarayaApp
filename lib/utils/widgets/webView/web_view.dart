import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:webview_flutter/webview_flutter.dart';

import '../../../bloc/followedChannelsPostBloc/followed_channels_post_bloc.dart';
import '../../../bloc/followedChannelsPostBloc/followed_channels_post_event.dart';
import '../../../bloc/memberShipPlanBloc/membership_bloc.dart';
import '../../../bloc/memberShipPlanBloc/membership_event.dart';
import '../../../bloc/popularHomeNewsBloc/popular_news_home_bloc.dart';
import '../../../bloc/popularHomeNewsBloc/popular_news_home_event.dart';
import '../../../bloc/recommendationNewsBloc/recommendation_bloc.dart';
import '../../../bloc/recommendationNewsBloc/recommendation_event.dart';
import '../../../config/helper/helper_functions.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({super.key, required this.url, required this.title});

  @override
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  late final WebViewController controller;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();

    final fixedUrl = normalizeUrl(widget.url); // Normalize first

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            isLoading.value = true;
          },
          onPageFinished: (String url) {
            isLoading.value = false;
            if (mounted && (url.contains('success') || url.contains('completed'))) {
              context.read<MembershipBloc>().add(FetchMembershipPlans());
              context.read<PopularBloc>().add(FetchPopular(refreshIndicator: true, context: context));
              context.read<RecommendationBloc>().add(FetchRecommendation(refreshIndicator: true, context: context));
              context.read<FollowedChannelsPostBloc>().add(FetchFollowedChannelsPost(context: context));
              Navigator.pop(context, true);
              CustomFloatingSnackBar.showCustomSnackBar(context, 'Payment Successful', 1);
            }
          },
          onWebResourceError: (WebResourceError error) {
            isLoading.value = false;
            CustomFloatingSnackBar.showCustomSnackBar(context, error.description, 1);
          },
        ),
      )
      ..loadRequest(Uri.parse(fixedUrl));
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => controller.reload(),
            ),
          ],
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: controller),
            ValueListenableBuilder<bool>(
              valueListenable: isLoading,
              builder: (context, isLoading, child) {
                return isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox.shrink();
              },
            ),
          ],
        ),
      );

  }
}
// lib/shared/helpers/url_helper.dart
String normalizeUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null || uri.scheme.isEmpty) {
    return 'https://$url';
  }
  return url;
}

// class WebViewPageState extends State<WebViewPage> {
//   late final WebViewController _controller;
//   final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = WebViewController()
//     ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (_) {
//             _isLoading.value = true;
//           },
//           onPageFinished: (_) {
//             _isLoading.value = false;
//           },
//           onWebResourceError: (error) {
//             _isLoading.value = false;
//             // Optional: handle errors here
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(widget.url));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Stack(
//         children: [
//           WebViewWidget(controller: _controller),
//           ValueListenableBuilder<bool>(
//             valueListenable: _isLoading,
//             builder: (context, isLoading, child) {
//               return isLoading
//                   ? Center(child: CircularProgressIndicator())
//                   : SizedBox.shrink();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
