import 'package:sqflite/sqflite.dart';

import '../utils/Utilities.dart';
import 'RespondModel.dart';

class DistrictModel {
  static String end_point = "districts";
  static String tableName = "district";
  String id = '';
  String name = "";
  String district_status = "";
  String region_id = "";
  String region_text = "";
  String subregion_id = "";
  String subregion_text = "";
  String map_id = "";
  String map_text = "";
  String zone_id = "";
  String zone_text = "";
  String land_type_id = "";
  String land_type_text = "";
  String user_id = "";
  String user_text = "";
  String created = "";
  String changed = "";

  static fromJson(dynamic m) {
    DistrictModel obj =  DistrictModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.to_str(m['id'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.district_status = Utils.to_str(m['district_status'], '');
    obj.region_id = Utils.to_str(m['region_id'], '');
    obj.region_text = Utils.to_str(m['region_text'], '');
    obj.subregion_id = Utils.to_str(m['subregion_id'], '');
    obj.subregion_text = Utils.to_str(m['subregion_text'], '');
    obj.map_id = Utils.to_str(m['map_id'], '');
    obj.map_text = Utils.to_str(m['map_text'], '');
    obj.zone_id = Utils.to_str(m['zone_id'], '');
    obj.zone_text = Utils.to_str(m['zone_text'], '');
    obj.land_type_id = Utils.to_str(m['land_type_id'], '');
    obj.land_type_text = Utils.to_str(m['land_type_text'], '');
    obj.user_id = Utils.to_str(m['user_id'], '');
    obj.user_text = Utils.to_str(m['user_text'], '');
    obj.created = Utils.to_str(m['created'], '');
    obj.changed = Utils.to_str(m['changed'], '');

    return obj;
  }

  static Future<List<DistrictModel>> getLocalData({String where = "1"}) async {
    List<DistrictModel> data = [];
    if (!(await DistrictModel.initTable())) {
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
      data.add(DistrictModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<DistrictModel>> get_items({String where = '1'}) async {
    List<DistrictModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await DistrictModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      DistrictModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<DistrictModel>> getOnlineItems() async {
    List<DistrictModel> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get(DistrictModel.end_point, {}));

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
        await DistrictModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          DistrictModel sub = DistrictModel.fromJson(x);
          try {
            if (sub.id.isEmpty) {
              continue;
            }
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
      'district_status': district_status,
      'region_id': region_id,
      'region_text': region_text,
      'subregion_id': subregion_id,
      'subregion_text': subregion_text,
      'map_id': map_id,
      'map_text': map_text,
      'zone_id': zone_id,
      'zone_text': zone_text,
      'land_type_id': land_type_id,
      'land_type_text': land_type_text,
      'user_id': user_id,
      'user_text': user_text,
      'created': created,
      'changed': changed,
    };
  }

  static Future initTable() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }

    String sql = " CREATE TABLE IF NOT EXISTS "
        "$tableName ("
        "id TEXT PRIMARY KEY"
        ",name TEXT"
        ",district_status TEXT"
        ",region_id TEXT"
        ",region_text TEXT"
        ",subregion_id TEXT"
        ",subregion_text TEXT"
        ",map_id TEXT"
        ",map_text TEXT"
        ",zone_id TEXT"
        ",zone_text TEXT"
        ",land_type_id TEXT"
        ",land_type_text TEXT"
        ",user_id TEXT"
        ",user_text TEXT"
        ",created TEXT"
        ",changed TEXT"
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
    if (!(await DistrictModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(DistrictModel.tableName);
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
