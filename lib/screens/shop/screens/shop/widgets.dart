import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/models/LoggedInUserModel.dart';

import '../../../../utils/AppConfig.dart';
import '../../../../utils/CustomTheme.dart';
import '../../../../utils/Utilities.dart';
import '../../../../utils/app_theme.dart';
import '../../../../widget/widgets.dart';
import '../../../auth/login_screen.dart';
import '../../../auth/register_screen.dart';
import '../../models/ChatHead.dart';
import '../../models/Product.dart';
import 'ProductScreen.dart';
import 'chat/chat_screen.dart';

//create title_detail_widget
Widget title_detail_widget(String title, String detail) {
  return Container(
    padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
    child: Flex(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      direction: Axis.vertical,
      children: [
        FxText.titleMedium(
          title,
          fontWeight: 800,
          color: Colors.black,
        ),
        const SizedBox(
          height: 0,
        ),
        FxText.bodyMedium(
          detail.isEmpty ? "-" : detail,
          color: Colors.grey.shade600,
        ),
      ],
    ),
  );
}

Widget chatHeadUi(ChatHead item) {
  return InkWell(
    onTap: () {
      Get.to(() => ChatScreen(item, Product()));
    },
    child: Container(
      color: item.myUnreadCount < 1
          ? Colors.transparent
          : CustomTheme.primary.withOpacity(0.2),
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 15,
        right: 15,
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(100),
              topRight: Radius.circular(100),
              bottomLeft: Radius.circular(100),
              bottomRight: Radius.circular(100),
            ),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              width: 60,
              height: 60,
              imageUrl:
                  "${AppConfig.MAIN_SITE_URL}/storage/images/${item.product_photo}",
              placeholder: (context, url) => ShimmerLoadingWidget(),
              errorWidget: (context, url, error) => const Image(
                width: 60,
                height: 60,
                image: AssetImage(AppConfig.NO_IMAGE),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: FxText.bodyLarge(
                        "${item.product_name} ",
                        height: 1,
                        fontWeight: 900,
                        color: Colors.grey.shade800,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    item.myUnreadCount < 1
                        ? const SizedBox()
                        : FxContainer(
                            alignment: Alignment.center,
                            color: CustomTheme.primary,
                            paddingAll: 0,
                            width: 25,
                            height: 25,
                            borderRadiusAll: 100,
                            child: FxText.bodySmall(
                              "${item.myUnreadCount}",
                              height: 1,
                              fontWeight: 800,
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                FxText.bodyMedium(
                  item.last_message_body,
                  height: 1,
                  maxLines: 1,
                  color: item.myUnreadCount < 1
                      ? Colors.grey.shade600
                      : Colors.black,
                  fontWeight: item.myUnreadCount < 1 ? 600 : 800,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FxText.bodySmall(
                      Utils.to_date(item.updated_at),
                      height: 1,
                      color: Colors.grey.shade600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              ],
            ),
          )),
        ],
      ),
    ),
  );
}

Widget productUi2(Product pro) {
  return InkWell(
    onTap: () {
      Get.to(() => ProductScreen(pro), preventDuplicates: false);
    },
    child: Container(
      color: Colors.grey.shade200,
      height: Get.height / 6,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          CachedNetworkImage(
            fit: BoxFit.cover,
            width: Get.width / 3.5,
            height: double.infinity,
            imageUrl:
                "${AppConfig.MAIN_SITE_URL}/storage/images/${pro.feature_photo}",
            placeholder: (context, url) => ShimmerLoadingWidget(),
            errorWidget: (context, url, error) => Image(
              width: Get.width / 3.5,
              height: double.infinity,
              image: const AssetImage(AppConfig.NO_IMAGE),
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
              child: Container(
            padding:
                const EdgeInsets.only(left: 15, right: 10, top: 15, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FxText.titleMedium(
                  "${pro.name} ",
                  height: 1,
                  fontWeight: 800,
                  maxLines: 2,
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis,
                ),
                FxContainer(
                  color: Colors.white,
                  borderRadiusAll: 0,
                  paddingAll: 5,
                  child: FxText.titleLarge(
                    "UGX ${Utils.moneyFormat(pro.price_1)} ",
                    height: 1,
                    fontWeight: 800,
                    maxLines: 3,
                    color: CustomTheme.primary,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    ),
  );
}

Widget roundedImage(String url, double w, double h,
    {String no_image = AppConfig.NO_IMAGE, double radius = 10}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: url,
      width: (Get.width / w),
      height: (Get.width / h),
      placeholder: (context, url) => ShimmerLoadingWidget(
        height: double.infinity,
      ),
      errorWidget: (context, url, error) => Image(
        image: AssetImage(no_image),
        fit: BoxFit.cover,
        width: (Get.width / w),
        height: (Get.width / h),
      ),
    ),
  );
}

Widget circularImage(String url, double size,
    {String no_image = AppConfig.USER_IMAGE}) {
  return ClipOval(
    child: Container(
      color: CustomTheme.primary,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: url,
        width: (Get.width / size),
        height: (Get.width / size),
        placeholder: (context, url) => ShimmerLoadingWidget(
          height: double.infinity,
        ),
        errorWidget: (context, url, error) => Image(
          image: AssetImage(no_image),
          fit: BoxFit.cover,
          width: (Get.width / size),
          height: (Get.width / size),
        ),
      ),
    ),
  );
}

Widget titleValueWidget(String title, String subTitle) {
  return Container(
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(bottom: 7),
    child: Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: FxText.bodyLarge(
            '$title : '.toUpperCase(),
            textAlign: TextAlign.left,
            color: Colors.black,
            fontWeight: 700,
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        FxText.bodyLarge(
          subTitle.isEmpty ? "-" : subTitle,
          maxLines: 10,
          letterSpacing: .5,
          height: 1,
        ),
      ],
    ),
  );
}

Widget titleValueWidget2(String title, String subTitle) {
  return Container(
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(top: 7),
    child: Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: FxText.bodyLarge(
            '$title : '.toUpperCase(),
            textAlign: TextAlign.left,
            color: Colors.black,
            fontWeight: 700,
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        Expanded(
          child: FxText.bodyLarge(
            subTitle.isEmpty ? "-" : subTitle,
            textAlign: TextAlign.right,
            fontWeight: 500,
          ),
        ),
      ],
    ),
  );
}

Widget singleWidget(String title, String subTitle, {int maxLines = 10}) {
  /*   return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: valueUnitWidget(
        context,
        '${title} :',
        subTitle,
        fontSize: 10,
        titleColor = CustomTheme.primary,
        color = Colors.grey.shade600,
      ),
    );*/
  return Container(
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(top: 2, bottom: 2),
    child: Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerRight,
          child: FxText.bodyLarge(
            '$title :'.toUpperCase(),
            textAlign: TextAlign.right,
            color: Colors.grey.shade500,
            fontWeight: 900,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
            child: FxText.bodyLarge(
          subTitle,
          color: Colors.black,
          maxLines: maxLines,
        )),
      ],
    ),
  );
}

Widget userWidget1(LoggedInUserModel item) {
  return InkWell(
    onTap: () {},
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: circularImage(item.avatar.toString(), 5.5),
        ),
        Center(
          child: FxText.titleSmall(
            item.name,
            maxLines: 1,
            height: 1.2,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

Widget productWidget2(Product u) {
  return InkWell(
    onTap: () {
      Get.to(() => ProductScreen(u));
    },
    child: Container(
      padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          roundedImage(
              "${AppConfig.MAIN_SITE_URL}/storage/images/${u.feature_photo}",
              4.5,
              4.5),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.titleMedium(
                  u.name,
                  maxLines: 2,
                  fontWeight: 800,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 6,
                ),
                FxContainer(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  borderRadiusAll: 0,
                  color: CustomTheme.primary,
                  child: FxText.bodyLarge(
                    "UGX ${Utils.moneyFormat(u.price_1).toString().toUpperCase()}",
                    fontWeight: 800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    const Icon(
                      FeatherIcons.shield,
                      size: 12,
                      color: CustomTheme.primaryDark,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    FxText.bodySmall(
                      u.category.toUpperCase(),
                      color: Colors.grey,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    const Icon(
                      FeatherIcons.clock,
                      size: 12,
                      color: CustomTheme.primaryDark,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    FxText.bodySmall(
                      Utils.to_date_1(u.date_added),
                      maxLines: 1,
                      color: Colors.grey,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget productWidget(Product u) {
  return InkWell(
    onTap: () {
      Get.to(() => ProductScreen(u));
    },
    child: Container(
      padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          roundedImage(
              "${AppConfig.MAIN_SITE_URL}/storage/images/${u.feature_photo}",
              4.5,
              4.5),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.titleMedium(
                  u.name,
                  maxLines: 2,
                  fontWeight: 800,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 6,
                ),
                FxContainer(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  borderRadiusAll: 0,
                  color: CustomTheme.primary,
                  child: FxText.bodyLarge(
                    "\$ ${Utils.moneyFormat(u.price_1).toString().toUpperCase()}",
                    fontWeight: 800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    const Icon(
                      FeatherIcons.shield,
                      size: 12,
                      color: CustomTheme.primaryDark,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    FxText.bodySmall(
                      u.category.toUpperCase(),
                      color: Colors.grey,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    const Icon(
                      FeatherIcons.clock,
                      size: 12,
                      color: CustomTheme.primaryDark,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    FxText.bodySmall(
                      Utils.to_date_1(u.date_added),
                      maxLines: 1,
                      color: Colors.grey,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget userWidget(LoggedInUserModel u) {
  return InkWell(
    onTap: () {},
    child: Container(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          roundedImage(u.avatar.toString(), 4.5, 4.5),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.titleMedium(
                  u.name.toUpperCase(),
                  maxLines: 1,
                  fontWeight: 800,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    FxText.bodyMedium(
                      'CLASS: ',
                    ),
                    FxText.bodyMedium(
                      u.name.toUpperCase(),
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
                Row(
                  children: [
                    FxText.bodyMedium(
                      'STUDENT ID: ',
                    ),
                    FxText.bodyMedium(
                      u.id.toString().toUpperCase(),
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    const Icon(
                      FeatherIcons.user,
                      size: 12,
                      color: CustomTheme.primaryDark,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    FxText.bodySmall('By John Doe', color: Colors.grey),
                    const Spacer(),
                    const Icon(
                      FeatherIcons.clock,
                      size: 12,
                      color: CustomTheme.primaryDark,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    FxText.bodySmall(
                      Utils.to_date_1(u.created_at),
                      color: Colors.grey,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget alertWidget(String msg, String type) {
  if (msg.isEmpty) {
    return const SizedBox();
  }
  Color borderColor = CustomTheme.primary;
  Color bgColor = CustomTheme.primary.withAlpha(10);
  if (type == 'success') {
    borderColor = Colors.green.shade700;
    bgColor = Colors.green.shade700.withAlpha(10);
  } else if (type == 'danger') {
    borderColor = Colors.red.shade700;
    bgColor = Colors.red.shade700.withAlpha(10);
  }

  return FxContainer(
    margin: const EdgeInsets.only(bottom: 15),
    width: double.infinity,
    color: bgColor,
    bordered: true,
    borderColor: borderColor,
    child: FxText(msg),
  );
}

Widget notLoggedInWidget() {
  return Center(
    child: Column(
      children: [
        const Spacer(),
        FxCard(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Icon(
                  FeatherIcons.info,
                  size: 50,
                  color: CustomTheme.primary,
                ),
                const SizedBox(
                  height: 15,
                ),
                FxText.titleLarge(
                  'You are not logged in yet.',
                  color: Colors.black,
                  fontWeight: 800,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Divider(
                    height: 45,
                  ),
                ),
                FxButton.small(
                  onPressed: () {
                    Get.to(() => const RegisterScreen());
                  },
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: FxText(
                    'CREATE ACCOUNT',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FxText('OR'),
                const SizedBox(
                  height: 10,
                ),
                FxButton.outlined(
                  onPressed: () {
                    Get.to(const LoginScreen());
                  },
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  borderColor: CustomTheme.primary,
                  child: FxText(
                    'LOGIN',
                    color: CustomTheme.primary,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            )),
        const Spacer(),
      ],
    ),
  );
}

Widget noItemWidget(String title, Function onTap) {
  if (title.isEmpty) {
    title = "😇 No item found.";
  }
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FxText(
          title,
        ),
        FxButton.text(
            onPressed: () {
              onTap();
            },
            child: const Text("Reload"))
      ],
    ),
  );
}

Widget titleWidget(String title, Function onTap) {
  return InkWell(
    onTap: () {
      onTap();
    },
    child: Container(
      padding: const EdgeInsets.only(left: 5, top: 20, right: 5, bottom: 20),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          FxText.titleMedium(
            title.toUpperCase(),
            fontWeight: 800,
            color: CustomTheme.primary,
          ),
          const Spacer(),
          Row(
            children: [
              FxText.bodyLarge(
                'View All'.toUpperCase(),
                fontWeight: 700,
                color: Colors.black,
                letterSpacing: .1,
              ),
              const Icon(FeatherIcons.chevronRight),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget textInput2(
  context, {
  required String label,
  required String name,
  required String value,
  bool required = false,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10, top: 10),
    child: FormBuilderTextField(
      name: name,
      initialValue: value,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      onChanged: (x) {},
      keyboardType: TextInputType.name,
      decoration: AppTheme.InputDecorationTheme1(
        label: label,
      ),
      validator: (!required)
          ? FormBuilderValidators.compose([])
          : MyWidgets.my_validator_field_required(
              context, '$label is required'),
    ),
  );
  return FormBuilderTextField(
    decoration: CustomTheme.in_3(
      label: label,
    ),
    initialValue: value,
    textCapitalization: TextCapitalization.sentences,
    name: name,
    validator: (!required)
        ? FormBuilderValidators.compose([])
        : MyWidgets.my_validator_field_required(context, 'Title is required'),
    textInputAction: TextInputAction.next,
  );
}

Widget textInput(
  context, {
  required String label,
  required String name,
  required String value,
  bool required = false,
}) {
  return FormBuilderTextField(
    decoration: CustomTheme.in_3(
      label: label,
    ),
    initialValue: value,
    textCapitalization: TextCapitalization.sentences,
    name: name,
    validator: (!required)
        ? FormBuilderValidators.compose([])
        : MyWidgets.my_validator_field_required(context, 'Title is required'),
    textInputAction: TextInputAction.next,
  );
}

// ignore: non_constant_identifier_names
Widget title_widget_2(String title) {
  return FxContainer(
    alignment: Alignment.center,
    color: CustomTheme.primaryDark,
    borderRadiusAll: 0,
    paddingAll: 5,
    child: FxText.bodyLarge(
      title.toUpperCase(),
      color: Colors.white,
    ),
  );
}

// ignore: non_constant_identifier_names
Widget title_widget(String title) {
  return Container(
    padding: const EdgeInsets.only(top: 3, bottom: 3),
    color: CustomTheme.primary,
    child: Center(
      child: FxText.titleMedium(
        title.toUpperCase(),
        textAlign: TextAlign.center,
        fontWeight: 700,
        fontSize: 18,
        color: Colors.white,
      ),
    ),
  );
}

// ignore: non_constant_identifier_names
Widget IconTextWidget(
  String t,
  String s,
  bool isDone,
  Function f, {
  bool show_acation_button = true,
  String action_text = "Edit",
}) {
  return ListTile(
    leading: isDone
        ? const Icon(
            Icons.check,
            color: Colors.green,
            size: 28,
          )
        : Icon(
            Icons.label_outline_sharp,
            color: Colors.red.shade600,
            size: 28,
          ),
    contentPadding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
    minLeadingWidth: 0,
    trailing: (!show_acation_button)
        ? null
        : FxButton.outlined(
            onPressed: () {
              f();
            },
            padding: EdgeInsets.zero,
            borderRadiusAll: 30,
            borderColor: CustomTheme.primary,
            child: FxText(
              action_text,
              color: CustomTheme.primary,
              fontSize: 18,
            ),
          ),
    title: FxText.titleMedium(
      t,
      fontWeight: 700,
      color: Colors.black,
    ),
    subtitle: FxText.bodyMedium(s,
        fontWeight: 600,
        maxLines: 2,
        color: Colors.grey.shade700,
        height: 1.1,
        overflow: TextOverflow.ellipsis),
  );
}

class MyWidgets {
  static FormFieldValidator my_validator_field_required(
      BuildContext context, String field) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(
        errorText: "$field is required.",
      ),
    ]);
  }
}
