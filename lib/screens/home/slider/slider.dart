import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:heroicons_flutter/heroicons_flutter.dart';

import 'package:newsapp/config/colors.dart';
import 'package:newsapp/config/constants.dart';

import 'package:newsapp/Model/slider_model.dart';



import '../../../bloc/sliderBloc/slider_bloc.dart';
import '../../../bloc/sliderBloc/slider_event.dart';
import '../../../bloc/sliderBloc/slider_state.dart';
import '../../../config/helper/helper_functions.dart';
import '../../../config/shimmer.dart';


class CustomSlider extends StatefulWidget {
  const CustomSlider({super.key});

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  final CarouselSliderController carouselController = CarouselSliderController();
  int currentIndex = 0;

  @override
  void initState() {
    context.read<SliderBloc>().add(FetchSlider());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SliderBloc, SliderState>(
      builder: (context, state) {
        if (state is SliderLoadingState) {
          return ShimmerWidget(
            width: MediaQueryHelper.screenWidth(context),
            height: MediaQueryHelper.screenHeight(context) * 0.23,
            margin: EdgeInsets.only(
                left: MediaQueryHelper.screenWidth(context) * 0.04,
                right: MediaQueryHelper.screenWidth(context) * 0.04,
                top: MediaQueryHelper.screenHeight(context) * 0.01
            ),
          );
        } else if (state is SliderErrorState) {
          return Center(child: Text(state.errorMessage, style: TextStyle(fontFamily: fontType)));
        } else if (state is SliderSuccessState) {
          if(state.slider.isEmpty || state.slider[0].data.isEmpty) {
            return SizedBox.shrink();
          }
          return _buildSlider(state.slider);
        }
        return SizedBox.shrink(); // Default case
      },
    );
  }

  Widget _buildSlider(List<BannerPostsResponse> sliderData) {
    return Container(
      width: double.infinity,
      height: MediaQueryHelper.screenHeight(context) * 0.28,
      margin: EdgeInsets.only(
        left: MediaQueryHelper.screenWidth(context) * 0.04,
        right: MediaQueryHelper.screenWidth(context) * 0.04,
        top: MediaQueryHelper.screenHeight(context) * 0.01,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CarouselSlider(

              items: sliderData[0].data.map((item) {
                return GestureDetector(
                  onTap: () async{

                    checkLimitAndNavigate(context, item.slug.toString());

                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: ImageUtils.networkImageProvider(item.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                        width: double.infinity,
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: AppColors().primaryColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            item.topicName.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 12,fontFamily: fontType),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: MediaQueryHelper.screenWidth(context) * 0.04,
                                right: MediaQueryHelper.screenWidth(context) * 0.04,
                              ),
                              child: Text(
                                item.title.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: fontType,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.01),
                            Padding(
                              padding: EdgeInsets.only(
                                left: MediaQueryHelper.screenWidth(context) * 0.04,
                                bottom: MediaQueryHelper.screenHeight(context) * 0.01,
                              ),
                              child: Row(
                                children: [
                                  const Icon(HeroiconsOutline.clock, size: 20, color: Colors.white),
                                  SizedBox(width: MediaQueryHelper.screenWidth(context) * 0.02),
                                  Text(
                                    item.publishDate.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: fontType,
                                      shadows: [
                                        Shadow(
                                          offset: const Offset(1, 1),
                                          blurRadius: 3,
                                          color: Colors.black.withValues(alpha:0.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              carouselController: carouselController,
              options: CarouselOptions(
                scrollPhysics: const BouncingScrollPhysics(),

                autoPlay: true,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: sliderData[0].data.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => carouselController.animateToPage(entry.key),
                  child: Container(
                    width: currentIndex == entry.key ? 17.0 : 8.0,
                    height: 10.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentIndex == entry.key ? AppColors().primaryColor : AppColors.greyColor,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
