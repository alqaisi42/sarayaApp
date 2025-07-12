import 'package:flutter/material.dart';

import 'package:newsapp/config/constants.dart';



class ProfileBtn extends StatelessWidget {
  final IconData profileIcon;
  final String profileLabel;
  final Color iconColor;
  final IconData profileIcon2;

  const ProfileBtn({
    super.key,
    required this.profileIcon,
    required this.profileLabel,
    required this.iconColor,
    required this.profileIcon2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.05),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha:0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    profileIcon,
                    size: 20,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  profileLabel,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: fontType,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                profileIcon2,
                size: 18,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class ProfileBtn extends StatelessWidget {
//   final IconData profileIcon;
//   final String profileLabel;
//
//   final Color iconColor;
//   final IconData profileIcon2;
//
//   const ProfileBtn({
//     super.key,
//     required this.profileIcon,
//     required this.profileLabel,
//     required this.iconColor,
//     required this.profileIcon2,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.primary,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(
//             horizontal: MediaQueryHelper.screenWidth(context) * 0.03,
//             vertical: MediaQueryHelper.screenHeight(context) * 0.01),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: iconColor,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(6),
//                     child: Icon(
//                       profileIcon,
//                       size: 18,
//                       color: AppColors.whiteColor,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: MediaQueryHelper.screenWidth(context) * 0.03),
//                 Text(
//                   profileLabel,
//                   style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                       fontFamily: fontType),
//                 ),
//               ],
//             ),
//             Icon(profileIcon2),
//           ],
//         ),
//       ),
//     );
//   }
// }
