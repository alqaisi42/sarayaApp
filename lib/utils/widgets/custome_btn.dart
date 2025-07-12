import 'package:flutter/material.dart';

import '../../config/colors.dart';
import '../../config/constants.dart';
import '../../config/helper/helper_functions.dart';


class LoginBtn extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String btnName;

  const LoginBtn(
      {super.key,
      required this.onPressed,
      this.isLoading = false,
      required this.btnName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding:
              EdgeInsets.symmetric(vertical: MediaQueryHelper.screenHeight(context) * 0.01),
          backgroundColor: AppColors().primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ?  CircularProgressIndicator(color: AppColors().primaryColor)
            : Text(
                btnName,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: fontType),
              ),
      ),
    );
  }
}
