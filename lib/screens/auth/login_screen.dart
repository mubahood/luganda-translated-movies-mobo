import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:omulimisa2/src/routing/routing.dart';

import '../../core/styles.dart';
import '../../src/features/authentication/controllers/login_screen_controller.dart';
import '../../src/features/authentication/view/common_widgets/custom_button.dart';
import '../../src/features/authentication/view/common_widgets/text_form_field.dart';
import '../../utils/AppConfig.dart';
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
        child: LoaderOverlay(
          useDefaultLoading: false,
          overlayWidget: Center(
            child: LoadingAnimationWidget.threeRotatingDots(
              color: AppStyles.secondaryColor,
              size: 30,
            ),
          ),
          child: Scaffold(
            body: SafeArea(
              child: Form(
                key: _loginScreenController.formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        Image(
                          image: const AssetImage(AppConfig.logo_1),
                          width: 70,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Welcome Back !',
                          style: AppStyles.googleFontMontserrat.copyWith(
                              fontWeight: FontWeight.w700, fontSize: 24),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Sign in with your email and\n \t \t \t \t password',
                          style: AppStyles.googleFontMontserrat.copyWith(
                              fontWeight: FontWeight.w400, fontSize: 14),
                        ),
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 28.0),
                              CustomTextFormField(
                                  controller:
                                      _loginScreenController.emailController,
                                  labelText: 'Email',
                                  keyboardType: TextInputType.emailAddress,
                                  validator:
                                      _loginScreenController.validateEmail),
                              const SizedBox(height: 28.0),
                              CustomTextFormField(
                                  controller:
                                      _loginScreenController.passwordController,
                                  labelText: 'Password',
                                  obscureText: true,
                                  validator:
                                      _loginScreenController.validatePassword),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        CustomElevatedButton(
                          onPressed: () async {
                            Map<String, dynamic> formDataMap = {};
                            formDataMap = {
                              'username': _formKey
                                  .currentState?.fields['username']?.value,
                              'password': _formKey
                                  .currentState?.fields['password']?.value,
                            };

                         /*   RespondModel resp = RespondModel(
                                await Utils.http_post('login', form_data_map));

                            if(resp.code != 1){
                              Utils.toast(resp.message);
                              return;
                            }


                            print(resp.message);

                            return;*/

                            context.loaderOverlay.show();
                            _loginScreenController.loginUser();
                            setState(() {
                              _isLoaderVisible = context.loaderOverlay.visible;
                            });
                            await Future.delayed(const Duration(seconds: 2));
                            if (_isLoaderVisible) {
                              context.loaderOverlay.hide();
                            }
                            setState(() {
                              _isLoaderVisible = context.loaderOverlay.visible;
                            });
                          },
                          text: 'Login',
                        ),
                        const SizedBox(height: 18),
                        Wrap(children: [
                          Text(
                            "Don't have an account?",
                            style: AppStyles.googleFontMontserrat.copyWith(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          InkWell(
                            onTap: () {
                              AppRouter.goToRegister();
                            },
                            child: Text(
                              'Register',
                              style: AppStyles.googleFontMontserrat.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppStyles.secondaryColor),
                            ),
                          ),
                        ])
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
