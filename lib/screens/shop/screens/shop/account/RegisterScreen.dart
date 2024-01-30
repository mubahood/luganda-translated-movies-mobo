// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutx/widgets/text/text.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
// import '../../../../../utils/AppConfig.dart';
// import '../../../../../utils/SizeConfig.dart';
// import '../../../../../utils/Utilities.dart';
// import '../full_app/full_app.dart';
//
// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});
//
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormBuilderState>();
//   final bool _passwordVisible = false;
//   bool onLoading = false;
//   String error_message = "";
//
//   Future<void> submit_form() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//
//     String phoneNumber = Utils.prepare_phone_number(
//         _formKey.currentState?.fields['phone_number']?.value);
//
//     if (!Utils.phone_number_is_valid(phoneNumber)) {
//       error_message = "Enter valid ugandan phone number.";
//       Utils.toast(error_message);
//       setState(() {
//         onLoading = false;
//         error_message = "";
//       });
//       return;
//     }
//
//     if (_formKey.currentState?.fields['password']?.value !=
//         _formKey.currentState?.fields['password_2']?.value) {
//       error_message = "Passwords did not match.";
//       Utils.toast(error_message);
//       setState(() {
//         onLoading = false;
//         error_message = "";
//       });
//       return;
//     }
//
//     if ((_formKey.currentState?.fields['password']?.value.length < 4)) {
//       error_message = "Password too short.";
//       Utils.toast(error_message);
//       setState(() {
//         onLoading = false;
//         error_message = "";
//       });
//       return;
//     }
//
//     setState(() {
//       onLoading = true;
//       error_message = "";
//     });
//
//     RespondModel resp = RespondModel(await Utils.http_post('users/register', {
//       'name': _formKey.currentState?.fields['name']?.value,
//       'phone_number': _formKey.currentState?.fields['phone_number']?.value,
//       'address': _formKey.currentState?.fields['address']?.value,
//       'password': _formKey.currentState?.fields['password']?.value,
//     }));
//
//     if (resp.code != 1) {
//       onLoading = false;
//       error_message = resp.message;
//       setState(() {});
//       return;
//     }
//
//     UserModel u = LoggedInUserModel.fromJsonToObject1(resp.data);
//
//     if (true) {
//       onLoading = false;
//       error_message = 'Failed to log you in.';
//       setState(() {});
//       return;
//     }
//
//     UserModel lu = await LoggedInUserModel.getLoggedInUser();
//
//     if (lu.id < 1) {
//       onLoading = false;
//       error_message = 'Failed to retrieve you in.';
//       setState(() {});
//       return;
//     }
//
//     setState(() {
//       onLoading = false;
//     });
//
//     Utils.toast("Success!");
//     Get.off(() => const FullApp());
//
//     return;
//   }
//
//
//   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//   void save_user(String u) async {
//     final SharedPreferences prefs = await _prefs;
//
//     dynamic u0 = jsonDecode(u);
//     if (u0['roles'] != null) {
//       if (u0['roles'][0] != null) {
//         if (u0['roles'][0]['slug'] != null) {
//           Utils.set_local(AppConfig.USER_ROLE, u0['roles'][0]['slug']);
//         }
//       }
//     }
//
//     await prefs.setString('user', u);
//     Navigator.pushNamedAndRemoveUntil(context, '/BoardingScreen', (r) => false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: ListView(
//       children: [
//         SizedBox(
//           height: 60,
//           child: Stack(
//             children: <Widget>[
//               Container(
//                 decoration: BoxDecoration(
//                     color :CustomTheme.primary,
//                     borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(MySize.size96))),
//               ),
//               Positioned(
//                 bottom: 20,
//                 right: 40,
//                 child: FxText.titleLarge(
//                   "Creating new account",
//                   color :Colors.white,
//                   fontWeight : 800,
//                 ),
//               )
//             ],
//           ),
//         ),
//         Container(
//           color :Colors.white,
//           padding: const EdgeInsets.only(top: 10),
//           child: const Center(
//             child: Image(
//               image: AssetImage("./assets/images/logo.png"),
//               height: 140,
//               width: 140,
//             ),
//           ),
//         ),
//         Container(
//             margin: EdgeInsets.only(
//                 left: MySize.size16,
//                 right: MySize.size16,
//                 top: MySize.size16),
//             color :Colors.white,
//             padding:
//                 EdgeInsets.only(left: MySize.size16, right: MySize.size16),
//             child: FormBuilder(
//               key: _formKey,
//               child: Padding(
//                 padding: EdgeInsets.only(
//                     top: MySize.size10,
//                     left: MySize.size5,
//                     right: MySize.size5,
//                     bottom: MySize.size10),
//                 child: Column(
//                   children: <Widget>[
//                     Container(
//                       margin: const EdgeInsets.only(bottom: 20, top: 10),
//                       child: FormBuilderTextField(
//                         name: 'name',
//                         decoration: AppTheme.InputDecorationTheme1(
//                           label: "Your full name",
//                         ),
//                         keyboardType: TextInputType.name,
//                         textCapitalization: TextCapitalization.words,
//                         autofocus: false,
//                         textInputAction: TextInputAction.next,
//                         validator: FormBuilderValidators.compose([
//                           FormBuilderValidators.required(
//                             errorText: "Name is required.",
//                           ),
//                         ]),
//                       ),
//                     ),
//                     Container(
//                       margin: const EdgeInsets.only(bottom: 20),
//                       child: FormBuilderTextField(
//                         name: 'phone_number',
//                         autofocus: false,
//                         textInputAction: TextInputAction.next,
//                         keyboardType: TextInputType.phone,
//                         decoration: AppTheme.InputDecorationTheme1(
//                           label: "Phone number",
//                         ),
//                         validator: FormBuilderValidators.compose([
//                           FormBuilderValidators.required(
//                             errorText: "Phone number required.",
//                           ),
//                           FormBuilderValidators.minLength(
//                             10,
//                             errorText: "Phone number too short.",
//                           ),
//                           FormBuilderValidators.maxLength(
//                             15,
//                             errorText: "Phone number too long.",
//                           ),
//                         ]),
//                       ),
//                     ),
//                     Container(
//                       margin: const EdgeInsets.only(bottom: 20),
//                       child: FormBuilderTextField(
//                         name: 'password',
//                         autofocus: false,
//                         textInputAction: TextInputAction.next,
//                         keyboardType: TextInputType.visiblePassword,
//                         decoration: AppTheme.InputDecorationTheme1(
//                           label: "Password",
//                         ),
//                         validator: FormBuilderValidators.compose([
//                           FormBuilderValidators.required(
//                             errorText: "Password required.",
//                           ),
//                         ]),
//                       ),
//                     ),
//                     Container(
//                       margin: const EdgeInsets.only(bottom: 20),
//                       child: FormBuilderTextField(
//                         name: 'password_2',
//                         textInputAction: TextInputAction.done,
//                         keyboardType: TextInputType.visiblePassword,
//                         decoration: AppTheme.InputDecorationTheme1(
//                           label: "Re-enter Password",
//                         ),
//                         validator: FormBuilderValidators.compose([
//                           FormBuilderValidators.required(
//                             errorText: "Password required.",
//                           ),
//                         ]),
//                       ),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: const BorderRadius.all(Radius.circular(10)),
//                         color :Colors.red.shade50,
//                       ),
//                       child: error_message.isEmpty
//                           ? const SizedBox(
//                               height: 0,
//                               width: 0,
//                             )
//                           : Container(
//                               padding: const EdgeInsets.all(12),
//                               child: Text(
//                                 error_message,
//                                 style: TextStyle(color: Colors.red.shade800),
//                               ),
//                             ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius:
//                             BorderRadius.all(Radius.circular(MySize.size24)),
//                         boxShadow: [
//                           BoxShadow(
//                             color :CustomTheme.primary.withAlpha(28),
//                             blurRadius: 3,
//                             offset: const Offset(0, 1),
//                           ),
//                         ],
//                       ),
//                       child: onLoading
//                           ? Padding(
//                               padding: const EdgeInsets.all(6.0),
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2.0,
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                     CustomTheme.primary),
//                               ),
//                             )
//                           : ElevatedButton(
//                               style: ButtonStyle(
//                                   backgroundColor:
//                                       MaterialStateProperty.all<Color>(
//                                           CustomTheme.primary),
//                                   padding: MaterialStateProperty.all(
//                                       Spacing.xy(20, 15))),
//                               onPressed: () {
//                                 submit_form();
//                               },
//                               child: FxText.bodyLarge(
//                                 "CREATE ACCOUNT",
//                                 color :Colors.white,
//                               )),
//                     ),
//                     Container(
//                       margin: const EdgeInsets.only(top: 20),
//                       child: const Center(
//                         child: Text(
//                           "OR",
//                         ),
//                       ),
//                     ),
//                     Container(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           onLoading
//                               ? const Text("")
//                               : GestureDetector(
//                                   onTap: () {
//                                     Get.offAll(const LoginScreen());
//                                   },
//                                   child: Container(
//                                     margin:
//                                         EdgeInsets.only(top: MySize.size16),
//                                     alignment: Alignment.centerRight,
//                                     child: const Text(
//                                       "Login",
//                                     ),
//                                   ),
//                                 ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             )),
//       ],
//     ));
//   }
// }
