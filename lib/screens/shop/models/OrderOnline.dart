import 'package:sqflite/sqflite.dart';

import '../../../models/RespondModel.dart';
import '../../../utils/Utilities.dart';


class OrderOnline {
  static String endPoint = "orders";
  static String tableName = "ordersOnline";

  int id = 0;
  String items = "";
  String created_at = "";
  String order_state = "";
  String amount = "";
  String payment_confirmation = "";
  String description = "";
  String mail = "";
  String customer_name = "";
  String customer_phone_number_1 = "";
  String customer_phone_number_2 = "";
  String customer_address = "";
  String order_total = "";
  String order_details = "";
  String user = "";
  String delivery_district = "";

  static fromJson(dynamic m) {
    OrderOnline obj = OrderOnline();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.items = Utils.to_str(m['items'], '');
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.order_state = Utils.to_str(m['order_state'], '');
    obj.amount = Utils.to_str(m['amount'], '');
    obj.payment_confirmation = Utils.to_str(m['payment_confirmation'], '');
    obj.description = Utils.to_str(m['description'], '');
    obj.mail = Utils.to_str(m['mail'], '');
    obj.customer_name = Utils.to_str(m['customer_name'], '');
    obj.customer_phone_number_1 =
        Utils.to_str(m['customer_phone_number_1'], '');
    obj.customer_phone_number_2 =
        Utils.to_str(m['customer_phone_number_2'], '');
    obj.customer_address = Utils.to_str(m['customer_address'], '');
    obj.order_total = Utils.to_str(m['order_total'], '');
    obj.order_details = Utils.to_str(m['order_details'], '');
    obj.user = Utils.to_str(m['user'], '');
    obj.delivery_district = Utils.to_str(m['delivery_district'], '');

    return obj;
  }

  static Future<List<OrderOnline>> getLocalData({String where = "1"}) async {
    List<OrderOnline> data = [];
    if (!(await OrderOnline.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps = await db.query(OrderOnline.tableName, where: where);

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(OrderOnline.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<OrderOnline>> getItems({String where = '1'}) async {
    List<OrderOnline> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await OrderOnline.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      data = await getLocalData(where: where);
      OrderOnline.getOnlineItems();
    }
    data.sort((a, b) => b.id.compareTo(a.id));
    return data;
  }

  static Future<List<OrderOnline>> getOnlineItems() async {
    List<OrderOnline> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get(OrderOnline.endPoint, {}));

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
        await OrderOnline.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          OrderOnline sub = OrderOnline.fromJson(x);
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
      'items': items,
      'created_at': created_at,
      'order_state': order_state,
      'amount': amount,
      'payment_confirmation': payment_confirmation,
      'description': description,
      'mail': mail,
      'customer_name': customer_name,
      'customer_phone_number_1': customer_phone_number_1,
      'customer_phone_number_2': customer_phone_number_2,
      'customer_address': customer_address,
      'order_total': order_total,
      'order_details': order_details,
      'user': user,
      'delivery_district': delivery_district,
    };
  }

  static Future<bool> initTable() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }

    String sql = "CREATE TABLE  IF NOT EXISTS  ${OrderOnline.tableName} (  "
        "id INTEGER PRIMARY KEY,"
        "items TEXT,"
        "created_at TEXT,"
        "order_state TEXT,"
        "amount TEXT,"
        "payment_confirmation TEXT,"
        "description TEXT,"
        "mail TEXT,"
        "customer_name TEXT,"
        "customer_phone_number_1 TEXT,"
        "customer_phone_number_2 TEXT,"
        "customer_address TEXT,"
        "order_total TEXT,"
        "order_details TEXT,"
        "user TEXT,"
        "delivery_district TEXT)";
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
    if (!(await OrderOnline.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(tableName);
  }
}
