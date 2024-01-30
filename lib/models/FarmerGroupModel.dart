import 'package:sqflite/sqflite.dart';

import '../utils/Utilities.dart';
import 'RespondModel.dart';

class FarmerGroupModel {
  static String end_point = "farmer-groups";
  static String tableName = "farmer_groups";
  int id = 0;
  String name = "";
  String country_id = "";
  String country_text = "";
  String organisation_id = "";
  String organisation_text = "";
  String code = "";
  String address = "";
  String group_leader = "";
  String group_leader_contact = "";
  String establishment_year = "";
  String registration_year = "";
  String meeting_venue = "";
  String meeting_days = "";
  String meeting_time = "";
  String meeting_frequency = "";
  String location_id = "";
  String location_text = "";
  String last_cycle_savings = "";
  String registration_certificate = "";
  String latitude = "";
  String longitude = "";
  String status = "";
  String photo = "";
  String id_photo_front = "";
  String id_photo_back = "";
  String created_by_user_id = "";
  String created_by_user_text = "";
  String created_by_agent_id = "";
  String created_by_agent_text = "";
  String agent_id = "";
  String agent_text = "";
  String created_at = "";
  String updated_at = "";

  static fromJson(dynamic m) {
    FarmerGroupModel obj = FarmerGroupModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.name = Utils.to_str(m['name'], '');
    obj.country_id = Utils.to_str(m['country_id'], '');
    obj.country_text = Utils.to_str(m['country_text'], '');
    obj.organisation_id = Utils.to_str(m['organisation_id'], '');
    obj.organisation_text = Utils.to_str(m['organisation_text'], '');
    obj.code = Utils.to_str(m['code'], '');
    obj.address = Utils.to_str(m['address'], '');
    obj.group_leader = Utils.to_str(m['group_leader'], '');
    obj.group_leader_contact = Utils.to_str(m['group_leader_contact'], '');
    obj.establishment_year = Utils.to_str(m['establishment_year'], '');
    obj.registration_year = Utils.to_str(m['registration_year'], '');
    obj.meeting_venue = Utils.to_str(m['meeting_venue'], '');
    obj.meeting_days = Utils.to_str(m['meeting_days'], '');
    obj.meeting_time = Utils.to_str(m['meeting_time'], '');
    obj.meeting_frequency = Utils.to_str(m['meeting_frequency'], '');
    obj.location_id = Utils.to_str(m['location_id'], '');
    obj.location_text = Utils.to_str(m['location_text'], '');
    obj.last_cycle_savings = Utils.to_str(m['last_cycle_savings'], '');
    obj.registration_certificate =
        Utils.to_str(m['registration_certificate'], '');
    obj.latitude = Utils.to_str(m['latitude'], '');
    obj.longitude = Utils.to_str(m['longitude'], '');
    obj.status = Utils.to_str(m['status'], '');
    obj.photo = Utils.to_str(m['photo'], '');
    obj.id_photo_front = Utils.to_str(m['id_photo_front'], '');
    obj.id_photo_back = Utils.to_str(m['id_photo_back'], '');
    obj.created_by_user_id = Utils.to_str(m['created_by_user_id'], '');
    obj.created_by_user_text = Utils.to_str(m['created_by_user_text'], '');
    obj.created_by_agent_id = Utils.to_str(m['created_by_agent_id'], '');
    obj.created_by_agent_text = Utils.to_str(m['created_by_agent_text'], '');
    obj.agent_id = Utils.to_str(m['agent_id'], '');
    obj.agent_text = Utils.to_str(m['agent_text'], '');
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');

    return obj;
  }

  static Future<List<FarmerGroupModel>> getLocalData(
      {String where = "1"}) async {
    List<FarmerGroupModel> data = [];
    if (!(await FarmerGroupModel.initTable())) {
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
      data.add(FarmerGroupModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<FarmerGroupModel>> get_items({String where = '1'}) async {
    List<FarmerGroupModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await FarmerGroupModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      FarmerGroupModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<FarmerGroupModel>> getOnlineItems() async {
    List<FarmerGroupModel> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get(FarmerGroupModel.end_point, {}));

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
        await FarmerGroupModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          FarmerGroupModel sub = FarmerGroupModel.fromJson(x);
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
      'country_id': country_id,
      'country_text': country_text,
      'organisation_id': organisation_id,
      'organisation_text': organisation_text,
      'code': code,
      'address': address,
      'group_leader': group_leader,
      'group_leader_contact': group_leader_contact,
      'establishment_year': establishment_year,
      'registration_year': registration_year,
      'meeting_venue': meeting_venue,
      'meeting_days': meeting_days,
      'meeting_time': meeting_time,
      'meeting_frequency': meeting_frequency,
      'location_id': location_id,
      'location_text': location_text,
      'last_cycle_savings': last_cycle_savings,
      'registration_certificate': registration_certificate,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'photo': photo,
      'id_photo_front': id_photo_front,
      'id_photo_back': id_photo_back,
      'created_by_user_id': created_by_user_id,
      'created_by_user_text': created_by_user_text,
      'created_by_agent_id': created_by_agent_id,
      'created_by_agent_text': created_by_agent_text,
      'agent_id': agent_id,
      'agent_text': agent_text,
      'created_at': created_at,
      'updated_at': updated_at,
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
        ",country_id TEXT"
        ",country_text TEXT"
        ",organisation_id TEXT"
        ",organisation_text TEXT"
        ",code TEXT"
        ",address TEXT"
        ",group_leader TEXT"
        ",group_leader_contact TEXT"
        ",establishment_year TEXT"
        ",registration_year TEXT"
        ",meeting_venue TEXT"
        ",meeting_days TEXT"
        ",meeting_time TEXT"
        ",meeting_frequency TEXT"
        ",location_id TEXT"
        ",location_text TEXT"
        ",last_cycle_savings TEXT"
        ",registration_certificate TEXT"
        ",latitude TEXT"
        ",longitude TEXT"
        ",status TEXT"
        ",photo TEXT"
        ",id_photo_front TEXT"
        ",id_photo_back TEXT"
        ",created_by_user_id TEXT"
        ",created_by_user_text TEXT"
        ",created_by_agent_id TEXT"
        ",created_by_agent_text TEXT"
        ",agent_id TEXT"
        ",agent_text TEXT"
        ",created_at TEXT"
        ",updated_at TEXT"
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
    if (!(await FarmerGroupModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(FarmerGroupModel.tableName);
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
