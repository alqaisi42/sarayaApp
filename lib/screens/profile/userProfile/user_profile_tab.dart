
import 'package:flutter/material.dart';
import '../../../config/constants.dart';
import '../../../config/helper/helper_functions.dart';


class Userprofile extends StatelessWidget {
  final String profileImage;
  final String profileName;

  final IconData profileIcon2;
  const Userprofile({super.key, required this.profileImage, required this.profileName, required this.profileIcon2});

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQueryHelper.screenWidth(context) * 0.03,
            vertical: MediaQueryHelper.screenHeight(context) * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQueryHelper.screenWidth(context) * 0.14,
                  height: MediaQueryHelper.screenHeight(context) * 0.06,
                  child: ClipOval(
                    child: ImageUtils.networkImage(profileImage,width:  MediaQueryHelper.screenWidth(context), height: MediaQueryHelper.screenHeight(context),fit: BoxFit.cover)
                 ,
                  )
                ),
                SizedBox(width: MediaQueryHelper.screenWidth(context) * 0.03),
                Text(
                  profileName,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: fontType),
                ),
              ],
            ),
            Icon(profileIcon2),
          ],
        ),
      ),
    );
  }
}
