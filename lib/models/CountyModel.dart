// /*
// import 'package:sqflite/sqflite.dart';
//
// import 'RespondModel.dart';
// import '../utils/Utilities.dart';
//
//
// import 'RespondModel.dart';
//
// class CountyModel {
//
//   static String end_point = "counties";
//   static String tableName = "county";
//   int id = 0;
//   String name = "";
//   String district_id = "";
//   String district_text = "";
//   String municipality = "";
//   String user_id = "";
//   String user_text = "";
//   String created = "";
//   String changed = "";
// static
//
//   static fromJson(dynamic m) {
//     CountyModel obj = new CountyModel();
//     if (m == null) {
//       return obj;
//     }
//
//     obj.id = Utils.int_parse(m['id']);
//     obj.name = Utils.to_str(m['name'],'');
//     obj.district_id = Utils.to_str(m['district_id'],'');
//     obj.district_text = Utils.to_str(m['district_text'],'');
//     obj.municipality = Utils.to_str(m['municipality'],'');
//     obj.user_id = Utils.to_str(m['user_id'],'');
//     obj.user_text = Utils.to_str(m['user_text'],'');
//     obj.created = Utils.to_str(m['created'],'');
//     obj.changed = Utils.to_str(m['changed'],'');
//
//     return obj;
//   }
//
//
//
//
//   static Future<List<CountyModel>> getLocalData({String where = "1"}) async {
//
//     List<CountyModel> data = [];
//     if (!(await CountyModel.initTable())) {
//       Utils.toast("Failed to init dynamic store.");
//       return data;
//     }
//
//     Database db = await Utils.getDb();
//     if (!db.isOpen) {
//       return data;
//     }
//
//
//     List<Map> maps = await db.query(tableName, where: where, orderBy: ' id DESC ');
//
//     if (maps.isEmpty) {
//       return data;
//     }
//     List.generate(maps.length, (i) {
//       data.add(CountyModel.fromJson(maps[i]));
//     });
//
//     return data;
//
//   }
//
//
//   static Future<List<CountyModel>> get_items({String where = '1'}) async {
//     List<CountyModel> data = await getLocalData(where: where);
//     if (data.isEmpty ) {
//       await CountyModel.getOnlineItems();
//       data = await getLocalData(where: where);
//     }else{
//       CountyModel.getOnlineItems();
//     }
//     return data;
//   }
//
//   static Future<List<CountyModel>> getOnlineItems() async {
//     List<CountyModel> data = [];
//
//     RespondModel resp =
//     RespondModel(await Utils.http_get('${CountyModel.end_point}', {}));
//
//     if (resp.code != 1) {
//       return [];
//     }
//
//     Database db = await Utils.getDb();
//     if (!db.isOpen) {
//       Utils.toast("Failed to init local store.");
//       return [];
//     }
//
//     if (resp.data.runtimeType.toString().contains('List')) {
//       if (await Utils.is_connected()) {
//         await CountyModel.deleteAll();
//       }
//
//       await db.transaction((txn) async {
//         var batch = txn.batch();
//
//         for (var x in resp.data) {
//           CountyModel sub = CountyModel.fromJson(x);
//           try {
//             batch.insert(tableName, sub.toJson(),
//                 conflictAlgorithm: ConflictAlgorithm.replace);
//           } catch (e) {
//             print("faied to save becaus ${e.toString()}");
//           }
//         }
//
//         try {
//           await batch.commit(continueOnError: true);
//         } catch (e) {
//           print("faied to save to commit BRECASE == ${e.toString()}");
//         }
//       });
//     }
//
//
//     return data;
//   }
//
//   save() async {
//     Database db = await Utils.getDb();
//     if (!db.isOpen) {
//       Utils.toast("Failed to init local store.");
//       return;
//     }
//
//     await initTable();
//
//     try {
//       await db.insert(
//         tableName,
//         toJson(),
//         conflictAlgorithm: ConflictAlgorithm.replace,
//       );
//     } catch (e) {
//       Utils.toast("Failed to save student because ${e.toString()}");
//     }
//   }
//
//   toJson() {
//     return {
//       'id' : id,
//       'name' : name,
//       'district_id' : district_id,
//       'district_text' : district_text,
//       'municipality' : municipality,
//       'user_id' : user_id,
//       'user_text' : user_text,
//       'created' : created,
//       'changed' : changed,
//
//     };
//   }
//
//
//
//
//
//   static Future initTable() async {
//     Database db = await Utils.getDb();
//     if (!db.isOpen) {
//       return false;
//     }
//
//     String sql = " CREATE TABLE IF NOT EXISTS "
//         "$tableName ("
//         "id INTEGER PRIMARY KEY"
//         ",name TEXT"
//         ",district_id TEXT"
//         ",district_text TEXT"
//         ",municipality TEXT"
//         ",user_id TEXT"
//         ",user_text TEXT"
//         ",created TEXT"
//         ",changed TEXT"
//
//         ")";
//
//     try {
//       //await db.execute("DROP TABLE ${tableName}");
//       await db.execute(sql);
//     } catch (e) {
//       Utils.log('Failed to create table because ${e . toString()}');
//
//       return false;
//     }
//
//     return true;
//   }
//
//
//   static deleteAll() async {
//     if (!(await CountyModel.initTable())) {
//       return;
//     }
//     Database db = await Utils.getDb();
//     if (!db.isOpen) {
//       return false;
//     }
//     await db.delete(CountyModel.tableName);
//   }
//
//
//
//
//
//   delete() async {
//     Database db = await Utils.getDb();
//     if (!db.isOpen) {
//       Utils.toast("Failed to init local store.");
//       return;
//     }
//
//     await initTable();
//
//     try {
//       await db.delete(
//           tableName,
//           where: 'id = $id'
//       );
//     } catch (e) {
//       Utils.toast("Failed to save student because ${e.toString()}");
//     }
//   }
//
//
// }
// */
