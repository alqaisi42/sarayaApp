import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

import 'helper/helper_functions.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color baseColor;
  final Color highlightColor;
  final EdgeInsets? margin;

  const ShimmerWidget({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
    this.baseColor = Colors.grey,
    this.highlightColor = Colors.white,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.tertiary,
      highlightColor: Theme.of(context).colorScheme.secondary,
      child: Container(
        width: width,
        height: height,
        margin: margin ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}










class TOIShimmer extends StatelessWidget {
  const TOIShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Banner Image
          Padding(
            padding:  EdgeInsets.only(left: MediaQueryHelper.screenWidth(context) * 0.04,right: MediaQueryHelper.screenWidth(context) * 0.04),
            child: ShimmerWidget(width: double.infinity, height: 200),
          ),
      
           SizedBox(height: 16),
      
          // Profile row
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                ShimmerWidget(width: 48, height: 48, borderRadius: 24),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget(width: 150, height: 16),
                    const SizedBox(height: 8),
                    ShimmerWidget(width: 100, height: 14),
                  ],
                ),
              ],
            ),
          ),
      
          const SizedBox(height: 20),
      
          // Follow button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ShimmerWidget(width: double.infinity, height: 45, borderRadius: 12),
          ),
      
          const SizedBox(height: 20),
      
          // Chips row
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (_, __) => ShimmerWidget(width: 80, height: 36, borderRadius: 20),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: 4,
            ),
          ),
      
          const SizedBox(height: 20),
      
          // News Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: List.generate(
                2,
                    (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerWidget(width: double.infinity, height: 180, borderRadius: 16),
                      const SizedBox(height: 12),
                      ShimmerWidget(width: 200, height: 16),
                      const SizedBox(height: 8),
                      ShimmerWidget(width: double.infinity, height: 14),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class SubscriptionLoadingScreen extends StatelessWidget {
  const SubscriptionLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = const Color(0xFF1C1C24);
    final highlightColor = const Color(0xFF2A2A36);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0C),
      body: SafeArea(
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const ShimmerWidget(
                        width: 40,
                        height: 40,
                        borderRadius: 20,
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Center(
                    child: ShimmerWidget(
                      width: 80,
                      height: 80,
                      borderRadius: 40,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Center(
                    child: ShimmerWidget(
                      width: double.infinity,
                      height: 32,
                      borderRadius: 6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: ShimmerWidget(
                      width: 280,
                      height: 20,
                      borderRadius: 6,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            ShimmerWidget(
                              width: 40,
                              height: 40,
                              borderRadius: 20,
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: ShimmerWidget(
                                height: 24,
                                borderRadius: 6, width: 0,
                              ),
                            ),
                            SizedBox(width: 16),
                            ShimmerWidget(
                              width: 100,
                              height: 28,
                              borderRadius: 14,
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        const ShimmerWidget(
                          width: 160,
                          height: 20,
                          borderRadius: 4,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Expanded(
                              child: ShimmerWidget(
                                width: double.infinity,
                                height: 56,
                                borderRadius: 28,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: ShimmerWidget(
                                width: double.infinity,
                                height: 56,
                                borderRadius: 28,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: ShimmerWidget(
                                width: double.infinity,
                                height: 56,
                                borderRadius: 28,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        const ShimmerWidget(
                          width: 220,
                          height: 40,
                          borderRadius: 6,
                        ),
                        const SizedBox(height: 8),
                        const ShimmerWidget(
                          width: 140,
                          height: 18,
                          borderRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerWidget(
                            width: 120,
                            height: 32,
                            borderRadius: 6,
                          ),
                          SizedBox(height: 8),
                          ShimmerWidget(
                            width: 80,
                            height: 18,
                            borderRadius: 4,
                          ),
                        ],
                      ),
                      ShimmerWidget(
                        width: 180,
                        height: 56,
                        borderRadius: 28,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
