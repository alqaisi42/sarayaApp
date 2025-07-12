
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



import '../../../l10n/app_localizations.dart';
import 'package:newsapp/config/paymentGateway/razorpay_payment_handler.dart';

import '../../bloc/followedChannelsPostBloc/followed_channels_post_bloc.dart';
import '../../bloc/followedChannelsPostBloc/followed_channels_post_event.dart';
import '../../bloc/generateSignatureBloc/generate_signature_bloc.dart';
import '../../bloc/generateSignatureBloc/generate_signature_event.dart';
import '../../bloc/generateSignatureBloc/generate_signature_state.dart';
import '../../bloc/memberShipPlanBloc/membership_bloc.dart';
import '../../bloc/memberShipPlanBloc/membership_event.dart';
import '../../bloc/paymentSettingsBloc/paymentsettings_bloc.dart';
import '../../bloc/paymentSettingsBloc/paymentsettings_state.dart';
import '../../bloc/popularHomeNewsBloc/popular_news_home_bloc.dart';
import '../../bloc/popularHomeNewsBloc/popular_news_home_event.dart';
import '../../bloc/recommendationNewsBloc/recommendation_bloc.dart';
import '../../bloc/recommendationNewsBloc/recommendation_event.dart';
import '../../bloc/stripeBloc/generate_stripe_link_bloc.dart';
import '../../bloc/stripeBloc/generate_stripe_link_event.dart';
import '../../bloc/stripeBloc/generate_stripe_link_state.dart';
import '../../bloc/verifyPaymentBloc/verify_payment_bloc.dart';
import '../../bloc/verifyPaymentBloc/verify_payment_event.dart';
import '../../bloc/verifyPaymentBloc/verify_payment_state.dart';
import '../../utils/widgets/webView/web_view.dart';
import '../helper/helper_functions.dart';






class PaymentGatewayOptions {
  final BuildContext context;
  final double planAmount;
  final String selectedPlan;
  final int tenureId;
  final int planId;


  PaymentGatewayOptions({
    required this.context,
    required this.planAmount,
    required this.selectedPlan,
    required this.tenureId,
    required this.planId
  });

  void showPaymentOptions() {
    final state = context.read<PaymentSettingsBloc>().state;
    bool stripeStatus= false;
    bool razorPayStatus = false;
    String razorpayKey = "";

    if (state is PaymentSettingsSuccessState) {
      stripeStatus =  state.paymentSettingData[0].data.stripe.status;
      razorPayStatus =  state.paymentSettingData[0].data.razorpay.status;
      razorpayKey = state.paymentSettingData[0].data.razorpay.publishableKey;
    }


    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:  0.1),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha:0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.selectYourPlan,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.choosePaymentOption,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[400]
                          : Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 32),



                  if (razorPayStatus)
                    BlocListener<GenerateSignatureBloc, GenerateSignatureState>(
                      listener: (context, state) {
                        if (state is GenerateSignatureSuccessState) {

                          final orderId = state.generateSignatur[0].data.orderId;
                          final signature = state.generateSignatur[0].data.signature;

                          RazorpayPaymentHandler().startPayment(
                            context: context,
                            amount: planAmount,
                            planName: selectedPlan,
                            razorPayKey: razorpayKey,
                            onSuccess: (paymentId) {
                              context.read<VerifyPaymentBloc>().add(
                                VerifyPaymentRequest(
                                  tenureId: tenureId,
                                  planId: planId,
                                  planAmount: planAmount,
                                  razorpayPaymentId: paymentId,
                                  razorpayOrderId: orderId,
                                  razorpaySignature: signature,
                                ),
                              );
                            },
                          );
                        } else if (state is GenerateSignatureErrorState) {
                          Navigator.pop(context);
                          CustomFloatingSnackBar.showCustomSnackBar(context, state.errorMessage, 0);
                        }
                      },
                      child: BlocListener<VerifyPaymentBloc, VerifyPaymentState>(
                        listener: (context, state) {
                          if (state is VerifyPaymentSuccess) {
                            context.read<MembershipBloc>().add(FetchMembershipPlans());
                            context.read<PopularBloc>().add(FetchPopular(refreshIndicator: true, context: context));
                            context.read<RecommendationBloc>().add(FetchRecommendation(refreshIndicator: true, context: context));
                            context.read<FollowedChannelsPostBloc>().add(FetchFollowedChannelsPost(context: context,));
                            Navigator.pop(context);
                            CustomFloatingSnackBar.showCustomSnackBar(context, state.verifyPaymentData[0].message.toString(), 1);
                          } else if (state is VerifyPaymentFailure) {
                            Navigator.pop(context);
                            CustomFloatingSnackBar.showCustomSnackBar(context, state.errorMessage, 0);
                          }
                        },
                        child: _PaymentOptionCard(
                          icon: Icons.payments_rounded,
                          title: AppLocalizations.of(context)!.razorpay,
                          subtitle: AppLocalizations.of(context)!.razorpayDescription,
                          gradient: LinearGradient(
                            colors: [Color(0xFF02B9F1), Color(0xFF0277BD)],
                          ),
                          onTap: () {
                            context.read<GenerateSignatureBloc>().add(
                              PostSingnatureDetails(
                                tenureId: tenureId.toString(),
                                planId: planId.toString(),
                                planAmount: planAmount.toString(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),





                  if (stripeStatus) SizedBox(height: 16),


                  if (stripeStatus)
                    BlocListener<GenerateStripeLinkBloc, GenerateStripeLinkState>(
                      listener: (context, state) {
                        if (state is GenerateStripeLinkSuccess) {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewPage(
                                url: state.generateStripeLinkData[0].data!.checkoutUrl.toString(),
                                title: AppLocalizations.of(context)!.payment,
                              ),
                            ),
                          );
                        } else if (state is GenerateStripeLinkFailure) {
                          Navigator.pop(context);
                          CustomFloatingSnackBar.showCustomSnackBar(context, state.errorMessage, 0);
                        }
                      },
                      child: _PaymentOptionCard(
                        icon: Icons.credit_card_rounded,
                        title: AppLocalizations.of(context)!.stripe,
                        subtitle: AppLocalizations.of(context)!.stripeDescription,
                        gradient: LinearGradient(
                          colors: [Color(0xFF6B72FF), Color(0xFF6054FF)],
                        ),
                        onTap: () {
                          context.read<GenerateStripeLinkBloc>().add(
                            GenerateStripeLinkRequest(
                              tenureId: tenureId,
                              planId: planId,
                              planAmount: planAmount,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}


class _PaymentOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _PaymentOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.withValues(alpha:0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



