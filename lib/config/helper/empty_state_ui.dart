
import 'package:flutter/material.dart';
import 'package:newsapp/config/colors.dart';



import '../../../l10n/app_localizations.dart';
import '../constants.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final IconData icon;
  final Widget? customImage;
  final Function()? onButtonPressed;
  final bool showButton;
  final double? imageSize;
  final EdgeInsets padding;

  // Second button properties
  final String? secondButtonText;
  final Function()? onSecondButtonPressed;
  final String? routeToNavigate;

  const EmptyStateWidget({
    super.key,
    this.title = 'Nothing to see here',
    this.message = 'Looks like there\'s no content available at the moment. Check back later or try refreshing.',
    this.buttonText = 'Refresh',
    this.icon = Icons.inbox_outlined,
    this.customImage,
    this.onButtonPressed,
    this.showButton = true,
    this.imageSize = 120,
    this.padding = const EdgeInsets.symmetric(horizontal: 32),
    this.secondButtonText,
    this.onSecondButtonPressed,
    this.routeToNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Custom image or animated container with icon
          customImage ?? _buildAnimatedContainer(context),

          const SizedBox(height: 24),

          // Title with subtle animation
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: fontType,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: 0.3,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Description with fade-in animation
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: child,
              );
            },
            child: Text(
              AppLocalizations.of(context)!.noContentAvailable,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: fontType,
                fontSize: 16,
                height: 1.2,
                color: AppColors(context).isDark ? Colors.grey[350] : Colors.grey[600],
              ),
            ),
          ),

          if (showButton || secondButtonText != null) const SizedBox(height: 32),

          // Buttons row with primary and optional secondary button
          if (showButton || secondButtonText != null)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: child,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Primary button
                  if (showButton)
                    _buildButton(
                      context,
                      buttonText,
                      onButtonPressed ?? () {

                      },
                      isPrimary: true,
                    ),

                  // Space between buttons
                  if (showButton && secondButtonText != null)
                    const SizedBox(width: 16),

                  // Optional secondary button (for navigation)
                  if (secondButtonText != null)
                    _buildButton(
                      context,
                      secondButtonText!,
                      onSecondButtonPressed ?? () {
                        // Navigate to route if provided
                        if (routeToNavigate != null) {
                          Navigator.of(context).pushNamed(routeToNavigate!);
                        }
                      },
                      isPrimary: false,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Animated icon container with subtle pulse effect
  Widget _buildAnimatedContainer(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.95, end: 1.05),
      duration: const Duration(milliseconds: 2000),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Container(
        width: imageSize,
        height: imageSize,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(imageSize! / 2),
        ),
        child: Icon(
          icon,
          size: imageSize! * 0.5,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  // Attractive button with hover effect
  Widget _buildButton(BuildContext context, String text, Function() onPressed, {bool isPrimary = true}) {


    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: isPrimary
                ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors().primaryColor,
                Colors.red
              ],
            )
                : null,
            color: isPrimary ? null : Colors.transparent,
            border: isPrimary
                ? null
                : Border.all(
              color: AppColors().primaryColor,
              width: 1.5,
            ),
            boxShadow: isPrimary
                ? [
              BoxShadow(
                color: AppColors().primaryColor.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ]
                : null,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: fontType,
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}