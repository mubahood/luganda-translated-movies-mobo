import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/screens/auth/login_screen.dart';

import '../../models/LoggedInUserModel.dart';
import '../../models/RespondModel.dart';
import '../../utils/AppConfig.dart';
import '../../utils/CustomTheme.dart';
import '../../utils/Utilities.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  Future<void> submit_form() async {
    Utils.toast("Time to create account....");
    return;
    if (!_formKey.currentState!.validate()) {
      Utils.toast("Please fix errors in the form.", color: Colors.red);
      return;
    }

    Map<String, dynamic> formDataMap = {};
    formDataMap = {
      'username': _formKey.currentState?.fields['username']?.value,
      'password': _formKey.currentState?.fields['password']?.value,
    };

    is_loading = true;
    error_message = "";
    setState(() {});
    print("====================GETTING===============");
    RespondModel resp =
        RespondModel(await Utils.http_post('login', formDataMap));

    print("===========${resp.code}===============");
    if (resp.code != 1) {
      is_loading = false;
      error_message = resp.message;
      setState(() {});
      return;
    }

    LoggedInUserModel u = LoggedInUserModel.fromJson(resp.data);

    if (!(await u.save())) {
      is_loading = false;
      error_message = 'Failed to log you in.';
      setState(() {});
      return;
    }

    LoggedInUserModel lu = await LoggedInUserModel.getLoggedInUser();

    if (lu.id < 1) {
      is_loading = false;
      error_message = 'Failed to retrieve you in.';
      setState(() {});
      return;
    }

    Utils.toast("Success!");

    is_loading = false;
    setState(() {});

    //Get.off(() => SplashScreen());
  }

  String error_message = "";
  bool is_loading = false;

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
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Container(color: Colors.white)),
        body: FxContainer(
            borderRadiusAll: 0,
            marginAll: 0,
            padding: const EdgeInsets.only(left: 25, right: 25, top: 50, bottom: 10),
            color: Colors.white,
            child: FormBuilder(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      height: 50,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Image(
                      width: 70,
                      fit: BoxFit.cover,
                      image: const AssetImage(AppConfig.logo_1),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FxText.headlineMedium(
                      "Create Account",
                      fontWeight: 900,
                      color: Colors.black,
                    ),
                    /* SizedBox(
                          height: 20,
                        ),
                        FxText.titleLarge("Sign in"),*/
                    const SizedBox(
                      height: 10,
                    ),
                    Container(height: 25),
                    FormBuilderTextField(
                      name: 'username',
                      autofocus: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "This field is required.",
                        ),
                      ]),
                      decoration: const InputDecoration(
                        enabledBorder: CustomTheme.input_outline_border,
                        border: CustomTheme.input_outline_focused_border,
                        labelText: "Enter your Phone Number",
                      ),
                    ),
                    Container(height: 25),
                    FormBuilderTextField(
                      name: 'password',
                      obscureText: true,
                      autofocus: false,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        enabledBorder: CustomTheme.input_outline_border,
                        border: CustomTheme.input_outline_focused_border,
                        labelText: "Enter Your Password",
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Password is required.",
                        ),
                      ]),
                    ),
                    Container(height: 10),
                    error_message.isEmpty
                        ? const SizedBox()
                        : FxContainer(
                            margin: const EdgeInsets.only(bottom: 10),
                            color: Colors.red.shade50,
                            child: Text(
                              error_message,
                            ),
                          ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 20,
                      ),
                      child: is_loading
                          ? Center(
                              child: Container(
                                width: 60,
                                height: 60,
                                padding: const EdgeInsets.all(15),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.red),
                                ),
                              ),
                            )
                          : CupertinoButton(
                              color: CustomTheme.primary,
                              onPressed: () {
                                submit_form();
                              },
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50)),
                              padding: FxSpacing.xy(32, 8),
                              pressedOpacity: 0.5,
                              child: FxText.bodyLarge(
                                "REGISTER",
                                color: Colors.white,
                                fontWeight: 700,
                              )),
                    ),
                    Container(height: 5),
                    const Spacer(),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Already have account?",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 14),
                        ),
                        TextButton(
                          style:
                              TextButton.styleFrom(foregroundColor: Colors.transparent),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                color: CustomTheme.primary, fontSize: 14),
                          ),
                          onPressed: () {
                            Get.to(() => const LoginScreen());
                          },
                        )
                      ],
                    ),
                  ],
                ))),
      ),
    );
  }
}
