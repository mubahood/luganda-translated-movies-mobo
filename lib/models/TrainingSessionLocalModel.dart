import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../utils/Utilities.dart';
import 'DynamicModel.dart';

class TrainingSessionLocalModel {
  static String tableName = "training_sessions";
  int id = DateTime.now().millisecondsSinceEpoch ~/ 100;
  String created_at = "";
  String updated_at = "";
  String organisation_id = "";
  String organisation_text = "";
  String training_id = "";
  String training_text = "";
  String location_id = "";
  String location_text = "";
  String conducted_by = "";
  String session_date = "";
  String start_date = "";
  String end_date = "";
  String details = "";
  String topics_covered = "";
  String attendance_list_pictures = "";
  String members_pictures = "";
  String gps_latitude = "";
  String gps_longitude = "";
  String farmer_group_id = "";
  String farmer_group_text = "";

  String participants_list_ids = "";
  String participants_list_text = "";
  String attendants_list_photos = "";
  String participants_photos = "";
  String other_data = "";

  List<DynamicModel> participants_list = [];
  List<String> attendanceListPhotos = [];
  List<String> attendanceListPhotosUploaded = [];

  bool hasBasicInformation() {
    return location_id.isNotEmpty &&
        session_date.isNotEmpty &&
        start_date.isNotEmpty;
  }

  static fromJson(dynamic m) {
    TrainingSessionLocalModel obj = TrainingSessionLocalModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.organisation_id = Utils.to_str(m['organisation_id'], '');
    obj.organisation_text = Utils.to_str(m['organisation_text'], '');
    obj.training_id = Utils.to_str(m['training_id'], '');
    obj.training_text = Utils.to_str(m['training_text'], '');
    obj.location_id = Utils.to_str(m['location_id'], '');
    obj.location_text = Utils.to_str(m['location_text'], '');
    obj.conducted_by = Utils.to_str(m['conducted_by'], '');
    obj.session_date = Utils.to_str(m['session_date'], '');
    obj.start_date = Utils.to_str(m['start_date'], '');
    obj.end_date = Utils.to_str(m['end_date'], '');
    obj.details = Utils.to_str(m['details'], '');
    obj.topics_covered = Utils.to_str(m['topics_covered'], '');
    obj.attendance_list_pictures =
        Utils.to_str(m['attendance_list_pictures'], '');
    obj.members_pictures = Utils.to_str(m['members_pictures'], '');
    obj.gps_latitude = Utils.to_str(m['gps_latitude'], '');
    obj.gps_longitude = Utils.to_str(m['gps_longitude'], '');
    obj.farmer_group_id = Utils.to_str(m['farmer_group_id'], '');
    obj.farmer_group_text = Utils.to_str(m['farmer_group_text'], '');

    obj.participants_list_ids = Utils.to_str(m['participants_list_ids'], '');
    obj.participants_list_text = Utils.to_str(m['participants_list_text'], '');
    obj.attendants_list_photos = Utils.to_str(m['attendants_list_photos'], '');
    obj.participants_photos = Utils.to_str(m['participants_photos'], '');
    obj.other_data = Utils.to_str(m['other_data'], '');

    return obj;
  }

  static Future<List<TrainingSessionLocalModel>> getLocalData(
      {String where = "1"}) async {
    List<TrainingSessionLocalModel> data = [];
    if (!(await TrainingSessionLocalModel.initTable())) {
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
      data.add(TrainingSessionLocalModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<TrainingSessionLocalModel>> get_items(
      {String where = '1'}) async {
    List<TrainingSessionLocalModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      data = await getLocalData(where: where);
    } else {}
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
    List<String> membersIds = [];
    for (var element in participants_list) {
      membersIds.add(element.id);
    }

    return {
      'id': id,
      'created_at': created_at,
      'updated_at': updated_at,
      'organisation_id': organisation_id,
      'organisation_text': organisation_text,
      'training_id': training_id,
      'training_text': training_text,
      'location_id': location_id,
      'location_text': location_text,
      'conducted_by': conducted_by,
      'session_date': session_date,
      'start_date': start_date,
      'end_date': end_date,
      'details': details,
      'topics_covered': topics_covered,
      'attendance_list_pictures': attendance_list_pictures,
      'members_pictures': members_pictures,
      'gps_latitude': gps_latitude,
      'gps_longitude': gps_longitude,
      'farmer_group_id': farmer_group_id,
      'farmer_group_text': farmer_group_text,
      'participants_list_ids': participants_list_ids,
      'participants_list_text': participants_list_text,
      'attendants_list_photos': attendants_list_photos,
      'participants_photos': participants_photos,
      'other_data': other_data,
      'members_ids': jsonEncode(membersIds),
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
        ",organisation_id TEXT"
        ",organisation_text TEXT"
        ",training_id TEXT"
        ",training_text TEXT"
        ",location_id TEXT"
        ",location_text TEXT"
        ",conducted_by TEXT"
        ",session_date TEXT"
        ",start_date TEXT"
        ",end_date TEXT"
        ",details TEXT"
        ",topics_covered TEXT"
        ",attendance_list_pictures TEXT"
        ",members_pictures TEXT"
        ",gps_latitude TEXT"
        ",gps_longitude TEXT"
        ",farmer_group_id TEXT"
        ",farmer_group_text TEXT"
        ",participants_list_ids TEXT"
        ",participants_list_text TEXT"
        ",attendants_list_photos TEXT"
        ",participants_photos TEXT"
        ",other_data TEXT"
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
    if (!(await TrainingSessionLocalModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(TrainingSessionLocalModel.tableName);
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
