import 'package:sqflite/sqflite.dart';

import '../utils/Utilities.dart';
import 'RespondModel.dart';

class FarmerQuestionAnswer {
  static String end_point = "farmer_question_answers";
  static String tableName = "farmer_question_answers";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String user_id = "";
  String user_text = "";
  String user_photo = "";
  String farmer_question_id = "";
  String farmer_question_text = "";
  String verified = "";
  String body = "";
  String audio = "";
  String photo = "";
  String video = "";
  String document = "";

  static fromJson(dynamic m) {
    FarmerQuestionAnswer obj = FarmerQuestionAnswer();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.user_id = Utils.to_str(m['user_id'], '');
    obj.user_text = Utils.to_str(m['user_text'], '');
    obj.farmer_question_id = Utils.to_str(m['farmer_question_id'], '');
    obj.farmer_question_text = Utils.to_str(m['farmer_question_text'], '');
    obj.verified = Utils.to_str(m['verified'], '');
    obj.body = Utils.to_str(m['body'], '');
    obj.audio = Utils.to_str(m['audio'], '');
    obj.photo = Utils.to_str(m['photo'], '');
    obj.video = Utils.to_str(m['video'], '');
    obj.document = Utils.to_str(m['document'], '');
    obj.user_photo = Utils.to_str(m['user_photo'], '');

    return obj;
  }

  static Future<List<FarmerQuestionAnswer>> getLocalData(
      {String where = "1"}) async {
    List<FarmerQuestionAnswer> data = [];
    if (!(await FarmerQuestionAnswer.initTable())) {
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
      data.add(FarmerQuestionAnswer.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<FarmerQuestionAnswer>> get_items(
      {String where = '1'}) async {
    List<FarmerQuestionAnswer> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await FarmerQuestionAnswer.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      FarmerQuestionAnswer.getOnlineItems();
    }
    return data;
  }

  static Future<List<FarmerQuestionAnswer>> getOnlineItems() async {
    List<FarmerQuestionAnswer> data = [];

    RespondModel resp = RespondModel(
        await Utils.http_get(FarmerQuestionAnswer.end_point, {}));

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
        await FarmerQuestionAnswer.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          FarmerQuestionAnswer sub = FarmerQuestionAnswer.fromJson(x);
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
      'farmer_question_id': farmer_question_id,
      'farmer_question_text': farmer_question_text,
      'verified': verified,
      'body': body,
      'audio': audio,
      'photo': photo,
      'video': video,
      'document': document,
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
        ",farmer_question_id TEXT"
        ",farmer_question_text TEXT"
        ",verified TEXT"
        ",body TEXT"
        ",audio TEXT"
        ",photo TEXT"
        ",video TEXT"
        ",document TEXT"
        ",user_photo TEXT"
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
    if (!(await FarmerQuestionAnswer.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(FarmerQuestionAnswer.tableName);
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
