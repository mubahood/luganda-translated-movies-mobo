import 'package:sqflite/sqflite.dart';

import 'RespondModel.dart';
import '../utils/Utilities.dart';



class SubcountyModel {

  static String end_point = "subcounties";
  static String tableName = "subcounty";
  int id = 0;
  String name = "";
  String county_id = "";
  String county_text = "";
  String user_id = "";
  String user_text = "";
  String created = "";
  String changed = "";
  String district_id = "";


  static fromJson(dynamic m) {
    SubcountyModel obj = SubcountyModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.name = Utils.to_str(m['name'],'');
    obj.county_id = Utils.to_str(m['county_id'],'');
    obj.county_text = Utils.to_str(m['county_text'],'');
    obj.user_id = Utils.to_str(m['user_id'],'');
    obj.user_text = Utils.to_str(m['user_text'],'');
    obj.created = Utils.to_str(m['created'],'');
    obj.changed = Utils.to_str(m['changed'],'');
    obj.district_id = Utils.to_str(m['district_id'],'');

    return obj;
  }




  static Future<List<SubcountyModel>> getLocalData({String where = "1"}) async {

    List<SubcountyModel> data = [];
    if (!(await SubcountyModel.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return data;
    }


    List<Map> maps = await db.query(tableName, where: where, orderBy: ' name ASC ');

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(SubcountyModel.fromJson(maps[i]));
    });

    return data;

  }


  static Future<List<SubcountyModel>> get_items({String where = '1'}) async {
    List<SubcountyModel> data = await getLocalData(where: where);
    if (data.isEmpty ) {
      await SubcountyModel.getOnlineItems();
      data = await getLocalData(where: where);
    }else{
      SubcountyModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<SubcountyModel>> getOnlineItems() async {
    List<SubcountyModel> data = [];

    RespondModel resp =
    RespondModel(await Utils.http_get(SubcountyModel.end_point, {}));

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
        await SubcountyModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          SubcountyModel sub = SubcountyModel.fromJson(x);
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
      'id' : id,
      'name' : name,
      'county_id' : county_id,
      'county_text' : county_text,
      'user_id' : user_id,
      'user_text' : user_text,
      'created' : created,
      'district_id' : district_id,
      'changed' : changed,

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
        ",county_id TEXT"
        ",county_text TEXT"
        ",district_id TEXT"
        ",user_id TEXT"
        ",user_text TEXT"
        ",created TEXT"
        ",changed TEXT"

        ")";

    try {
      //await db.execute("DROP TABLE ${tableName}");
      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table because ${e . toString()}');

      return false;
    }

    return true;
  }


  static deleteAll() async {
    if (!(await SubcountyModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(SubcountyModel.tableName);
  }





  delete() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await initTable();

    try {
      await db.delete(
          tableName,
          where: 'id = $id'
      );
    } catch (e) {
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }


}
