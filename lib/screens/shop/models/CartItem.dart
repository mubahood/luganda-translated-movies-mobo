import 'package:sqflite/sqflite.dart';

import '../../../utils/Utilities.dart';
 

class CartItem {
  static String tableName = "CartItems";

  int id = 0;
  String product_name = "";
  String product_price_1 = "";
  String product_quantity = "";
  String product_feature_photo = "";
  String product_id = "";



  static fromJson(dynamic m) {
    CartItem obj = CartItem();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.product_name = Utils.to_str(m['product_name'], '');
    obj.product_price_1 = Utils.to_str(m['product_price_1'], '');
    obj.product_quantity = Utils.to_str(m['product_quantity'], '');
    obj.product_feature_photo = Utils.to_str(m['product_feature_photo'], '');
    obj.product_id = Utils.to_str(m['product_id'], '');

    return obj;
  }

  static Future<List<CartItem>> getLocalData({String where = "1"}) async {
    List<CartItem> data = [];
    if (!(await CartItem.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps = await db.query(CartItem.tableName, where: where);

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(CartItem.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<CartItem>> getItems({String where = '1'}) async {
    List<CartItem> data = await getLocalData(where: where);
    data.sort((a, b) => b.id.compareTo(a.id));
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

  delete() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await initTable();

    try {
      await db.delete(tableName, where: 'id = $id');
    } catch (e) {
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }

  toJson() {
    return {
      'id': id,
      'product_name': product_name,
      'product_price_1': product_price_1,
      'product_quantity': product_quantity,
      'product_feature_photo': product_feature_photo,
      'product_id': product_id,
    };
  }

  static Future<bool> initTable() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }

    String sql = "CREATE TABLE  IF NOT EXISTS  ${CartItem.tableName} (  "
        "id INTEGER PRIMARY KEY ,"
        " product_name TEXT,"
        " product_price_1 TEXT,"
        " product_quantity TEXT,"
        " product_feature_photo TEXT,"
        " product_id TEXT"
        ")";
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
    if (!(await CartItem.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(tableName);
  }
}
