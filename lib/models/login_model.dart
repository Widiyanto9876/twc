class LoginModel {
  LoginModel({
    this.status,
    this.messages,
    this.data,
  });

  LoginModel.fromJson(dynamic json) {
    status = json['status'];
    messages = json['messages'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  int? status;
  String? messages;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['messages'] = messages;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    this.token,
    this.role,
    this.id,
  });

  Data.fromJson(dynamic json) {
    token = json['token'];
    role = json['role'];
    id = json['id'];
  }
  String? token;
  String? role;
  int? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = token;
    map['role'] = role;
    map['id'] = id;
    return map;
  }
}
