import 'package:sqflite/sqflite.dart';

import '../utils/Utilities.dart';
import 'RespondModel.dart';

class ParishModel {
  static String end_point = "parishes";
  static String tableName = "parish";
  int id = 0;
  String name = "";
  String subcounty_id = "";
  String subcounty_text = "";
  String parish_latitude = "";
  String parish_longitude = "";
  String user_id = "";
  String user_text = "";
  String created = "";
  String changed = "";
  String created_at = "";
  String updated_at = "";
  String lat = "";
  String lng = "";

  static fromJson(dynamic m) {
    ParishModel obj = ParishModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.name = Utils.to_str(m['name'], '');
    obj.subcounty_id = Utils.to_str(m['subcounty_id'], '');
    obj.subcounty_text = Utils.to_str(m['subcounty_text'], '');
    obj.parish_latitude = Utils.to_str(m['parish_latitude'], '');
    obj.parish_longitude = Utils.to_str(m['parish_longitude'], '');
    obj.user_id = Utils.to_str(m['user_id'], '');
    obj.user_text = Utils.to_str(m['user_text'], '');
    obj.created = Utils.to_str(m['created'], '');
    obj.changed = Utils.to_str(m['changed'], '');
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.lat = Utils.to_str(m['lat'], '');
    obj.lng = Utils.to_str(m['lng'], '');

    return obj;
  }

  static Future<List<ParishModel>> getLocalData({String where = "1"}) async {
    List<ParishModel> data = [];
    if (!(await ParishModel.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps =
        await db.query(tableName, where: where, orderBy: ' name ASC ');

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(ParishModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<ParishModel>> get_items({String where = '1'}) async {
    List<ParishModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await ParishModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      ParishModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<ParishModel>> getOnlineItems() async {
    List<ParishModel> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get(ParishModel.end_point, {}));

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
        await ParishModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          ParishModel sub = ParishModel.fromJson(x);
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
          print("faied to save to commit BRECASE == ${e.toString()}");
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
      'name': name,
      'subcounty_id': subcounty_id,
      'subcounty_text': subcounty_text,
      'parish_latitude': parish_latitude,
      'parish_longitude': parish_longitude,
      'user_id': user_id,
      'user_text': user_text,
      'created': created,
      'changed': changed,
      'created_at': created_at,
      'updated_at': updated_at,
      'lat': lat,
      'lng': lng,
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
        ",name TEXT"
        ",subcounty_id TEXT"
        ",subcounty_text TEXT"
        ",parish_latitude TEXT"
        ",parish_longitude TEXT"
        ",user_id TEXT"
        ",user_text TEXT"
        ",created TEXT"
        ",changed TEXT"
        ",created_at TEXT"
        ",updated_at TEXT"
        ",lat TEXT"
        ",lng TEXT"
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
    if (!(await ParishModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(ParishModel.tableName);
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
