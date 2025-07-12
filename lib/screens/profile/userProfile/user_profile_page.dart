import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:newsapp/config/colors.dart';

import 'dart:io';
import '../../../Model/auth model/auth_response_model.dart';


import '../../../bloc/getUserProfileBloc/get_user_profile_bloc.dart';
import '../../../bloc/getUserProfileBloc/get_user_profile_event.dart';
import '../../../bloc/updateuserProfileBloc/update_userprofile_bloc.dart';
import '../../../bloc/updateuserProfileBloc/update_userprofile_event.dart';
import '../../../bloc/updateuserProfileBloc/update_userprofile_state.dart';
import '../../../config/constants.dart';

import '../../../l10n/app_localizations.dart';

import '../../../config/helper/helper_functions.dart';
import '../../../config/hiveLocalStorage/hive_storage.dart';




class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  File? profileImage;
  final ImagePicker picker = ImagePicker();
  String? token;
  String? userProfile;
  String? userName;
  String? userEmail;
  String? userContactNumber;
  String? loginType;

  String? originalName;
  String? originalProfileUrl;
  String? originalUserMobileNumber;
  String? originalUserEmail;
  bool showUpdateButton = false;
  bool isLoading = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  //================================================================= Get Data from Local Storage Hive Function
  Future<String?> _loadUserData() async {
    try {
      setState(() {
        isLoading = true;
      });

      AuthResponse? fetchedToken = await HiveStorage().getToken();
      Users? user = fetchedToken?.data?.user;

      if (user != null) {
        setState(() {
          token = fetchedToken?.data?.token;
          userProfile = user.profile;
          userName = user.name;
          userEmail = user.email;
          userContactNumber = user.mobile;
          loginType =  user.type;

          // Store original values
          originalName = user.name;
          originalProfileUrl = user.profile;
          originalUserEmail = user.email;
          originalUserMobileNumber = user.mobile;

          // Set controller values after loading data
          nameController.text = userName ?? "";
          emailController.text = userEmail ?? "";
          mobileController.text = userContactNumber ?? "";
        });
      }
    } catch (e) {

     if(mounted){
       CustomFloatingSnackBar.showCustomSnackBar(context, AppLocalizations.of(context)!.failedToloadUserData, 0);
     }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return token;
  }




//=================================================================== Bottom Sheet for Get Image From gallery or Camera widget
  Future<void> _showImageSourceActionSheet() {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                 Text(
                 AppLocalizations.of(context)!.selectImageSource,
                   style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                     fontFamily: fontType
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            pickImage(ImageSource.camera);
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 50,
                              color: AppColors().primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                         Text(AppLocalizations.of(context)!.camera,style: TextStyle(fontFamily: fontType),),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            pickImage(ImageSource.gallery);
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding:  EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:  Icon(
                              Icons.photo_library,
                              size: 50,
                              color: AppColors().primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                         Text(AppLocalizations.of(context)!.gallery,style: TextStyle(fontFamily: fontType),),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================================================================== Pic Image From Gallery and Camera Function
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        File? croppedFile = await cropImage(File(pickedFile.path));
        if (croppedFile != null) {
          setState(() {
            profileImage = croppedFile;

          });
        }
      }
    } catch (e) {

      if(mounted){

        CustomFloatingSnackBar.showCustomSnackBar(context, AppLocalizations.of(context)!.failedToPickImage, 0);
      }
    }
  }

  // ==================================================================== Crop Image Function
  Future<File?> cropImage(File imageFile) async {

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: AppLocalizations.of(context)!.cropImage,
          toolbarColor: AppColors().primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio16x9,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: AppLocalizations.of(context)!.cropImage,
          minimumAspectRatio: 1.77,
          aspectRatioLockEnabled: false,
          rotateButtonsHidden: false,
        ),
      ],
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }


// ========================================================================== Update User Name and Image Function
  Future<void> updateProfile() async {
    bool nameChanged = nameController.text.trim() != originalName;
    bool imageChanged = profileImage != null;
    bool contactChanged = mobileController.text != originalUserMobileNumber ;
    bool emailChanged = userEmail != originalUserEmail;



    if (nameController.text.trim().isEmpty || emailController.text.trim().isEmpty || mobileController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.nameEmailMobileNumberCannotEmpty,style: TextStyle(fontFamily: fontType),),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (!nameChanged && !imageChanged && !contactChanged && !emailChanged) {

      CustomFloatingSnackBar.showCustomSnackBar(context, AppLocalizations.of(context)!.noChangestoNameandImage, 0);
      return;
    }




    context.read<UpdateUserProfileBloc>().add(
      UpdateUserProfileEvent(
        userName: nameController.text.trim() ,
        userProfile: profileImage,
        userEmail: emailController.text.trim() ,
        userMobileNumber: "$defaultCountryCode${mobileController.text.trim()}",
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateUserProfileBloc, UpdateUserProfileState>(
      listener: (context, state) async {
        if (state is UpdateUserProfileSuccessState) {
          try {
            AuthResponse? currentData = await HiveStorage().getToken();
            if (currentData?.data?.user != null) {
              // Update name
              currentData!.data!.user!.name = nameController.text.trim();

              // Update profile image if changed
              if (profileImage != null) {
                currentData.data!.user!.profile = state.updatedUserProfile.data!.profile;
              }

             setState(() {
           userProfile = state.updatedUserProfile.data!.profile;
           userName = state.updatedUserProfile.data?.name;
             });

              // Update email
              currentData.data!.user!.email = emailController.text.trim();

              // Update mobile number
              currentData.data!.user!.mobile = mobileController.text.trim();

              // Store updated data in Hive
              await HiveStorage().storeToken(currentData);

              setState(() {
                profileImage = null;
                originalName = nameController.text.trim();
                originalProfileUrl = state.updatedUserProfile.data!.profile.toString();
                originalUserEmail = emailController.text.trim();
                originalUserMobileNumber = mobileController.text.trim();
              });

              if(context.mounted){
                CustomFloatingSnackBar.showCustomSnackBar(context, AppLocalizations.of(context)!.profileUpdatedSuccessfully, 1);
              }

              await _loadUserData();
             if(context.mounted){
               context.read<GetUserProfileBloc>().add(FetchUserProfile());
               // router.go('/profile');
               // GoRouter.of(context).push('/profile');
             }
            }
          } catch (e) {
            if(context.mounted){
              CustomFloatingSnackBar.showCustomSnackBar(context, AppLocalizations.of(context)!.failedToSaveUpdatedProfile, 0);
            }
          }
        } else if (state is UpdateUserProfileErrorState) {
          CustomFloatingSnackBar.showCustomSnackBar(context, state.errorMessage, 0);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(userName?.toString() ?? '',style: TextStyle(fontFamily: fontType),),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: MediaQueryHelper.screenWidth(context) * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      child:CircleAvatar(
                        radius: 60,
                        backgroundImage: profileImage != null
                            ? FileImage(profileImage!)
                            : (userProfile != null && userProfile!.isNotEmpty
                            ? (userProfile!.contains('http')
                            ? NetworkImage(userProfile!)
                            : FileImage(File(userProfile!)))
                            : AssetImage('assets/img/logo.png') as ImageProvider),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showImageSourceActionSheet,
                        child: Container(
                          padding:  EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors().primaryColor, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha:0.2),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset:  Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: AppColors().primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                TextField(
                  controller: nameController,

                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.name,
                    hintStyle: TextStyle(
                      color: Colors.grey, // Hint text color
                    ),
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.grey, // Default border color
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.red, // Active border color
                        width: 1.5,
                      ),
                    ),
                  ),
                ),





                SizedBox(height: 20),
                TextField(
                  enabled: userEmail == "" || loginType == "mobile",
                  controller: emailController,
                  decoration:  InputDecoration(
                    hintText: AppLocalizations.of(context)!.emial,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.grey, // Default border color
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.red, // Active border color
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
               SizedBox(height: 20),
                PhoneNumberInput(phoneNumberController: mobileController, userContactNumber: userContactNumber.toString(), loginType: loginType.toString(),),
               SizedBox(height: 32),
                BlocBuilder<UpdateUserProfileBloc, UpdateUserProfileState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: updateProfile,
                        style: ElevatedButton.styleFrom(
                          padding:EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors().primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: state is UpdateUserProfileLoadingState
                            ? SizedBox(
                          height: 20,
                          width: 20,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.lightColor,
                            ),
                          ),
                        )
                            :  Text(
                          AppLocalizations.of(context)!.updateProfile,
                          style: TextStyle(fontSize: 16,fontFamily: fontType,color: AppColors.whiteColor),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.03,),
              ],
            ),
          ),
        ),
      ),
    );
  }

}






class PhoneNumberInput extends StatefulWidget {
  final TextEditingController phoneNumberController;
  final String? userContactNumber;
  final String loginType;

  const PhoneNumberInput({required this.phoneNumberController, required this.userContactNumber,required this.loginType,  super.key});


  @override
  PhoneNumberInputState createState() => PhoneNumberInputState();
}

class PhoneNumberInputState extends State<PhoneNumberInput> {
  String? countryCode = defaultCountryCode;
  String? defaulISOCountryCode = defaulIsoCountryCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.only(bottom: MediaQuery.of(context).size.height / 30.0),
      margin: EdgeInsets.zero,
      child: IntlPhoneField(
        controller: widget.phoneNumberController,
        textInputAction: TextInputAction.done,

        dropdownIcon: Icon(
          Icons.keyboard_arrow_down_rounded,

        ),
        decoration: InputDecoration(
          filled: true,

          contentPadding:  EdgeInsets.symmetric(vertical: 15.0),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color: Colors.grey),
              borderRadius: BorderRadius.circular(12.0)
          ),
          focusedBorder:  OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color: AppColors().primaryColor),
              borderRadius: BorderRadius.circular(12.0)
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color: Colors.red),
          ),
          hintText: AppLocalizations.of(context)!.mobileNumber,
          hintStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        enabled:  widget.loginType == "email" || widget.loginType == "google",
        flagsButtonMargin: EdgeInsets.all(MediaQuery.of(context).size.width / 40.0),
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        dropdownIconPosition: IconPosition.leading,
        initialCountryCode: defaulIsoCountryCode,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
        onChanged: (phone) {
          setState(() {
            countryCode = phone.countryCode;
          });
        },
        onCountryChanged: (country) {
          setState(() {
            countryCode = country.dialCode;
            defaulISOCountryCode = country.code;
          });
        },
      ),
    );
  }
}