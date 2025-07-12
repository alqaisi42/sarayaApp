
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/config/colors.dart';



import '../../../bloc/memberShipPlanBloc/membership_bloc.dart';

import '../../../bloc/memberShipPlanBloc/membership_state.dart';
import '../../../config/helper/helper_functions.dart';

import '../../../l10n/app_localizations.dart';


class MembershipCard extends StatefulWidget {
  const MembershipCard({super.key});

  @override
  State<MembershipCard> createState() => _MembershipCardState();
}

class _MembershipCardState extends State<MembershipCard> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late AnimationController _patternController;
  Animation<double>? _patternAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _patternController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _patternAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_patternController);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _patternController.repeat();

    // Fetch membership data when widget initializes

  }

  @override
  void dispose() {
    _controller.dispose();
    _patternController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MembershipBloc, MembershipState>(
      builder: (context, state) {
        return GestureDetector(
          onTapDown: (_) {
            setState(() {
              _isPressed = true;
            });
            _controller.forward();
          },
          onTapUp: (_) {
            setState(() {
              _isPressed = false;
            });
            _controller.reverse();
          },
          onTapCancel: () {
            setState(() {
              _isPressed = false;
            });
            _controller.reverse();
          },
          onTap: () {
            GoRouter.of(context).push('/membershipScreen');
          },
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              );
            },
            child: Container(
              width: double.infinity,
              height: MediaQueryHelper.screenHeight(context) * 0.29,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.blueGrey, AppColors.blueGrey.withValues(alpha:0.5)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _isPressed
                        ? AppColors.blueGrey.withValues(alpha:0.4)
                        : AppColors.blueGrey.withValues(alpha:0.2),
                    blurRadius: _isPressed ? 15 : 20,
                    offset: Offset(0, _isPressed ? 4 : 8),
                    spreadRadius: _isPressed ? 1 : 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Background pattern
                    Positioned.fill(
                      child: CustomPaint(
                        painter: AnimatedCardPatternPainter(_patternAnimation!),
                      ),
                    ),
                    // Decorative elements
                    Positioned(
                      top: -20,
                      right: -20,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha:0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -40,
                      left: -20,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha:0.05),
                        ),
                      ),
                    ),
                    // Card content
                    Padding(
                      padding:  EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Header with status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getPlanName(state,context),
                                    style: TextStyle(
                                      color: Color(0xFFF0F0F0),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    AppLocalizations.of(context)!.membership,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ],
                              ),
                              _buildStatusTag(state),
                            ],
                          ),

                          // Subscription info
                          _buildSubscriptionInfo(state),

                          SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.01,),

                          // Bottom row with benefits
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [


                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha:0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.touch_app,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                   SizedBox(width: 8),
                                   Text(
                                     AppLocalizations.of(context)!.tapToViewMembershipOptions,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Shine effect
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withValues(alpha:0.3),
                              Colors.white.withValues(alpha:0.0),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    // Accent line
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 80,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(5),
                            topLeft: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getPlanName(MembershipState state,context) {
    if (state is MembershipSuccessState && state.membershipPlanData[0].data.activeSubscription.planName != '') {
      return state.membershipPlanData[0].data.activeSubscription.planName;
    }
    return AppLocalizations.of(context)!.buyPlan;
  }

  Widget _buildStatusTag(MembershipState state) {
    bool isActive = false;

    if (state is MembershipSuccessState) {
      isActive = state.membershipPlanData[0].data.activeSubscription.status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [Color(0xFFFFC107), Color(0xFFFF9800)]
              : [Colors.red, Colors.redAccent],

          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.star, color: Colors.white, size: 16),
          SizedBox(width: 4),
          Text(
            isActive ? AppLocalizations.of(context)!.active : AppLocalizations.of(context)!.inactive,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionInfo(MembershipState state) {
    if (state is MembershipLoadingState) {
      return Center(child: CircularProgressIndicator(color: Colors.white));
    } else if (state is MembershipErrorState) {

      return Text(
        state.errorMessage,
        style: TextStyle(color: Colors.white),
      );
    } else if (state is MembershipSuccessState) {

      final subscription = state.membershipPlanData[0].data.activeSubscription;

      // Format dates
      String formattedEndDate = AppLocalizations.of(context)!.na;
      int remainingDays = 0;

      try {
        final DateTime endDate = DateTime.parse(subscription.endDate);
        formattedEndDate = DateFormat('MMM dd, yyyy').format(endDate);

        // Calculate remaining days
        final DateTime now = DateTime.now();
        remainingDays = endDate.difference(now).inDays;
        remainingDays = remainingDays < 0 ? 0 : remainingDays; // Ensure it's not negative
      } catch (e) {

        formattedEndDate = subscription.endDate;
      }

      try{
        return Column(
          children: [
            // First row - Original information with remaining days instead of ads free
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.duration,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha:0.7),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${subscription.duration} ${AppLocalizations.of(context)!.months}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.expiresOn,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha:0.7),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      formattedEndDate.isNotEmpty ? formattedEndDate : AppLocalizations.of(context)!.na,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.remainingDays,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha:0.7),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '$remainingDays',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Small divider with spacing
            SizedBox(height: 10),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.white.withValues(alpha:0.1),
            ),
            SizedBox(height: 10),

            // Second row - Article & Story information & Ads Free
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildUsageStats(
                  Icons.article_outlined,
                  '${subscription.articleCount}/${subscription.maxArticles}',
                  AppLocalizations.of(context)?.articles ?? 'Articles',
                ),
                Container(
                  height: 24,
                  width: 1,
                  color: Colors.white.withValues(alpha:0.1),
                ),
                _buildUsageStats(
                  Icons.web_stories_outlined,
                  '${subscription.storyCount}/${subscription.maxStories}',
                  AppLocalizations.of(context)?.stories ?? 'Stories',
                ),
                Container(
                  height: 24,
                  width: 1,
                  color: Colors.white.withValues(alpha:0.1),
                ),
                _buildUsageStats(
                  Icons.block_outlined, // or Icons.ads_click
                  subscription.isAdsActive == true ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no,
                  AppLocalizations.of(context)!.adsFree,
                ),
              ],
            ),
          ],
        );
      }catch(e){

        return Container();
      }

    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildUsageStats(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white.withValues(alpha:0.8),
          size: 18,
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha:0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }



}



class AnimatedCardPatternPainter extends CustomPainter {
  final Animation<double> animation;

  AnimatedCardPatternPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final animValue = animation.value;

    // Animated diagonal stripes with phase shift
    final stripePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 7; i++) {
      // Apply animation to shift the stripes slightly
      final offset = sin(animValue * 2 * pi + i * 0.2) * size.width * 0.01;

      final path = Path()
        ..moveTo(size.width * 0.1 * i + offset, 0)
        ..lineTo(size.width * 0.1 * i + size.width * 0.15 + offset, 0)
        ..lineTo(size.width * 0.1 * i + size.width * 0.3 + offset, size.height)
        ..lineTo(size.width * 0.1 * i + size.width * 0.15 + offset, size.height)
        ..close();

      canvas.drawPath(path, stripePaint);
    }

    // Animated curved lines that move slightly
    final curvePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;

    // First curve - moves in a small circular pattern
    final curve1Offset = Offset(
        sin(animValue * 2 * pi) * size.width * 0.02,
        cos(animValue * 2 * pi) * size.height * 0.02
    );

    final path1 = Path();
    path1.moveTo(size.width * 0.8 + curve1Offset.dx, size.height * 0.2 + curve1Offset.dy);
    path1.quadraticBezierTo(
        size.width * 0.9 + curve1Offset.dx * 0.8,
        size.height * 0.5 + curve1Offset.dy * 0.8,
        size.width * 0.7 + curve1Offset.dx * 0.6,
        size.height * 0.8 + curve1Offset.dy * 0.6
    );
    canvas.drawPath(path1, curvePaint);

    // Second curve - moves in an opposite phase
    final curve2Offset = Offset(
        sin(animValue * 2 * pi + pi) * size.width * 0.02,
        cos(animValue * 2 * pi + pi) * size.height * 0.02
    );

    final path2 = Path();
    path2.moveTo(size.width * 0.2 + curve2Offset.dx, size.height * 0.1 + curve2Offset.dy);
    path2.quadraticBezierTo(
        size.width * 0.1 + curve2Offset.dx * 0.8,
        size.height * 0.4 + curve2Offset.dy * 0.8,
        size.width * 0.3 + curve2Offset.dx * 0.6,
        size.height * 0.7 + curve2Offset.dy * 0.6
    );
    canvas.drawPath(path2, curvePaint);

    // Animated dots pattern with pulsating effect
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 30; i++) {
      final x = (i * 17) % size.width;
      final y = ((i * 23) % size.height);

      // Make dots pulsate with different phases
      final pulseFactor = sin(animValue * 2 * pi + i * 0.2) * 0.3 + 0.7;
      final baseRadius = (i % 3) * 2.0 + 1.0;
      final radius = baseRadius * pulseFactor;

      canvas.drawCircle(Offset(x, y), radius, dotPaint);
    }

    // Additional subtle animated wave
    final wavePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    final wavePath = Path();
    wavePath.moveTo(0, size.height * 0.5 + sin(animValue * 2 * pi) * size.height * 0.05);

    for (int i = 0; i <= 10; i++) {
      final phase = i / 10;
      final waveX = size.width * phase;
      final waveY = size.height * 0.5 +
          sin(animValue * 2 * pi + phase * 4 * pi) * size.height * 0.05;

      wavePath.lineTo(waveX, waveY);
    }

    canvas.drawPath(wavePath, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}