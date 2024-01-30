import 'package:sqflite/sqflite.dart';

import '../utils/Utilities.dart';
import 'RespondModel.dart';

class ResourceModel {
  static String end_point = "resources";
  static String tableName = "training_resources";
  String id = "0";
  String heading = "";
  String thumbnail = "";
  String status = "";
  String user_id = "";
  String user_text = "";
  String created_at = "";
  String updated_at = "";
  String organisation_id = "";
  String organisation_text = "";
  String training_id = "";
  String training_text = "";
  String type = "";
  String body = "";
  String file = "";
  String photo = "";
  String audio = "";
  String video = "";
  String youtube = "";
  String resource_category_id = "";
  String resource_category_text = "";

  static fromJson(dynamic m) {
    ResourceModel obj = ResourceModel();
    if (m == null) {
      return obj;
    }

    print(m);
    obj.id = Utils.to_str(m['id'], "0");
    obj.heading = Utils.to_str(m['heading'], '');
    obj.thumbnail = Utils.to_str(m['thumbnail'], '');
    obj.status = Utils.to_str(m['status'], '');
    obj.user_id = Utils.to_str(m['user_id'], '');
    obj.user_text = Utils.to_str(m['user_text'], '');
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.organisation_id = Utils.to_str(m['organisation_id'], '');
    obj.organisation_text = Utils.to_str(m['organisation_text'], '');
    obj.training_id = Utils.to_str(m['training_id'], '');
    obj.training_text = Utils.to_str(m['training_text'], '');
    obj.type = Utils.to_str(m['type'], '');
    obj.body = Utils.to_str(m['body'], '');
    obj.file = Utils.to_str(m['file'], '');
    obj.photo = Utils.to_str(m['photo'], '');
    obj.audio = Utils.to_str(m['audio'], '');
    obj.video = Utils.to_str(m['video'], '');
    obj.youtube = Utils.to_str(m['youtube'], '');
    obj.resource_category_id = Utils.to_str(m['resource_category_id'], '');
    obj.resource_category_text = Utils.to_str(m['resource_category_text'], '');

    //obj.photo = '${AppConfig.STORAGE_URL}${obj.photo}';

    //https://unified.m-omulimisa.com/storage/images/1.jpg
    //https://unified.m-omulimisa.com/storage/images/31f64f521a91c5bbd4d653d015bd2d3c.jpg
    print(obj.photo);
    return obj;
  }

  static Future<List<ResourceModel>> getLocalData({String where = "1"}) async {
    List<ResourceModel> data = [];
    if (!(await ResourceModel.initTable())) {
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
      data.add(ResourceModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<ResourceModel>> get_items({String where = '1'}) async {
    List<ResourceModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await ResourceModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      ResourceModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<ResourceModel>> getOnlineItems() async {
    List<ResourceModel> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get(ResourceModel.end_point, {}));

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
        await ResourceModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          ResourceModel sub = ResourceModel.fromJson(x);
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
    print("=========>SAVING ====>$id<======>");
    return {
      'id': id,
      'heading': heading,
      'thumbnail': thumbnail,
      'status': status,
      'user_id': user_id,
      'user_text': user_text,
      'created_at': created_at,
      'updated_at': updated_at,
      'organisation_id': organisation_id,
      'organisation_text': organisation_text,
      'training_id': training_id,
      'training_text': training_text,
      'type': type,
      'body': body,
      'file': file,
      'photo': photo,
      'audio': audio,
      'video': video,
      'youtube': youtube,
      'resource_category_id': resource_category_id,
      'resource_category_text': resource_category_text,
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
        ",heading TEXT"
        ",thumbnail TEXT"
        ",status TEXT"
        ",user_id TEXT"
        ",user_text TEXT"
        ",created_at TEXT"
        ",updated_at TEXT"
        ",organisation_id TEXT"
        ",organisation_text TEXT"
        ",training_id TEXT"
        ",training_text TEXT"
        ",type TEXT"
        ",body TEXT"
        ",file TEXT"
        ",photo TEXT"
        ",audio TEXT"
        ",video TEXT"
        ",youtube TEXT"
        ",resource_category_id TEXT"
        ",resource_category_text TEXT"
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
    if (!(await ResourceModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(ResourceModel.tableName);
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
