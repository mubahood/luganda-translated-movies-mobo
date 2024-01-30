import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../controllers/MainController.dart';
import '../../../../utils/CustomTheme.dart';
import '../../../../utils/SizeConfig.dart';
import '../../../../utils/Utilities.dart';
import '../../models/Product.dart';
import '../../models/ProductCategory.dart';
import 'ProductCreateScreen2.dart';
import 'models/ImageModelLocal.dart';

class ProductCreateScreen extends StatefulWidget {
  const ProductCreateScreen({
    Key? key,
  }) : super(key: key);

  @override
  CaseCreateBasicState createState() => CaseCreateBasicState();
}

class CaseCreateBasicState extends State<ProductCreateScreen>
    with SingleTickerProviderStateMixin {
  Product item = Product();

  CaseCreateBasicState();

  bool is_loading = false;

  bool mainLoading = false;

  @override
  void initState() {
    super.initState();
    futureInit = my_init();
  }

  Future<void> get_categories() async {
    categories = await ProductCategory.getItems();
  }

  Future<dynamic> my_init() async {
    get_categories();
    if (mainController.userModel.id < 1) {
      Utils.toast("Please login first");
      Navigator.pop(context);
      return;
    }
    return "Done";
  }

  Future<dynamic> my_update() async {
    setState(() {
      futureInit = my_init();
    });
  }

  final _fKey = GlobalKey<FormBuilderState>();
  String specific_action_taken = "";

  Future<bool> onBackPress() async {
    Get.defaultDialog(
        middleText: "Are you sure you want quit adding new product?",
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
              fontWeight: 700,
            ),
          ),
          FxButton.small(
            backgroundColor: Colors.red,
            onPressed: () {
              deleteLocalAnimal();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: FxText(
              'QUIT',
              color: Colors.white,
              fontWeight: 700,
            ),
          )
        ]);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade200,
          systemOverlayStyle: Utils.overlay(),
          elevation: 0,
          title: FxText.titleLarge(
            "Uploading product",
            color: Colors.black,
            fontWeight: 700,
          ),
        ),
        body: FutureBuilder(
            future: futureInit,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: Text("⌛ Loading..."),
                  );
                default:
                  return main_content();
              }
            }),
      ),
    );
  }

  late Future<dynamic> futureInit;
  final MainController mainController = Get.find<MainController>();

  bool _keyboardVisible = false;

  main_content() {
    return FormBuilder(
      key: _fKey,
      child: Stack(
        children: [
          mainLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FxText(
                                    'Basic Information',
                                    fontWeight: 800,
                                    color: CustomTheme.primary,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  FxContainer(
                                    paddingAll: 0,
                                    height: 5,
                                    width: Get.width / 3,
                                    color: CustomTheme.primary,
                                  )
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FxText(
                                    'More Details',
                                    fontWeight: 800,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  FxContainer(
                                    paddingAll: 0,
                                    height: 5,
                                    width: Get.width / 3,
                                    color: Colors.grey.shade600,
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 35,
                    ),
                    Expanded(
                      child: FxContainer(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        padding:
                            const EdgeInsets.only(top: 30, left: 20, right: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  addPhotos();
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: Colors.black,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    color: CustomTheme.primary.withAlpha(25),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.camera_alt_outlined,
                                          size: 30, color: CustomTheme.primary),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Center(
                                          child: FxText.bodyMedium(
                                        "Add product's photos",
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: 700,
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                              photosToUpload.isEmpty
                                  ? const SizedBox()
                                  : SizedBox(
                                      height: 120.0,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: photosToUpload.length,
                                        itemBuilder: (context, index) {
                                          return single_image_ui(
                                              photosToUpload[index], index);
                                        },
                                      ),
                                    ),
                              const SizedBox(
                                height: 25,
                              ),
                              FormBuilderTextField(
                                decoration: CustomTheme.input_decoration(
                                  labelText: 'Product name',
                                ),
                                initialValue: item.name,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.text,
                                name: 'name',
                                onChanged: (x) {
                                  item.name = x.toString();
                                },
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: "Name is required.",
                                  ),
                                  FormBuilderValidators.min(
                                    1,
                                    errorText: "Name is required",
                                  ),
                                ]),
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              FormBuilderTextField(
                                decoration: CustomTheme.input_decoration(
                                  labelText: 'Product category',
                                ),
                                readOnly: true,
                                onTap: () async {
                                  await get_categories();
                                  showBottomSheetCategoryPicker();
                                },
                                keyboardType: TextInputType.text,
                                name: 'category_text',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: "Category is required.",
                                  ),
                                ]),
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              FormBuilderTextField(
                                decoration: CustomTheme.input_decoration(
                                  labelText: 'Product price (UGX)',
                                ),
                                keyboardType: TextInputType.number,
                                name: 'price_1',
                                onChanged: (x) {
                                  item.price_1 = x.toString();
                                },
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: "Price is required.",
                                  ),
                                  FormBuilderValidators.min(
                                    1,
                                    errorText: "Price should be at least 1KG.",
                                  ),
                                ]),
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              FormBuilderTextField(
                                decoration: CustomTheme.input_decoration(
                                  labelText: 'Product description',
                                ),
                                minLines: 4,
                                maxLines: 5,
                                name: 'description',
                                textCapitalization:
                                    TextCapitalization.sentences,
                                onChanged: (x) {
                                  item.description = x.toString();
                                },
                                readOnly: false,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: "Description is required.",
                                  ),
                                  FormBuilderValidators.min(
                                    1,
                                    errorText: "Description is required",
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _keyboardVisible
                        ? const SizedBox()
                        : FxContainer(
                            color: Colors.white,
                            borderRadiusAll: 0,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: FxButton.block(
                                onPressed: () {
                                  submit();
                                },
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                backgroundColor: CustomTheme.primary,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FxText.titleLarge(
                                      'NEXT',
                                      color: Colors.white,
                                      fontWeight: 800,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Icon(FeatherIcons.arrowRight)
                                  ],
                                ))),
                  ],
                ),
        ],
      ),
    );
  }

  Future<void> addPhotos() async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            color: Colors.transparent,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Padding(
                padding: FxSpacing.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        do_pick_image_from_camera();
                      },
                      dense: false,
                      leading: const Icon(Icons.camera_alt_outlined,
                          size: 28, color: CustomTheme.primary),
                      title: FxText.bodyLarge(
                        "Use camera",
                        fontWeight: 500,
                        fontSize: 18,
                      ),
                    ),
                    ListTile(
                        dense: false,
                        onTap: () {
                          Navigator.pop(context);
                          do_pick_image_from_gallary();
                        },
                        leading: const Icon(Icons.photo_library_outlined,
                            size: 28, color: CustomTheme.primary),
                        title: FxText.bodyLarge(
                          "Pick from gallery",
                          fontWeight: 500,
                          fontSize: 18,
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }

  do_pick_image_from_camera() async {
    final ImagePicker picker = ImagePicker();

    await getItemImages();
    uploadPics();
  }

  List<String> uploadedPics = [];
  List<String> photosToUpload = [];

  do_pick_image_from_gallary() async {
    final ImagePicker picker = ImagePicker();

  }

  void showBottomSheetCategoryPicker() {
    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.5),
        builder: (BuildContext buildContext) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(MySize.size16),
                topRight: Radius.circular(MySize.size16),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FxText.titleMedium(
                          'Filter by categories',
                          color: Colors.black,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {});
                          },
                          child: const Icon(
                            FeatherIcons.x,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, position) {
                          ProductCategory cat = categories[position];
                          return ListTile(
                            onTap: () {
                              category = cat;
                              setState(() {});
                              _fKey.currentState!.patchValue({
                                'category_text': category.category,
                              });

                              Navigator.pop(context);
                            },
                            title: FxText.titleMedium(
                              cat.category,
                              color: CustomTheme.primary,
                              maxLines: 1,
                              fontWeight: 700,
                            ),
                            trailing: cat.id != category.id
                                ? const SizedBox()
                                : const Icon(
                                    Icons.check_circle,
                                    color: CustomTheme.primary,
                                    size: 30,
                                  ),
                            visualDensity: VisualDensity.compact,
                            dense: true,
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }

  ProductCategory category = ProductCategory();
  List<ProductCategory> categories = [];

  single_image_ui(String m, int index) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(
              color: CustomTheme.primary,
              width: 5,
            ),
            color: CustomTheme.primary.withAlpha(25),
          ),
          padding: const EdgeInsets.all(0),
          child: Image.file(
            File(m),
            fit: BoxFit.fitWidth,
            width: 100,
            height: double.infinity,
          ),
        ),
        Positioned(
          top: 40,
          left: 40,
          child: Center(
              child: FxContainer(
            paddingAll: 5,
            color: uploadedPics.contains(m)
                ? Colors.green.shade700
                : Colors.white.withOpacity(.6),
            borderRadiusAll: 100,
            child: uploadedPics.contains(m)
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                  )
                : const CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(CustomTheme.primary),
                  ),
          )),
        ),
        Positioned(
            right: 0,
            child: InkWell(
              onTap: () => {removeImage(m, index)},
              child: Container(
                child: FxContainer(
                  width: 35,
                  alignment: Alignment.center,
                  borderRadiusAll: 17,
                  height: 35,
                  color: Colors.red.shade700,
                  paddingAll: 0,
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Future<void> deleteLocalAnimal() async {}

  bool isUploading = false;

  uploadPics() async {
    if (isUploading) {
      return;
    }
    isUploading = true;
    for (var x in item.local_photos) {
      if (uploadedPics.contains(x.src)) {
        continue;
      }

      if (x.media_path.length < 2) {
        x.media_path = x.src;
      }
      x.parent_endpoint = 'Product';
      x.item_type = 'Product';
      x.parent_id = item.id.toString();
      x.online_parent_id = x.parent_id;

      if (await x.uploadSelf()) {
        Utils.toast2("SUCCESS");
        uploadedPics.add(x.src);
      }else{
        Utils.toast2("FAILED");
      }
      setState(() {});
      isUploading = false;
      uploadPics();
      break;
    }
  }

  saveLocalImage(String path) async {
    ImageModelLocal img = ImageModelLocal();
    img.type = 'Product';
    img.parent_endpoint = 'Product';
    img.src = path;
    img.media_path = path;
    img.product_id = item.id.toString();
    img.parent_id = item.id.toString();
    img.online_parent_id = item.id.toString();
    photosToUpload.add(img.src);
    await img.save();
    item.local_photos.add(img);
    setState(() {});
  }

  getItemImages() {}

  removeImage(String m, int index) async {
    photosToUpload.removeAt(index);
    setState(() {});
    for (var x in item.local_photos) {
      if (x.src == m) {
        item.local_photos.removeAt(index);
        await x.delete();
        break;
      }
    }

    setState(() {});
  }

  Future<void> submit() async {
    if (item.local_photos.isEmpty) {
      Utils.toast("Please add at least one image.");
      return;
    }

    if (!_fKey.currentState!.validate()) {
      Utils.toast2("First fix issues before you proceed.");
      return;
    }
    if (category.id < 1) {
      Utils.toast("Please select a category.");
      return;
    }

    item.productCategory = category;
    item.category = category.id.toString();
    item.productCategory.getAttributesList();

    uploadPics();
    setState(() {});
    var data = await Get.to(() => ProductCreateScreen2(item));
    if (data != null) {
      if (data['done'] == 'done') {
        Get.back(result: {'done': 'done'});
      }
    }
    return;
  }
}
