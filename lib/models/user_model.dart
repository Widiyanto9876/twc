class UserModel {
  UserModel({
    this.status,
    this.messages,
    this.data,
  });

  UserModel.fromJson(dynamic json) {
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
    this.id,
    this.name,
    this.sector,
    this.number,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    sector = json['sector'];
    number = json['number'];
    role = json['role'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  String? name;
  String? sector;
  String? number;
  String? role;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['sector'] = sector;
    map['number'] = number;
    map['role'] = role;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
