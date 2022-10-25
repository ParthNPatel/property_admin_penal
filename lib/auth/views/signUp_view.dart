import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:property/components/common_widget.dart';
import 'package:property/constant/color_const.dart';
import 'package:sizer/sizer.dart';
import '../email_auth/email_auth_services.dart';
import '../views/login_view.dart';
import '../constants.dart';
import '../controller/simple_ui_controller.dart';
import 'package:get/get.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController businessPhone = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  SimpleUIController simpleUIController = Get.put(SimpleUIController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          return new Future(() => true);
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return _buildLargeScreen(size, simpleUIController, theme);
                } else {
                  return _buildSmallScreen(size, simpleUIController, theme);
                }
              },
            )),
      ),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  height: 40.sp,
                  color: themColors309D9D,
                  width: 40.sp,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(width: size.width * 0.06),
              Expanded(
                flex: 5,
                child: _buildMainBody(size, simpleUIController, theme),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Center(
      child: _buildMainBody(size, simpleUIController, theme),
    );
  }

  /// Main Body
  Widget _buildMainBody(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Column(
      crossAxisAlignment: size.width > 600
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      mainAxisAlignment: size.width > 600
          ? MainAxisAlignment.center
          : MainAxisAlignment.center,
      children: [
        size.width > 600
            ? Container()
            : SvgPicture.asset(
                'assets/images/logo.svg',
                height: 35.sp,
                color: themColors309D9D,
                width: 35.sp,
                fit: BoxFit.fill,
              ),
        SizedBox(
          height: size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Sign Up',
            style: kLoginTitleStyle(size),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Create Account',
            style: kLoginSubtitleStyle(size),
          ),
        ),
        SizedBox(
          height: size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: size.width > 600
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                /// username
                SizedBox(
                  width: 120.sp,
                  child: TextFormField(
                    style: kTextFormFieldStyle(),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),

                    controller: nameController,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter username';
                      } else if (value.length < 4) {
                        return 'at least enter 4 characters';
                      } else if (value.length > 13) {
                        return 'maximum character is 13';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// Gmail
                SizedBox(
                  width: 120.sp,
                  child: TextFormField(
                    style: kTextFormFieldStyle(),
                    controller: emailController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_rounded),
                      hintText: 'Business Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter gmail';
                      } else if (!value.endsWith('@gmail.com')) {
                        return 'please enter valid gmail';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// Phone
                SizedBox(
                  width: 120.sp,
                  child: TextFormField(
                    style: kTextFormFieldStyle(),
                    controller: businessPhone,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_rounded),
                      hintText: 'Business Phone No',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value!.length != 10 || value.isEmpty) {
                        return 'Please enter phone no';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// password
                Obx(
                  () => SizedBox(
                    width: 120.sp,
                    child: TextFormField(
                      style: kTextFormFieldStyle(),
                      controller: passwordController,
                      obscureText: simpleUIController.isObscure.value,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_open),
                        suffixIcon: IconButton(
                          icon: Icon(
                            simpleUIController.isObscure.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            simpleUIController.isObscureActive();
                          },
                        ),
                        hintText: 'Create Password',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        } else if (value.length < 7) {
                          return 'at least enter 6 characters';
                        } else if (value.length > 13) {
                          return 'maximum character is 13';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  'Creating an account means you\'re okay with our Terms of Services and our Privacy Policy',
                  style: kLoginTermsAndPrivacyStyle(size),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// SignUp Button
                signUpButton(theme),
                SizedBox(
                  height: size.height * 0.03,
                ),

                /// Navigate To Login Screen
                GestureDetector(
                  onTap: () {
                    // Navigator.pushNamed(context, '/');

                    Get.to(() => LoginView());
                    nameController.clear();
                    emailController.clear();
                    passwordController.clear();
                    _formKey.currentState?.reset();

                    simpleUIController.isObscure.value = true;
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account?',
                      style: kHaveAnAccountStyle(size),
                      children: [
                        TextSpan(
                            text: " Login",
                            style: kLoginOrSignUpTextStyle(size)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // SignUp Button
  Widget signUpButton(ThemeData theme) {
    return SizedBox(
      width: 120.sp,
      height: 55,
      child: isLoading == true
          ? Center(
              child: CircularProgressIndicator(
              color: themColors309D9D,
            ))
          : ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(themColors309D9D),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    isLoading = true;
                  });

                  EmailAuth.signUp(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.pushReplacementNamed(context, '/HomePage');
                      FirebaseFirestore.instance
                          .collection('AdminUser')
                          .doc(lFirebaseAuth.currentUser!.uid)
                          .set({
                        'username': nameController.text,
                        'email': emailController.text,
                        'phoneNo': businessPhone.text,
                        'uid': '${lFirebaseAuth.currentUser!.uid}',
                      });
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                      CommonWidget.getSnackBar(
                          title: "Failed",
                          message: "Sign Up Failed!",
                          color: CommonColor.red,
                          colorText: Colors.white);
                    }
                  });
                }
              },
              child: const Text('Sign up'),
            ),
    );
  }
}
