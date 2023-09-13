import 'package:cherry_toast/cherry_toast.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/Util/commonUi.dart';
import 'package:flutter_task/Util/hive_helper.dart';
import 'package:flutter_task/Util/page_router.dart';
import 'package:flutter_task/Util/palette.dart';
import 'package:flutter_task/Util/sizing.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController countryCodecontroller =
      TextEditingController(text: '+91');
  final auth = FirebaseAuth.instance;
  var verificationId = '';
  String currentOtp = '';

  Future<void> phoneAuthentication(String phoneNo) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      verificationCompleted: (credentials) async {
        await auth.signInWithCredential(credentials);
      },
      codeSent: (verificationId, forceResendingToken) {
        this.verificationId = verificationId;
        Navigator.pop(context);
        listenOTP();
      },
      codeAutoRetrievalTimeout: (verificationId) {
        this.verificationId = verificationId;
      },
      verificationFailed: (e) {
        Navigator.pop(context);
        if (e.code.toLowerCase() == 'invalid-phone-number') {
          CherryToast.error(
                  title: Text(
                    "Provided phone number is not valid",
                    style: TextStyle(fontSize: Sizing.height(10, 6)),
                  ),
                  autoDismiss: true)
              .show(context);
        } else if (e.code.toLowerCase().contains('too-many-requests')) {
          CherryToast.error(
                  title: Text(
                    "Please try after some time",
                    style: TextStyle(fontSize: Sizing.height(10, 6)),
                  ),
                  autoDismiss: true)
              .show(context);
        } else if (e.code.toLowerCase().contains('network-request-failed')) {
          CherryToast.error(
                  title: Text(
                    "Kindly connect to network !",
                    style: TextStyle(fontSize: Sizing.height(10, 6)),
                  ),
                  autoDismiss: true)
              .show(context);
        } else {
          CherryToast.error(
                  title: Text(
                    "Something went wrong, try again",
                    style: TextStyle(fontSize: Sizing.height(10, 6)),
                  ),
                  autoDismiss: true)
              .show(context);
        }
      },
    );
  }

  Future<bool> verifyOTP(String otp) async {
    var otpResult = await auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: otp));

    return otpResult.user != null ? true : false;
  }

  listenOTP() async {
    await SmsAutoFill().listenForCode();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          children: [
            Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: primaryColor,
                )),
            Positioned(
              top: Sizing.height(60, 65),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: blackColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25.0),
                    topLeft: Radius.circular(25.0),
                  ),
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: Sizing.height(150, 155)),
                        child: Text(
                          'Phone number',
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: Sizing.height(13, 15)),
                        ),
                      ),
                      phoneNumberField(),
                      Padding(
                        padding: EdgeInsets.only(top: Sizing.height(25, 26)),
                        child: Text(
                          'OTP',
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: Sizing.height(13, 15)),
                        ),
                      ),
                      otpField(),
                      loginButton(),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                top: Sizing.height(-25, -26),
                right: Sizing.width(-5, -6),
                child: Container(
                  height: Sizing.height(80, 90),
                  width: Sizing.width(40, 50),
                  decoration: const ShapeDecoration(
                      shape: CircleBorder(),
                      color: Color.fromARGB(61, 174, 160, 201)),
                )),
            Positioned(
              top: Sizing.height(50, 52),
              left: Sizing.width(55, 60),
              child: Container(
                height: Sizing.height(25, 26),
                width: Sizing.width(35, 36),
                decoration: BoxDecoration(
                    color: Colors.blue[400],
                    borderRadius: BorderRadius.circular(3)),
                child: Center(
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                        color: whiteColor, fontSize: Sizing.height(13, 15)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  phoneNumberField() {
    phoneNumber.selection =
        TextSelection.collapsed(offset: phoneNumber.text.length);
    countryCodecontroller.selection =
        TextSelection.collapsed(offset: countryCodecontroller.text.length);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.only(top: Sizing.height(5, 6)),
          decoration: BoxDecoration(
              color: primaryColor, borderRadius: BorderRadius.circular(10)),
          height: Sizing.height(30, 35),
          width: Sizing.width(20, 21),
          child: TextFormField(
            style: const TextStyle(color: whiteColor),
            keyboardType: TextInputType.number,
            controller: countryCodecontroller,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(
                    bottom: Sizing.height(15, 16), left: Sizing.width(3, 4))),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            cursorColor: whiteColor,
            validator: (value) {
              if (value == "" || value == null) {
                return 'Country code cannot be empty';
              }
              return null;
            },
            onTap: () {
              showCountryPicker(
                context: context,
                favorite: <String>['IN'],
                showPhoneCode: true,
                onSelect: (Country country) {
                  var val = country.displayName.split('[').last;
                  var val1 = val.split(']').first;
                  countryCodecontroller.text = val1;
                },
                countryListTheme: const CountryListThemeData(
                  searchTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              );
            },
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: Sizing.height(5, 6)),
            height: Sizing.height(30, 35),
            width: Sizing.width(80, 82),
            decoration: BoxDecoration(
                color: primaryColor, borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              style: const TextStyle(color: whiteColor),
              onChanged: (value) {
                if (phoneNumber.text.length == 10) {
                  CommonUi().showLoadingDialog(context);
                  String phnNumber =
                      countryCodecontroller.text + phoneNumber.text.trim();
                  phoneAuthentication(phnNumber);
                }
              },
              keyboardType: TextInputType.number,
              controller: phoneNumber,
              cursorColor: whiteColor,
              maxLength: 10,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: Sizing.width(3, 4),
                      vertical: Sizing.height(3, 4))),
            )),
      ],
    );
  }

  otpField() {
    return Container(
        margin: EdgeInsets.only(top: Sizing.height(5, 6)),
        padding: EdgeInsets.only(top: Sizing.height(5, 6)),
        height: Sizing.height(40, 35),
        width: Sizing.width(100, 102),
        // decoration: BoxDecoration(
        //     color: primaryColor, borderRadius: BorderRadius.circular(10)),
        child: PinFieldAutoFill(
          decoration: BoxLooseDecoration(
              radius: const Radius.circular(5),
              textStyle: const TextStyle(color: whiteColor),
              strokeColorBuilder: const FixedColorBuilder(whiteColor)),
          codeLength: 6,
          currentCode: currentOtp,
          onCodeChanged: (code) {
            currentOtp = code.toString();
          },
          onCodeSubmitted: (code) {},
        ));
  }

  loginButton() {
    return InkWell(
      onTap: () async {
        CommonUi().showLoadingDialog(context);
        bool isVerified = await verifyOTP(currentOtp.trim());
        if (isVerified) {
          HiveHelper().saveLoginStatus(true);
          Navigator.of(context).pushNamedAndRemoveUntil(
              PageRouter.dashboardPage, (Route<dynamic> route) => false);
        } else {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          CherryToast.error(
                  title: Text(
                    "OTP verification failed",
                    style: TextStyle(fontSize: Sizing.height(10, 6)),
                  ),
                  autoDismiss: true)
              .show(context);
        }
      },
      child: Container(
        height: Sizing.height(30, 32),
        width: Sizing.width(100, 102),
        margin: EdgeInsets.only(top: Sizing.height(40, 42)),
        decoration: BoxDecoration(
            color: const Color.fromARGB(89, 158, 158, 158),
            borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: Text(
            'LOGIN',
            style: TextStyle(
                color: whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: Sizing.height(13, 15)),
          ),
        ),
      ),
    );
  }
}
