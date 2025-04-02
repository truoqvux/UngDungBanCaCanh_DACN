class OrderModel {
  int? id;
  String? note;
  String? status;
  String? createdAt;
  Address? address;

  OrderModel({this.id, this.note, this.status, this.createdAt, this.address});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    note = json['note'];
    status = json['status'];
    createdAt = json['createdAt'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['note'] = this.note;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    return data;
  }
}

class Address {
  int? id;
  String? fullname;
  String? city;
  String? district;
  String? street;
  String? phoneNumber;

  Address(
      {this.id,
      this.fullname,
      this.city,
      this.district,
      this.street,
      this.phoneNumber});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    city = json['city'];
    district = json['district'];
    street = json['street'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullname'] = this.fullname;
    data['city'] = this.city;
    data['district'] = this.district;
    data['street'] = this.street;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
