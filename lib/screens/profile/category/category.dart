 import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsapp/config/colors.dart';


import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/newsTopicsBloc/news_topic_bloc.dart';
import '../../../bloc/newsTopicsBloc/news_topic_event.dart';
import '../../../bloc/newsTopicsBloc/news_topic_state.dart';
import '../../../config/check_internet.dart';
import '../../../config/constants.dart';
import '../../../config/helper/empty_state_ui.dart';
import '../../../config/helper/helper_functions.dart';
import '../../../config/shimmer.dart';
import '../../../utils/widgets/no_internet_screen.dart';
 import '../../../l10n/app_localizations.dart';




class CategorySection extends StatefulWidget {
   const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  // For Internet Check
  List<ConnectivityResult> _connectionStatus = [];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;


   @override
  void initState() {
    super.initState();


    CheckInternet.initConnectivity().then((List<ConnectivityResult> results) {
      if (results.isNotEmpty) {

        setState(() {
          _connectionStatus = results;
        });
      }
    });

    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty) {

        CheckInternet.updateConnectionStatus(results).then((value) {
          setState(() {
            _connectionStatus = value;
            context.read<NewsTopicBloc>().add(FetchNewsTopic(refreshIndicator: true));
          });
        });
      }
    });

  }

   Future<void> _refreshContent(BuildContext context) async {
     context.read<NewsTopicBloc>().add(FetchNewsTopic(refreshIndicator: true));
   }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

   @override
   Widget build(BuildContext context) {
     return _connectionStatus.contains(connectivityCheck)
         ? NoInternetScreen()
         :  Scaffold(
       appBar: AppBar(
         title: Text(AppLocalizations.of(context)!.topics),
       ),
       body: BlocBuilder<NewsTopicBloc, NewstopicState>(
         builder: (context, state) {
           if (state is NewstopicLoadingState) {
             return _buildLoadingShimmer(context);
           } else if (state is NewstopicSuccessState) {
             final categories = state.newsTopic
                 .expand((topic) => topic.data ?? [])
                 .toList();

             if(categories.isEmpty){
               return EmptyStateWidget(
                 title: '${AppLocalizations.of(context)?.topics} ${AppLocalizations.of(context)!.isCurrentlyEmpty}',
                 customImage: Image.asset(
                   'assets/img/empty.png',
                   width: MediaQueryHelper.screenWidth(context) * 0.65,
                 ),
                   buttonText:AppLocalizations.of(context)!.retry,
                 onButtonPressed: () {
                   _refreshContent(context);
                 },

               );
             }

             return RefreshIndicator(
               onRefresh: () => _refreshContent(context),
               color: AppColors().primaryColor,
               child: Padding(
                 padding: EdgeInsets.symmetric(
                   horizontal: MediaQueryHelper.screenWidth(context) * 0.04,
                 ),
                 child: GridView.builder(
                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisCount: 2, // Two columns
                     crossAxisSpacing: MediaQueryHelper.screenWidth(context) * 0.04,
                     mainAxisSpacing: MediaQueryHelper.screenHeight(context) * 0.02,
                     mainAxisExtent: MediaQueryHelper.screenHeight(context) * 0.15,
                   ),
                   itemCount: categories.length,
                   itemBuilder: (context, index) {
                     final category = categories[index];
                     return GestureDetector(
                       onTap: () {


                         GoRouter.of(context).push('/categoryData/${category.name}');
                       },
                       child: CategoryItem(category: category),
                     );
                   },
                 ),
               ),
             );
           } else if (state is NewstopicErrorState) {
             return Center(child: Text(state.errorMessage,style: TextStyle(fontFamily: fontType),));
           } else {
             return Center(child: Text(AppLocalizations.of(context)!.noTopicsAvailable,style: TextStyle(fontFamily: fontType),));
           }
         },
       ),
     );

   }
}

 class CategoryItem extends StatelessWidget {
   final dynamic category;

   const CategoryItem({required this.category, super.key});

   @override
   Widget build(BuildContext context) {
     return Container(
       decoration: BoxDecoration(
         image: DecorationImage(
           image: ImageUtils.networkImageProvider(category.logo),
           fit: BoxFit.cover,
         ),
         borderRadius: BorderRadius.circular(10.0),
       ),
       child: Container(
         alignment: Alignment.center,
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(10.0),
           color: Colors.black.withValues(alpha:0.5),
         ),
         child: Text(
           category.name ?? '',
           style:  TextStyle(
             color: Colors.white,
             fontSize: 16.0,
             fontWeight: FontWeight.bold,
             fontFamily: fontType
           ),
           textAlign: TextAlign.center,
         ),
       ),
     );
   }
 }


 Widget _buildLoadingShimmer(context) {
   return GridView.builder(
     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
       crossAxisCount: 2, // Two columns
       crossAxisSpacing: MediaQuery.of(context).size.width * 0.03,
       mainAxisSpacing: MediaQuery.of(context).size.height * 0.02,
       mainAxisExtent: MediaQuery.of(context).size.height * 0.15, // Adjust height of each shimmer
     ),
     itemCount: 10, // 2 columns * 5 rows
     itemBuilder: (context, index) {
       return ShimmerWidget(
         width: MediaQuery.of(context).size.width * 0.45, // Adjusted to fit two columns
         height: MediaQuery.of(context).size.height * 0.5,
         margin:EdgeInsets.only(
           top: MediaQuery.of(context).size.height * 0,
           left: MediaQuery.of(context).size.width * 0.02,
           right: MediaQuery.of(context).size.width * 0.02,
         ) ,
       );
     },
   );
 }
