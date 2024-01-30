import 'package:sqflite/sqflite.dart';

import '../utils/Utilities.dart';
import 'RespondModel.dart';

class ResourceCategory {
  static String end_point = "resources-categories";
  static String tableName = "resource_categories";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String name = "";
  String thumbnail = "";
  String details = "";
  String count = "";

  static fromJson(dynamic m) {
    ResourceCategory obj = ResourceCategory();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.thumbnail = Utils.to_str(m['thumbnail'], '');
    obj.details = Utils.to_str(m['details'], '');
    obj.count = Utils.to_str(m['count'], '');

    return obj;
  }

  static Future<List<ResourceCategory>> getLocalData(
      {String where = "1"}) async {
    List<ResourceCategory> data = [];
    if (!(await ResourceCategory.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps =
        await db.query(tableName, where: where, orderBy: ' id DESC ');

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(ResourceCategory.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<ResourceCategory>> get_items({String where = '1'}) async {
    List<ResourceCategory> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await ResourceCategory.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      ResourceCategory.getOnlineItems();
    }
    return data;
  }

  static Future<List<ResourceCategory>> getOnlineItems() async {
    List<ResourceCategory> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get(ResourceCategory.end_point, {}));

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
        await ResourceCategory.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          ResourceCategory sub = ResourceCategory.fromJson(x);
          try {
            batch.insert(tableName, sub.toJson(),
                conflictAlgorithm: ConflictAlgorithm.replace);
          } catch (e) {
            print("faied to save becaus ${e.toString()}");
          }
        }

        try {
          await batch.commit(continueOnError: true);
        } catch (e) {
          print("faied to save to commit BRECASE ==> ${e.toString()}");
        }
      });
    }

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
      'created_at': created_at,
      'updated_at': updated_at,
      'name': name,
      'thumbnail': thumbnail,
      'count': thumbnail,
      'details': details,
    };
  }

  static Future initTable() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }

    String sql = " CREATE TABLE IF NOT EXISTS "
        "$tableName ("
        "id INTEGER PRIMARY KEY"
        ",created_at TEXT"
        ",updated_at TEXT"
        ",name TEXT"
        ",thumbnail TEXT"
        ",details TEXT"
        ",count TEXT"
        ")";

    try {
      //await db.execute("DROP TABLE ${tableName}");
      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table because ${e.toString()}');

      return false;
    }

    return true;
  }

  static deleteAll() async {
    if (!(await ResourceCategory.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(ResourceCategory.tableName);
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
}
