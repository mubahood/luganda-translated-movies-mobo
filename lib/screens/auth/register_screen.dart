import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ugflix/screens/auth/login_screen.dart';
import '../../core/styles.dart';
import '../../models/LoggedInUserModel.dart';
import '../../models/RespondModel.dart';
import '../../src/features/app_introduction/view/splash_screen.dart';
import '../../utils/AppConfig.dart';
import '../../utils/CustomTheme.dart';
import '../../utils/Utilities.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  String errorMessage = "";
  String _name = "";
  String _email = "";
  String _password = "";
  String _passwordConfirm = "";

  @override
  void initState() {
    super.initState();
    Utils.init_theme();
  }

  Future<bool> _onWillPop() async {
    Get.defaultDialog(
        middleText: "Are you sure you want to quit the registration process?",
        titleStyle: const TextStyle(color: Colors.black),
        actions: [
          FxButton.outlined(
            onPressed: () => Navigator.pop(context),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            borderColor: Colors.grey.shade700,
            child: FxText('CANCEL', color: Colors.grey.shade700),
          ),
          FxButton.small(
            backgroundColor: Colors.red,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: FxText('QUIT', color: Colors.white),
          )
        ]);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: CustomTheme.primary,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: CustomTheme.primary,
          ),
        ),
        body: Stack(
          children: [
            // Full screen background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg.jpg',
                fit: BoxFit.cover,
              ),
            ),
            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ),
            // Glassmorphism container for the registration form
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: FormBuilder(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Image.asset(
                                AppConfig.logo_1,
                                width: 150,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Center(
                              child: Text(
                                'Creating New Account',
                                style: AppStyles.googleFontMontserrat.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 28,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            FormBuilderTextField(
                              name: "name",
                              decoration: CustomTheme.in_4(
                                  'Full Name', 'Enter your full name'),
                              style: AppStyles.googleFontMontserrat.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                              textInputAction: TextInputAction.next,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: "This field is required."),
                                FormBuilderValidators.minLength(3,
                                    errorText: "Name too short")
                              ]),
                              onChanged: (value) {
                                _name = value.toString();
                              },
                            ),
                            const SizedBox(height: 20),
                            FormBuilderTextField(
                              name: "email",
                              decoration:
                                  CustomTheme.in_4('Email', 'Enter your email'),
                              style: AppStyles.googleFontMontserrat.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: "This field is required."),
                                FormBuilderValidators.email(
                                    errorText: "Invalid email.")
                              ]),
                              onChanged: (value) {
                                _email = value.toString();
                              },
                            ),
                            const SizedBox(height: 25),
                            FormBuilderTextField(
                              name: "password",
                              decoration: CustomTheme.in_4(
                                  'Password', 'Enter your password'),
                              style: AppStyles.googleFontMontserrat.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: "This field is required."),
                                FormBuilderValidators.minLength(4,
                                    errorText: "Password too short"),
                              ]),
                              onChanged: (value) {
                                _password = value.toString();
                              },
                            ),
                            const SizedBox(height: 25),
                            FormBuilderTextField(
                              name: "password_confirm",
                              decoration: CustomTheme.in_4('Re-Enter Password',
                                  'Re-enter your password'),
                              style: AppStyles.googleFontMontserrat.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: "This field is required."),
                                FormBuilderValidators.minLength(4,
                                    errorText: "Password too short"),
                              ]),
                              onChanged: (value) {
                                _passwordConfirm = value.toString();
                              },
                            ),
                            errorMessage.isEmpty
                                ? const SizedBox(height: 20)
                                : Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.red),
                                    ),
                                    child: Text(
                                      errorMessage,
                                      style: AppStyles.googleFontMontserrat
                                          .copyWith(
                                        color: Colors.red.shade900,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                            const SizedBox(height: 10),
                            isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: CustomTheme.accent,
                                      strokeWidth: 5,
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: _attemptRegister,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      backgroundColor: CustomTheme.accent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Create Account',
                                      style: AppStyles.googleFontMontserrat
                                          .copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 28),
                            Row(
                              children: [
                                Expanded(
                                    child: Divider(
                                        color: Colors.white70, thickness: 1)),
                                const SizedBox(width: 10),
                                Text(
                                  "Already have account?",
                                  style:
                                      AppStyles.googleFontMontserrat.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: Divider(
                                        color: Colors.white70, thickness: 1)),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Center(
                              child: GestureDetector(
                                onTap: () => Get.to(() => const LoginScreen(),
                                    preventDuplicates: false),
                                child: Text(
                                  'Sign In',
                                  style:
                                      AppStyles.googleFontMontserrat.copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20,
                                    color: Colors.yellowAccent,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _attemptRegister() async {
    setState(() {
      errorMessage = "";
    });

    if (!_formKey.currentState!.saveAndValidate()) return;

    // Check if provided full name contains at least one space.
    if (!_formKey.currentState!.fields['name']!.value
        .toString()
        .contains(' ')) {
      setState(() {
        errorMessage = "Please provide your full name.";
      });
      Utils.toast(errorMessage, color: Colors.red);
      return;
    }

    // Check for matching passwords.
    if (_formKey.currentState!.fields['password']!.value.toString() !=
        _formKey.currentState!.fields['password_confirm']!.value.toString()) {
      setState(() {
        errorMessage = "Passwords did not match";
      });
      Utils.toast(errorMessage, color: Colors.red);
      return;
    }

    final formData = {
      'name': _formKey.currentState!.fields['name']!.value,
      'email': _formKey.currentState!.fields['email']!.value,
      'password': _formKey.currentState!.fields['password']!.value,
    };

    Utils.toast("Loading....");
    setState(() {
      isLoading = true;
    });

    final resp = await Utils.http_post('auth/register', formData);
    setState(() {
      isLoading = false;
    });

    final responseModel = RespondModel(resp);

    if (responseModel.code != 1) {
      setState(() {
        errorMessage = responseModel.message;
      });
      Utils.toast(errorMessage);
      return;
    }

    if (responseModel.data['user'] == null) {
      Utils.toast("User not found");
      return;
    }

    final user = LoggedInUserModel.fromJson(responseModel.data['user']);
    if (user.id < 1) {
      Utils.toast("User not found");
      return;
    }

    if (!(await user.save())) {
      Utils.toast('Failed to log you in.');
      return;
    }

    // Save the token to SharedPreferences.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', user.token);

    Get.off(() => const SplashScreen());
  }
}
