import 'package:flutter/cupertino.dart';

import '../../../../config/constants.dart';
import '../../../../config/helper/helper_functions.dart';


class UserAction extends StatelessWidget {
  final IconData actionIcon;
  final String txt;
  final int numVal;
  final Color? iconColor;
  const UserAction(
      {super.key,
        required this.actionIcon,
        required this.txt,
        required this.numVal,
        this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          actionIcon,
        ),
        SizedBox(
          width: MediaQueryHelper.screenWidth(context) * 0.02,
        ),
        Text(
          "${numVal == 0 ? "" : formatNumber(numVal)} $txt",
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500,fontFamily: fontType),
        )
      ],
    );
  }
}