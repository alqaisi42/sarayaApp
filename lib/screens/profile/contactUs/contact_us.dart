

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../bloc/contactUsBloc/conactus_state.dart';
import '../../../bloc/contactUsBloc/contactus_bloc.dart';
import '../../../bloc/contactUsBloc/contactus_event.dart';
import '../../../config/colors.dart';
import '../../../config/constants.dart';
import '../../../config/formvalidation.dart';
import '../../../config/helper/helper_functions.dart';
import '../../../utils/widgets/custom_textfield.dart';
import '../../../l10n/app_localizations.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}



class _ContactUsState extends State<ContactUs> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactUsBloc, ContactUsState>(
      listener: (context, state) {
        if (state is ContactUsLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => Center(
              child: CircularProgressIndicator(
                color: AppColors().primaryColor,
              ),
            ),
          );
        } else if (state is ContactUsSuccess) {
          Navigator.of(context).pop(); // Remove loading
         CustomFloatingSnackBar.showCustomSnackBar(context, state.contactUsData[0].message.toString(), 1);
          _emailController.clear();
          _messageController.clear();
        } else if (state is ContactUsError) {
          Navigator.of(context).pop(); // Remove loading
          CustomFloatingSnackBar.showCustomSnackBar(context, state.error, 0);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.contactUs),
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(50),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Top animation
                  SizedBox(
                    height: MediaQueryHelper.screenHeight(context) * 0.2,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: ContactAnimationPainter(
                              animation: _animationController.value,
                              primaryColor: AppColors().primaryColor,
                            ),
                            size: Size(MediaQuery.of(context).size.width, 180),
                          );
                        },
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQueryHelper.screenWidth(context) * 0.04,
                      vertical: 24,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Get in touch",
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontFamily: fontType,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "We'd love to hear from you. Send us a message and we'll respond as soon as possible.",
                            style: TextStyle(fontFamily: fontType, fontSize: 14),
                          ),
                          SizedBox(height: 32),

                          Text(
                            "Your Email",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: fontType,
                            ),
                          ),
                          SizedBox(height: 8),

                          // Email Field
                          MyTextField(
                            label: AppLocalizations.of(context)!.emial,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value, context) => validateEmail(value, context),
                            obscureText: false,
                          ),
                          SizedBox(height: 24),

                          // Message Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your Message",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: fontType,
                                ),
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: _messageController,
                                maxLines: 6,
                                minLines: 1,
                                keyboardType: TextInputType.multiline,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your message';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: MediaQueryHelper.screenWidth(context) * 0.04,
                                    vertical: MediaQueryHelper.screenHeight(context) * 0.01,
                                  ),
                                  hintText: 'Write your message here...',
                                  filled: true,
                                  fillColor: Theme.of(context).colorScheme.primary,
                                  hintStyle: TextStyle(
                                    color: AppColors.greyColor,
                                    fontSize: 16,
                                    fontFamily: fontType,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: AppColors().primaryColor, width: 2.0),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 32),

                          // Submit Button
                          AnimatedSubmitButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<ContactUsBloc>().add(
                                  ContactUsPost(
                                    userEmail: _emailController.text.trim(),
                                    userMessage: _messageController.text.trim(),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}



// Custom painter for the animated illustration
class ContactAnimationPainter extends CustomPainter {
  final double animation;
  final Color primaryColor;

  ContactAnimationPainter({required this.animation, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {


    // Background waves
    _drawWaves(canvas, size);

    // Draw stylized envelope
    _drawEnvelope(canvas, size);

    // Draw animated dots/particles
    _drawParticles(canvas, size);

    // Draw message icon
    _drawMessageIcon(canvas, size);
  }

  void _drawWaves(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor.withValues(alpha:0.1)
      ..style = PaintingStyle.fill;

    final path = Path();

    // First wave
    path.moveTo(0, size.height * 0.7);

    // Animated wave effect
    for (double i = 0; i <= size.width; i++) {
      path.lineTo(
          i,
          size.height * 0.7 +
              sin((i / size.width * 4 * pi) + (animation * 2 * pi)) * 15
      );
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Second wave (slightly different phase)
    final path2 = Path();
    final paint2 = Paint()
      ..color = primaryColor.withValues(alpha:0.15)
      ..style = PaintingStyle.fill;

    path2.moveTo(0, size.height * 0.75);

    for (double i = 0; i <= size.width; i++) {
      path2.lineTo(
          i,
          size.height * 0.75 +
              sin((i / size.width * 3 * pi) + (animation * 2 * pi) + 1) * 10
      );
    }

    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  void _drawEnvelope(Canvas canvas, Size size) {
    final centerX = size.width * 0.3;
    final centerY = size.height * 0.45;
    final envelopeWidth = size.width * 0.25;
    final envelopeHeight = envelopeWidth * 0.7;

    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Envelope body
    final rect = Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: envelopeWidth,
        height: envelopeHeight
    );

    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(8)),
        paint
    );

    // Envelope flap (animated)
    final flapPath = Path();
    final flapOpenAmount = 0.5 + 0.5 * sin(animation * 2 * pi);

    flapPath.moveTo(centerX - envelopeWidth/2, centerY - envelopeHeight/2);
    flapPath.lineTo(centerX, centerY - envelopeHeight/2 + (envelopeHeight/2 * flapOpenAmount));
    flapPath.lineTo(centerX + envelopeWidth/2, centerY - envelopeHeight/2);

    canvas.drawPath(flapPath, paint);

    // Line across the middle of the envelope (fold line)
    canvas.drawLine(
        Offset(centerX - envelopeWidth/2, centerY),
        Offset(centerX + envelopeWidth/2, centerY),
        paint..color = primaryColor.withValues(alpha:0.5)
    );
  }

  void _drawParticles(Canvas canvas, Size size) {
    // Draw 5 particles with varying positions
    for (int i = 1; i <= 5; i++) {
      final particleSize = 4.0 - i * 0.5;
      final xOffset = sin((animation * 2 * pi) + (i * 0.5)) * 30;
      final yOffset = cos((animation * 2 * pi) + (i * 0.7)) * 20;

      // Create a new Paint for each particle
      final particlePaint = Paint()
        ..color = primaryColor.withValues(alpha:0.7)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
          Offset(
              size.width * 0.7 + xOffset,
              size.height * 0.4 + yOffset
          ),
          particleSize,
          particlePaint
      );
    }
  }

  void _drawMessageIcon(Canvas canvas, Size size) {
    final centerX = size.width * 0.7;
    final centerY = size.height * 0.45;
    final iconSize = size.width * 0.2;

    final bubblePaint = Paint()
      ..color = primaryColor.withValues(alpha:0.2)
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Message bubble
    final bubblePath = Path();
    bubblePath.addRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(centerX, centerY),
                width: iconSize,
                height: iconSize * 0.8
            ),
            Radius.circular(12)
        )
    );

    // Add the little triangle at bottom
    final triangleSize = iconSize * 0.15;
    bubblePath.moveTo(centerX - triangleSize, centerY + (iconSize * 0.4) - triangleSize);
    bubblePath.lineTo(centerX, centerY + (iconSize * 0.4) + triangleSize);
    bubblePath.lineTo(centerX + triangleSize, centerY + (iconSize * 0.4) - triangleSize);
    bubblePath.close();

    // Draw the bubble
    canvas.drawPath(bubblePath, bubblePaint);
    canvas.drawPath(bubblePath, outlinePaint);

    // Draw some lines to represent text in the bubble
    final linePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Animated line positions
    final lineY1 = centerY - iconSize * 0.2 + sin(animation * 2 * pi) * 3;
    final lineY2 = centerY + cos(animation * 2 * pi) * 3;

    // Draw two lines
    canvas.drawLine(
        Offset(centerX - iconSize * 0.3, lineY1),
        Offset(centerX + iconSize * 0.3, lineY1),
        linePaint
    );

    canvas.drawLine(
        Offset(centerX - iconSize * 0.3, lineY2),
        Offset(centerX + iconSize * 0.15, lineY2),
        linePaint
    );
  }

  @override
  bool shouldRepaint(covariant ContactAnimationPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

// Animated submit button with ripple effect
class AnimatedSubmitButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AnimatedSubmitButton({super.key, required this.onPressed});

  @override
  State<AnimatedSubmitButton> createState() => _AnimatedSubmitButtonState();
}

class _AnimatedSubmitButtonState extends State<AnimatedSubmitButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: double.infinity,
              height: MediaQueryHelper.screenHeight(context) * 0.05,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors().primaryColor,
                    AppColors().primaryColor.withBlue(
                        (AppColors().primaryColor.b + 20).clamp(0, 255).toInt()
                    )

                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors().primaryColor.withValues(alpha:_isPressed ? 0.2 : 0.4),
                    blurRadius: _isPressed ? 5 : 15,
                    offset: Offset(0, _isPressed ? 2 : 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_rounded, size: 20, color: AppColors.whiteColor),
                  SizedBox(width: 8),
                  Text(
                    'Send Message',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: fontType,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}



