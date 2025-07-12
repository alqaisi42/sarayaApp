

import 'package:flutter/material.dart';

import 'package:newsapp/config/constants.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../helper/helper_functions.dart';




class RazorpayPaymentHandler {
  late Razorpay _razorpay;
  late Function(String paymentId) _onPaymentSuccess;


  void startPayment({
    required BuildContext context,
    required double amount,
    required String planName,
    required Function(String paymentId) onSuccess,
    required String razorPayKey,
  }) {
    _initializeRazorpay(onSuccess);
    _openCheckout(context, amount, planName,razorPayKey);
  }

  void _initializeRazorpay(Function(String paymentId) onSuccess) {
    _razorpay = Razorpay();
    _onPaymentSuccess = onSuccess;

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }


  void _openCheckout(BuildContext context, double amount, String planName,String razorPayKey) {
    final amountInPaise = (amount * 100).toInt();

    var options = {
      'key': razorPayKey,
      'amount': amountInPaise,
      'name': appName,
      'description': '$appName Subscription',
      'retry': {'enabled': true, 'max_count': 50},
      'prefill': {
        'contact': '',
        'email': ''
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
      _showErrorMessage(context, e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _onPaymentSuccess(response.paymentId.toString());
      _disposeRazorpay();
  }

  void _handlePaymentError(PaymentFailureResponse response) {

    _disposeRazorpay();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {

    _disposeRazorpay();
  }

  void _showErrorMessage(BuildContext context, String message) {

      CustomFloatingSnackBar.showCustomSnackBar(context, message, 1);

  }

  void _disposeRazorpay() {

    _razorpay.clear();
  }
}



