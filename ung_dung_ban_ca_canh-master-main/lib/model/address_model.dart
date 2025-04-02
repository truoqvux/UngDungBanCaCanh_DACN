class AddressModel {
  int? id;
  String? fullname;
  String? city;
  String? district;
  String? street;
  String? phoneNumber;

  AddressModel(
      {this.id,
      this.fullname,
      this.city,
      this.district,
      this.street,
      this.phoneNumber});

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    city = json['city'];
    district = json['district'];
    street = json['street'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullname'] = this.fullname;
    data['city'] = this.city;
    data['district'] = this.district;
    data['street'] = this.street;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
