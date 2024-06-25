class ListLaporanPegawaiModel {
  ListLaporanPegawaiModel({
    this.status,
    this.messages,
    this.data,
  });

  ListLaporanPegawaiModel.fromJson(dynamic json) {
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
    this.userId,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.name,
    this.sector,
  });

  Data.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sector = json['sector'];
    name = json['name'];
    if (json['image'] != null) {
      image = [];
      json['image'].forEach((v) {
        image?.add(ImageData.fromJson(v));
      });
    }
  }
  int? id;
  String? userId;
  String? description;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? sector;
  List<ImageData>? image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['description'] = description;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['name'] = name;
    map['sector'] = sector;
    if (image != null) {
      map['image'] = image?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ImageData {
  ImageData({
    this.id,
    this.reportId,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  ImageData.fromJson(dynamic json) {
    id = json['id'];
    reportId = json['report_id'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  String? reportId;
  String? image;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['report_id'] = reportId;
    map['image'] = image;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
