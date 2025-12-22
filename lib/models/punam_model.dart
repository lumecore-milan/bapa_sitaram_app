class PoonamModel {
  String poonamTitle;
  List<PoonamItem> poonamList;

  PoonamModel({this.poonamTitle = '', this.poonamList = const []});

  factory PoonamModel.fromJson(Map<String, dynamic> json) {
    return PoonamModel(poonamTitle: json["poonam_title"] ?? '', poonamList: (json["poonam_list"] as List<dynamic>? ?? []).map((e) => PoonamItem.fromJson(e)).toList());
  }

  static List<PoonamModel> fromJsonList(List<dynamic>? list) {
    return (list ?? []).map((e) => PoonamModel.fromJson(e)).toList();
  }
}

class PoonamItem {
  int id;
  String title;
  String date;
  bool spacial;
  int status;

  PoonamItem({this.id = 0, this.title = '', this.date = '', this.spacial = false, this.status = 0});

  factory PoonamItem.fromJson(Map<String, dynamic> json) {
    return PoonamItem(id: json["id"] ?? 0, title: json["title"] ?? '', date: json["date"] ?? '', spacial: json["spacial"] ?? false, status: json["status"] ?? 0);
  }

  static List<PoonamItem> fromJsonList(List<dynamic>? list) {
    return (list ?? []).map((e) => PoonamItem.fromJson(e)).toList();
  }
}
