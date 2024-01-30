import 'package:sqflite/sqflite.dart';

import '../utils/Utilities.dart';
import 'RespondModel.dart';

class FarmerQuestion {
  static String end_point = "farmer-questions";
  static String tableName = "farmer_questions";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String user_id = "";
  String user_text = "";
  String district_model_id = "";
  String district_model_text = "";
  String body = "";
  String category = "";
  String phone = "";
  String sent_via = "";
  String answered = "";
  String audio = "";
  String photo = "";
  String video = "";
  String document = "";
  String views = "";
  String user_photo = "";
  String district_text = "";
  String answers_count = "";

  static fromJson(dynamic m) {
    FarmerQuestion obj = FarmerQuestion();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.user_id = Utils.to_str(m['user_id'], '');
    obj.user_text = Utils.to_str(m['user_text'], '');
    obj.district_model_id = Utils.to_str(m['district_model_id'], '');
    obj.district_model_text = Utils.to_str(m['district_model_text'], '');
    obj.body = Utils.to_str(m['body'], '');
    obj.category = Utils.to_str(m['category'], '');
    obj.phone = Utils.to_str(m['phone'], '');
    obj.sent_via = Utils.to_str(m['sent_via'], '');
    obj.answered = Utils.to_str(m['answered'], '');
    obj.audio = Utils.to_str(m['audio'], '');
    obj.photo = Utils.to_str(m['photo'], '');
    obj.video = Utils.to_str(m['video'], '');
    obj.document = Utils.to_str(m['document'], '');
    obj.views = Utils.to_str(m['views'], '');
    obj.user_photo = Utils.to_str(m['user_photo'], '');
    obj.district_text = Utils.to_str(m['district_text'], '');
    obj.answers_count = Utils.to_str(m['answers_count'], '');


    return obj;
  }

  static Future<List<FarmerQuestion>> getLocalData({String where = "1"}) async {
    List<FarmerQuestion> data = [];
    if (!(await FarmerQuestion.initTable())) {
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
      data.add(FarmerQuestion.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<FarmerQuestion>> get_items({String where = '1'}) async {
    List<FarmerQuestion> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await FarmerQuestion.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      FarmerQuestion.getOnlineItems();
    }
    return data;
  }

  static Future<List<FarmerQuestion>> getOnlineItems() async {
    List<FarmerQuestion> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get(FarmerQuestion.end_point, {}));

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
        await FarmerQuestion.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          FarmerQuestion sub = FarmerQuestion.fromJson(x);
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
      'created_at': created_at,
      'updated_at': updated_at,
      'user_id': user_id,
      'user_text': user_text,
      'district_model_id': district_model_id,
      'district_model_text': district_model_text,
      'body': body,
      'category': category,
      'phone': phone,
      'sent_via': sent_via,
      'answered': answered,
      'audio': audio,
      'photo': photo,
      'video': video,
      'document': document,
      'views': views,
      'district_text': district_text,
      'answers_count': answers_count,
      'user_photo': user_photo,
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
        ",user_id TEXT"
        ",user_text TEXT"
        ",district_model_id TEXT"
        ",district_model_text TEXT"
        ",body TEXT"
        ",category TEXT"
        ",phone TEXT"
        ",sent_via TEXT"
        ",answered TEXT"
        ",audio TEXT"
        ",photo TEXT"
        ",video TEXT"
        ",document TEXT"
        ",views TEXT"
        ",user_photo TEXT"
        ",district_text TEXT"
        ",answers_count TEXT"
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
    if (!(await FarmerQuestion.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(FarmerQuestion.tableName);
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
