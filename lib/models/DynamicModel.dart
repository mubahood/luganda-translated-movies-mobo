import '../utils/Utilities.dart';

class DynamicModel {
  DynamicModel();

  String id = "";
  String attribute_1 = "";
  String attribute_2 = "";
  String attribute_3 = "";
  String attribute_4 = "";
  String attribute_5 = "";

  //list contains it by id
  static bool inList(List<DynamicModel> list, String id) {
    List<String> allIds = [];
    for (var f in list) {
      allIds.add(f.id.toLowerCase());
    }
    if (allIds.contains(id.toString().toLowerCase())) {
      return true;
    }
    return false;
  }

  //remove from list
  static List<DynamicModel> removeFromList(
      List<DynamicModel> list, String id) {
    List<DynamicModel> newList = [];
    for (var f in list) {
      if (f.id.toLowerCase() != id.toString().toLowerCase()) {
        newList.add(f);
      }
    }
    return newList;
  }

  //tojson
  toJson() {
    return {
      'id': id,
      'attribute_1': attribute_1,
      'attribute_2': attribute_2,
      'attribute_3': attribute_3,
      'attribute_4': attribute_4,
      'attribute_5': attribute_5,
    };
  }

  //fromjson
  DynamicModel.fromJson(Map<String, dynamic> m) {
    id = Utils.to_str(m['id'], '');
    attribute_1 = Utils.to_str(m['attribute_1'], '');
    attribute_2 = Utils.to_str(m['attribute_2'], '');
    attribute_3 = Utils.to_str(m['attribute_3'], '');
    attribute_4 = Utils.to_str(m['attribute_4'], '');
    attribute_5 = Utils.to_str(m['attribute_5'], '');
  }

  //to json list
  static List<Map<String, dynamic>> toJsonList(List<DynamicModel> list) {
    List<Map<String, dynamic>> data = [];
    for (var f in list) {
      data.add(f.toJson());
    }
    return data;
  }

  //from json list
  static List<DynamicModel> fromJsonList(List<dynamic> data) {
    List<DynamicModel> list = [];
    for (var m in data) {
      list.add(DynamicModel.fromJson(m));
    }
    return list;
  }
}
