import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../bloc/authBloc/auth_bloc.dart';
import '../../bloc/authBloc/auth_event.dart';
import '../../bloc/authBloc/auth_state.dart';
import '../../config/colors.dart';
import '../../../l10n/app_localizations.dart';

import '../../config/constants.dart';
import '../../config/helper/helper_functions.dart';



class SignupWithPhoneNumber extends StatefulWidget {
  const SignupWithPhoneNumber({super.key});

  @override
  State<SignupWithPhoneNumber> createState() => _SignupWithPhoneNumberState();
}

class _SignupWithPhoneNumberState extends State<SignupWithPhoneNumber> {
  final TextEditingController _phoneController = TextEditingController();

  String _phoneNumber = '';
  String _countryCode = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFcmtoken();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.055,
          ),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                 AppLocalizations.of(context)!.welcomeBack ,
                  style: TextStyle(
                    fontFamily: fontType,
                    fontSize: 22,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.pleaseEnterYourNameAndPhoneNumberToLogIn,
                  style: TextStyle(
                    fontFamily: fontType,
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: SvgPicture.asset(
                    'assets/img/loginwithnumber.svg',
                  ),
                ),
                IntlPhoneField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.01,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primary,
                    labelText:  AppLocalizations.of(context)!.phoneNumber,
                    labelStyle:  TextStyle(
                      color: AppColors().primaryColor,
                      fontSize: 14,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 107, 106, 106),
                        width: 2.0,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),
                  ),
                  initialCountryCode: defaulIsoCountryCode,
                  onChanged: (phone)
                  {
                    setState(() {
                      _phoneNumber = phone.number;
                      _countryCode = phone.countryCode;
                    });
                  },
                  onCountryChanged: (country) {
                    setState(() {
                      _countryCode = country.dialCode;
                    });
                  },
                  validator: (phone) {
                    if (phone == null || phone.number.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterYourPhoneNumber;

                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                   return Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.02,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_phoneController.text.isEmpty) {
                              CustomFloatingSnackBar.showCustomSnackBar(context, AppLocalizations.of(context)!.pleaseEnterYourPhoneNumber, 0);
                            } else {
                              final phoneNumber = _countryCode + _phoneNumber;
                              BlocProvider.of<AuthBloc>(context).add(
                                SendOtpToPhoneEvent(number: phoneNumber, fcmId: fcmToken),
                              );
                              userMobileNumber = phoneNumber;
                              GoRouter.of(context).push('/loginotpscreen');
                            }
                            },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical:
                              MediaQuery.of(context).size.height * 0.01,
                            ),
                            backgroundColor: AppColors().primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.login,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: fontType,
                            ),
                          ),
                        ),
                      );
                    }

                ),
              ],
            ),
          ),
        ),
      );

  }
}
