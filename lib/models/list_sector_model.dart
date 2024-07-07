class ListSectorModel {
  ListSectorModel({
    this.status,
    this.messages,
    this.data,
  });

  ListSectorModel.fromJson(dynamic json) {
    status = json['status'];
    messages = json['messages'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  int? status;
  String? messages;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['messages'] = messages;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Data {
  Data({
    this.sector,
  });

  Data.fromJson(dynamic json) {
    sector = json['sector'];
  }
  String? sector;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sector'] = sector;
    return map;
  }
}
