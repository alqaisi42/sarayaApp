import 'package:flutter/material.dart';

import '../../config/constants.dart';
import '../../config/helper/helper_functions.dart';


class CustomeTitle extends StatelessWidget {
  final String title;
  final String? title2;
  final VoidCallback? onTap;

  const CustomeTitle({
    super.key,
    required this.title,
    this.title2,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Wrap the first text in Flexible to allow it to shrink
        Flexible(
          child: Text(
            title,
            style: TextStyle(
                fontSize: 18,
                fontFamily: fontType,
                fontWeight: FontWeight.w500
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (title2 != null)
          Padding(
            padding: EdgeInsets.only(right: MediaQueryHelper.screenWidth(context) * 0.03),
            child: InkWell(
              onTap: onTap,
              child: Text(
                title2!,
                style: TextStyle(
                  color: isDark ? Colors.grey[350] : Colors.grey[600],
                  fontFamily: fontType,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
