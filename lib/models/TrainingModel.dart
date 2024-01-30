import 'package:sqflite/sqflite.dart';

import 'RespondModel.dart';
import '../utils/Utilities.dart';




class TrainingModel {

  static String end_point = "trainings";
  static String tableName = "trainings";
  String id = "";
  String village_agent_id = "";
  String village_agent_text = "";
  String extension_officer_id = "";
  String extension_officer_text = "";
  String user_id = "";
  String user_text = "";
  String training_topic_id = "";
  String training_topic_text = "";
  String details = "";
  String date = "";
  String time = "";
  String venue = "";
  String location_id = "";
  String location_text = "";
  String latitude = "";
  String longitude = "";
  String status = "";
  String created_at = "";
  String updated_at = "";
  String name = "";
  String file = "";
  String photo = "";
  String video = "";
  String youtube = "";
  String body = "";
  String organisation_id = "";
  String organisation_text = "";
  String subtopic_id = "";
  String subtopic_text = "";


  static fromJson(dynamic m) {
    TrainingModel obj = TrainingModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.to_str(m['id'],'');
    obj.village_agent_id = Utils.to_str(m['village_agent_id'], '');
    obj.village_agent_text = Utils.to_str(m['village_agent_text'], '');
    obj.extension_officer_id = Utils.to_str(m['extension_officer_id'], '');
    obj.extension_officer_text = Utils.to_str(m['extension_officer_text'], '');
    obj.user_id = Utils.to_str(m['user_id'], '');
    obj.user_text = Utils.to_str(m['user_text'], '');
    obj.training_topic_id = Utils.to_str(m['training_topic_id'], '');
    obj.training_topic_text = Utils.to_str(m['training_topic_text'], '');
    obj.details = Utils.to_str(m['details'], '');
    obj.date = Utils.to_str(m['date'], '');
    obj.time = Utils.to_str(m['time'], '');
    obj.venue = Utils.to_str(m['venue'], '');
    obj.location_id = Utils.to_str(m['location_id'], '');
    obj.location_text = Utils.to_str(m['location_text'], '');
    obj.latitude = Utils.to_str(m['latitude'], '');
    obj.longitude = Utils.to_str(m['longitude'], '');
    obj.status = Utils.to_str(m['status'], '');
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.file = Utils.to_str(m['file'], '');
    obj.photo = Utils.to_str(m['photo'], '');
    obj.video = Utils.to_str(m['video'], '');
    obj.youtube = Utils.to_str(m['youtube'], '');
    obj.body = Utils.to_str(m['body'], '');
    obj.organisation_id = Utils.to_str(m['organisation_id'], '');
    obj.organisation_text = Utils.to_str(m['organisation_text'], '');
    obj.subtopic_id = Utils.to_str(m['subtopic_id'], '');
    obj.subtopic_text = Utils.to_str(m['subtopic_text'], '');

    return obj;
  }


  static Future<List<TrainingModel>> getLocalData({String where = "1"}) async {
    List<TrainingModel> data = [];
    if (!(await TrainingModel.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return data;
    }


    List<Map> maps = await db.query(tableName, where: where, orderBy: ' id DESC ');

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(TrainingModel.fromJson(maps[i]));
    });

    return data;
  }


  static Future<List<TrainingModel>> get_items({String where = '1'}) async {
    List<TrainingModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await TrainingModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      TrainingModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<TrainingModel>> getOnlineItems() async {
    List<TrainingModel> data = [];

    RespondModel resp =
    RespondModel(await Utils.http_get(TrainingModel.end_point, {}));

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
        await TrainingModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          TrainingModel sub = TrainingModel.fromJson(x);
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
      'village_agent_id': village_agent_id,
      'village_agent_text': village_agent_text,
      'extension_officer_id': extension_officer_id,
      'extension_officer_text': extension_officer_text,
      'user_id': user_id,
      'user_text': user_text,
      'training_topic_id': training_topic_id,
      'training_topic_text': training_topic_text,
      'details': details,
      'date': date,
      'time': time,
      'venue': venue,
      'location_id': location_id,
      'location_text': location_text,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'name': name,
      'file': file,
      'photo': photo,
      'video': video,
      'youtube': youtube,
      'body': body,
      'organisation_id': organisation_id,
      'organisation_text': organisation_text,
      'subtopic_id': subtopic_id,
      'subtopic_text': subtopic_text,

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
        ",village_agent_id TEXT"
        ",village_agent_text TEXT"
        ",extension_officer_id TEXT"
        ",extension_officer_text TEXT"
        ",user_id TEXT"
        ",user_text TEXT"
        ",training_topic_id TEXT"
        ",training_topic_text TEXT"
        ",details TEXT"
        ",date TEXT"
        ",time TEXT"
        ",venue TEXT"
        ",location_id TEXT"
        ",location_text TEXT"
        ",latitude TEXT"
        ",longitude TEXT"
        ",status TEXT"
        ",created_at TEXT"
        ",updated_at TEXT"
        ",name TEXT"
        ",file TEXT"
        ",photo TEXT"
        ",video TEXT"
        ",youtube TEXT"
        ",body TEXT"
        ",organisation_id TEXT"
        ",organisation_text TEXT"
        ",subtopic_id TEXT"
        ",subtopic_text TEXT"
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
    if (!(await TrainingModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(TrainingModel.tableName);
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


