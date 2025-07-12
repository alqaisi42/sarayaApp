// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:newsapp/config/constants.dart';

import '../../config/colors.dart';
import '../../config/helper/helper_functions.dart';







class MyTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?,BuildContext)? validator;

  const MyTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.validator,
    required this.keyboardType,
  });

  @override
  MyTextFieldState createState() => MyTextFieldState();
}

class MyTextFieldState extends State<MyTextField> {
  late bool _isPasswordVisible;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = false;
    _focusNode = FocusNode();

    // Add listener to handle focus changes
    _focusNode.addListener(() {
      setState(() {});
    });

    // Add listener for app lifecycle changes
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        resumeCallBack: () async {
          _unfocus();
          return Future.value(null);
        },
      ),
    );
  }

  void _unfocus() {
    _focusNode.unfocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    WidgetsBinding.instance.removeObserver(
      LifecycleEventHandler(
        resumeCallBack: () async {
          _unfocus();
          return Future.value(null);
        },
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocus,
      child: TextFormField(
        controller: widget.controller,
        obscureText: !_isPasswordVisible && widget.obscureText,
        keyboardType: widget.keyboardType,
        focusNode: _focusNode,

        // Add these properties to handle keyboard behavior
        textInputAction: TextInputAction.done,
        onEditingComplete: _unfocus,
        onTapOutside: (_) => _unfocus(),

        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: MediaQueryHelper.screenWidth(context) * 0.04,
            vertical: MediaQueryHelper.screenHeight(context) * 0.01,
          ),
          hintText: widget.label,
          filled: true,
          fillColor: Theme.of(context).colorScheme.primary,
          hintStyle: TextStyle(
            color: AppColors.greyColor,
            fontSize: 16,
            fontFamily: fontType,
            fontWeight: FontWeight.normal,
          ),
          suffixIcon: widget.obscureText && _focusNode.hasFocus
              ? IconButton(
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
          )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Colors.grey, // Default border color
              width: 1.0,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors().primaryColor,
            ),
          ),
        ),
        validator: (value) => widget.validator?.call(value, context),
      ),
    );
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final Future<void> Function() resumeCallBack;

  LifecycleEventHandler({
    required this.resumeCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await resumeCallBack();
    }
  }
}