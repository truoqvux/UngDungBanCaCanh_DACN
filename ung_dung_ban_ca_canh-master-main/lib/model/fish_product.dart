class FishModel {
  int? id;
  String? productName;
  double? price;
  String? description;
  int? stockQuantity;
  int? capacity;
  bool? isVisible;
  String? createdAt;
  List<ProductImages>? productImages;
  List<Categories>? categories;

  FishModel(
      {this.id,
      this.productName,
      this.price,
      this.description,
      this.stockQuantity,
      this.isVisible,
      this.capacity,
      this.createdAt,
      this.productImages,
      this.categories = const []});

  FishModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['productName'];
    price = json['price'];
    description = json['description'];
    stockQuantity = json['stockQuantity'];
    isVisible = json['isVisible'];
    createdAt = json['createdAt'];
    capacity = 1;
    if (json['productImages'] != null) {
      productImages = <ProductImages>[];
      json['productImages'].forEach((v) {
        productImages!.add(new ProductImages.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    } else {
      categories = [];  
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productName'] = this.productName;
    data['price'] = this.price;
    data['description'] = this.description;
    data['stockQuantity'] = this.stockQuantity;
    data['isVisible'] = this.isVisible;
    data['createdAt'] = this.createdAt;
    if (this.productImages != null) {
      data['productImages'] =
          this.productImages!.map((v) => v.toJson()).toList();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductImages {
  int? id;
  String? imageUrl;
  int? productId;

  ProductImages({this.id, this.imageUrl, this.productId});

  ProductImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['imageUrl'];
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imageUrl'] = this.imageUrl;
    data['productId'] = this.productId;
    return data;
  }
}

class Categories {
  int? id;
  String? categoryName;

  Categories({this.id, this.categoryName});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['categoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryName'] = this.categoryName;
    return data;
  }
}
