import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/screens/auth/password_reset_screen.dart';
import 'package:omulimisa2/screens/auth/register_screen.dart';

import '../../core/styles.dart';
import '../../models/LoggedInUserModel.dart';
import '../../models/RespondModel.dart';
import '../../src/features/app_introduction/view/splash_screen.dart';
import '../../src/features/authentication/controllers/login_screen_controller.dart';
import '../../utils/AppConfig.dart';
import '../../utils/CustomTheme.dart';
import '../../utils/Utilities.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final LoginScreenController _loginScreenController = LoginScreenController();
  bool _isLoaderVisible = false;

  @override
  void dispose() {
    super.dispose();
    _loginScreenController.dispose();
  }

  @override
  void initState() {
    Utils.init_theme();
  }

  final _fKey = GlobalKey<FormBuilderState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.defaultDialog(
              middleText: "Are you sure you want quit this App?",
              titleStyle: const TextStyle(color: Colors.black),
              actions: <Widget>[
                FxButton.outlined(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  borderColor: Colors.grey.shade700,
                  child: FxText(
                    'CANCEL',
                    color: Colors.grey.shade700,
                  ),
                ),
                FxButton.small(
                  backgroundColor: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: FxText(
                    'QUIT',
                    color: Colors.white,
                  ),
                )
              ]);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: CustomTheme.primary,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
              systemNavigationBarColor: CustomTheme.primary,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          body: Stack(
            children: [
              Image(
                image: const AssetImage(
                  'assets/images/bg.jpg',
                ),
                fit: BoxFit.fill,
                height: Get.height,
                width: Get.width,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(.9),
                      Colors.black.withOpacity(.6),
                    ],
                  ),
                ),
              ),
              FormBuilder(
                key: _fKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        const Image(
                          image: AssetImage(AppConfig.logo_1),
                          width: 150,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Sign In',
                          style: AppStyles.googleFontMontserrat.copyWith(
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.w700,
                              fontSize: 24),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 30.0),
                              FormBuilderTextField(
                                decoration: CustomTheme.in_4(
                                    'Email', 'Enter your email'),
                                style: AppStyles.googleFontMontserrat.copyWith(
                                    color: Colors.grey.shade300,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                                name: "email",
                                onChanged: (value) {
                                  _email = value.toString();
                                },
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: "This field is required."),
                                  FormBuilderValidators.email(
                                      errorText: "Invalid email.")
                                ]),
                              ),
                              const SizedBox(height: 25.0),
                              FormBuilderTextField(
                                decoration: CustomTheme.in_4(
                                    'Password', 'Enter your password'),
                                style: AppStyles.googleFontMontserrat.copyWith(
                                    color: Colors.grey.shade300,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                                name: "password",
                                onChanged: (value) {
                                  _password = value.toString();
                                },
                                obscureText: true,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: "This field is required."),
                                ]),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: FxButton.text(
                                    onPressed: () {
                                      Get.to(() => const PasswordResetScreen());
                                    },
                                    child: FxText.titleMedium(
                                      "Forgot Password?",
                                      color: Colors.yellow.shade300,
                                      fontWeight: 900,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 0),
                        FxButton.block(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          backgroundColor: CustomTheme.accent,
                          onPressed: () async {
                            if (!_fKey.currentState!.saveAndValidate()) {
                              return;
                            }

                            Map<String, dynamic> formDataMap = {};
                            _email = _fKey.currentState!.fields['email']!.value;
                            _password =
                                _fKey.currentState!.fields['password']!.value;
                            formDataMap = {
                              'email': _email,
                              'password': _password,
                            };

                            Utils.toast("Loading....");
                            RespondModel resp =
                                RespondModel(await Utils.http_post(
                              'auth/login',
                              formDataMap,
                            ));

                            if (resp.code != 1) {
                              Utils.toast(resp.message);
                              return;
                            }
                            if (resp.data['user'] == null) {
                              Utils.toast("User not found");
                              return;
                            }

                            LoggedInUserModel u =
                                LoggedInUserModel.fromJson(resp.data['user']);

                            if (u.id < 1) {
                              Utils.toast("User not found");
                              return;
                            }

                            if (!(await u.save())) {
                              Utils.toast('failed to log you in ');
                              return;
                            }

                            Get.off(() => const SplashScreen());
                          },
                          child: FxText.titleLarge(
                            'Sign In',
                            fontWeight: 700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey.shade300,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Don't have account?",
                              style: AppStyles.googleFontMontserrat.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade300,
                                  fontSize: 16),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey.shade300,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 18),
                        Align(
                          alignment: Alignment.center,
                          child: Wrap(children: [
                            const SizedBox(
                              width: 3,
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => const RegisterScreen());
                              },
                              child: Text(
                                'Create Account',
                                style: AppStyles.googleFontMontserrat.copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    color: Colors.yellow,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ]),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
