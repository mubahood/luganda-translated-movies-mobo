import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import '../../../models/RespondModel.dart';
import '../../../utils/Utilities.dart';
import '../screens/shop/models/ImageModelLocal.dart';
import 'ImageModelLocal.dart';
import 'ProductCategory.dart';

class Product {
  static String endPoint = "products";
  static String tableName = "products";

  int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  String name = "";
  String metric = "";
  String currency = "";
  String description = "";
  String summary = "";
  String price_1 = "";
  String price_2 = "";
  String feature_photo = "";
  String rates = "";
  String date_added = "";
  String date_updated = "";
  String user = "";
  String category = "";
  String sub_category = "";
  String supplier = "";
  String url = "";
  String status = "";
  String in_stock = "";
  String keywords = "";
  String p_type = "";

  List<ImageModelLocal> local_photos = [];
  List<ImageModel> online_photos = [];
  ProductCategory productCategory = ProductCategory();

  List<Map<String, String>> attributes = [];

  getAttributes() {
    if (summary.length > 3) {
      try {
        attributes = [];
        var temp = jsonDecode(summary);
        temp.forEach((key, value) {
          attributes.add(
              {"key": key.toString().trim(), "value": value.toString().trim()});
        });
      } catch (e) {
        attributes = [];
      }
    }
  }

  getOnlinePhotos() {
    online_photos.clear();
    if (feature_photo.isNotEmpty) {
      ImageModel img = ImageModel();
      img.src = feature_photo;
      img.thumbnail = feature_photo;
      online_photos.add(img);
    }
    online_photos.addAll(ImageModel.fromJsonList(rates));
  }

  static fromJson(dynamic m) {
    Product obj = Product();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.name = Utils.to_str(m['name'], '');
    obj.metric = Utils.to_str(m['metric'], '');
    obj.currency = Utils.to_str(m['currency'], '');
    obj.description = Utils.to_str(m['description'], '');
    obj.summary = Utils.to_str(m['summary'], '');
    obj.price_1 = Utils.to_str(m['price_1'], '');
    obj.price_2 = Utils.to_str(m['price_2'], '');
    obj.feature_photo = Utils.to_str(m['feature_photo'], '');
    obj.rates = Utils.to_str(m['rates'], '');
    obj.date_added = Utils.to_str(m['date_added'], '');
    obj.date_updated = Utils.to_str(m['date_updated'], '');
    obj.user = Utils.to_str(m['user'], '');
    obj.category = Utils.to_str(m['category'], '');
    obj.sub_category = Utils.to_str(m['sub_category'], '');
    obj.supplier = Utils.to_str(m['supplier'], '');
    obj.url = Utils.to_str(m['url'], '');
    obj.status = Utils.to_str(m['status'], '');
    obj.in_stock = Utils.to_str(m['in_stock'], '');
    obj.keywords = Utils.to_str(m['keywords'], '');
    obj.p_type = Utils.to_str(m['p_type'], '');
    if (obj.feature_photo.contains('images')) {
      obj.feature_photo = "images/${obj.feature_photo}";
    }
    try {
      obj.getAttributes();
    } catch (e) {
      obj.attributes = [];
    }

    return obj;
  }

  static Future<List<Product>> getLocalData({String where = "1"}) async {
    List<Product> data = [];
    if (!(await Product.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps = await db.query(Product.tableName, where: where);

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(Product.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<Product>> getItems({String where = '1'}) async {
    List<Product> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await Product.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      data = await getLocalData(where: where);
      Product.getOnlineItems();
    }
    data.sort((a, b) => b.id.compareTo(a.id));
    return data;
  }

  static Future<List<Product>> getOnlineItems() async {
    List<Product> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get(Product.endPoint, {}));

    if (resp.code != 1) {
      return [];
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return [];
    }

    if (resp.data.runtimeType.toString().contains('List')) {
      if (await Utils.is_connected()) {
        await Product.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          Product sub = Product.fromJson(x);
          try {
            batch.insert(tableName, sub.toJson(),
                conflictAlgorithm: ConflictAlgorithm.replace);
          } catch (e) {}
        }

        try {
          await batch.commit(continueOnError: true);
        } catch (e) {}
      });
    }

    return [];

    return data;
  }

  save() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await initTable();

    try {
      await db.insert(
        tableName,
        toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'metric': metric,
      'currency': currency,
      'description': description,
      'summary': summary,
      'price_1': price_1,
      'price_2': price_2,
      'feature_photo': feature_photo,
      'rates': rates,
      'date_added': date_added,
      'date_updated': date_updated,
      'user': user,
      'category': category,
      'sub_category': sub_category,
      'supplier': supplier,
      'url': url,
      'status': status,
      'in_stock': in_stock,
      'keywords': keywords,
      'p_type': p_type,
    };
  }

  static Future<bool> initTable() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }

    String sql = "CREATE TABLE  IF NOT EXISTS  ${Product.tableName} (  "
        "id INTEGER PRIMARY KEY,"
        " name TEXT,"
        " metric TEXT,"
        " currency TEXT,"
        " description TEXT,"
        " summary TEXT,"
        " price_1 TEXT,"
        " price_2 TEXT,"
        " feature_photo TEXT,"
        " rates TEXT,"
        " date_added TEXT,"
        " date_updated TEXT,"
        " user TEXT,"
        " category TEXT,"
        " sub_category TEXT,"
        " supplier TEXT,"
        " url TEXT,"
        " status TEXT,"
        " in_stock TEXT,"
        " keywords TEXT,"
        " p_type TEXT)";
    try {
      //await db.execute('DROP TABLE $tableName');

      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table because ${e.toString()}');

      return false;
    }

    return true;
  }

  static deleteAll() async {
    if (!(await Product.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(tableName);
  }
}