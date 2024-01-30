import 'package:sqflite/sqflite.dart';

import '../utils/Utilities.dart';
import 'DynamicModel.dart';
import 'RespondModel.dart';

class GardenModel {
  static String end_point = "gardens";
  static String tableName = "garden_models";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String user_id = "";
  String user_text = "";
  String district_id = "";
  String district_text = "";
  String subcounty_id = "";
  String subcounty_text = "";
  String parish_id = "";
  String parish_text = "";
  String crop_id = "";
  String crop_text = "";
  String village = "";
  String crop_planted = "";
  String name = "";
  String details = "";
  String size = "";
  String status = "";
  String soil_type = "";
  String soil_ph = "";
  String soil_texture = "";
  String soil_depth = "";
  String soil_moisture = "";
  String photos = "";
  String coordinates = "";

  List<DynamicModel> coordicates = [];
  List<String> attendanceListPhotos = [];
  List<String> attendanceListPhotosUploaded = [];

  static fromJson(dynamic m) {
    GardenModel obj = GardenModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.user_id = Utils.to_str(m['user_id'], '');
    obj.user_text = Utils.to_str(m['user_text'], '');
    obj.district_id = Utils.to_str(m['district_id'], '');
    obj.district_text = Utils.to_str(m['district_text'], '');
    obj.subcounty_id = Utils.to_str(m['subcounty_id'], '');
    obj.subcounty_text = Utils.to_str(m['subcounty_text'], '');
    obj.parish_id = Utils.to_str(m['parish_id'], '');
    obj.parish_text = Utils.to_str(m['parish_text'], '');
    obj.crop_id = Utils.to_str(m['crop_id'], '');
    obj.crop_text = Utils.to_str(m['crop_text'], '');
    obj.village = Utils.to_str(m['village'], '');
    obj.crop_planted = Utils.to_str(m['crop_planted'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.details = Utils.to_str(m['details'], '');
    obj.size = Utils.to_str(m['size'], '');
    obj.status = Utils.to_str(m['status'], '');
    obj.soil_type = Utils.to_str(m['soil_type'], '');
    obj.soil_ph = Utils.to_str(m['soil_ph'], '');
    obj.soil_texture = Utils.to_str(m['soil_texture'], '');
    obj.soil_depth = Utils.to_str(m['soil_depth'], '');
    obj.soil_moisture = Utils.to_str(m['soil_moisture'], '');
    obj.photos = Utils.to_str(m['photos'], '');
    obj.coordinates = Utils.to_str(m['coordinates'], '');

    return obj;
  }

  static Future<List<GardenModel>> getLocalData({String where = "1"}) async {
    List<GardenModel> data = [];
    if (!(await GardenModel.initTable())) {
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
      data.add(GardenModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<GardenModel>> get_items({String where = '1'}) async {
    List<GardenModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await GardenModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      GardenModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<GardenModel>> getOnlineItems() async {
    List<GardenModel> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get(GardenModel.end_point, {}));

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
        await GardenModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          GardenModel sub = GardenModel.fromJson(x);
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
      'district_id': district_id,
      'district_text': district_text,
      'subcounty_id': subcounty_id,
      'subcounty_text': subcounty_text,
      'parish_id': parish_id,
      'parish_text': parish_text,
      'crop_id': crop_id,
      'crop_text': crop_text,
      'village': village,
      'crop_planted': crop_planted,
      'name': name,
      'details': details,
      'size': size,
      'status': status,
      'soil_type': soil_type,
      'soil_ph': soil_ph,
      'soil_texture': soil_texture,
      'soil_depth': soil_depth,
      'soil_moisture': soil_moisture,
      'photos': photos,
      'coordinates': coordinates,
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
        ",district_id TEXT"
        ",district_text TEXT"
        ",subcounty_id TEXT"
        ",subcounty_text TEXT"
        ",parish_id TEXT"
        ",parish_text TEXT"
        ",crop_id TEXT"
        ",crop_text TEXT"
        ",village TEXT"
        ",crop_planted TEXT"
        ",name TEXT"
        ",details TEXT"
        ",size TEXT"
        ",status TEXT"
        ",soil_type TEXT"
        ",soil_ph TEXT"
        ",soil_texture TEXT"
        ",soil_depth TEXT"
        ",soil_moisture TEXT"
        ",photos TEXT"
        ",coordinates TEXT"
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
    if (!(await GardenModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(GardenModel.tableName);
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

  hasBasicInformation() {
    return "";
  }

  List<String> getPhotos() {
    List<String> photos = [];
    if (this.photos.isNotEmpty) {
      photos = this.photos.split(',');
    }
    return photos;
  }

  List<String> coordinatesList() {
    List<String> coordinates = [];
    if (this.coordinates.isNotEmpty) {
      coordinates = this.coordinates.split(',');
    }
    return coordinates;
  }
}
