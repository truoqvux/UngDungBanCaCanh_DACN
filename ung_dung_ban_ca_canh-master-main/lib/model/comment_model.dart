class CommentModel {
  int? id;
  String? content;
  int? productId;
  String? username;
  String? createAt;

  CommentModel(
      {this.id, this.content, this.productId, this.username, this.createAt});

  CommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    productId = json['productId'];
    username = json['username'];
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['content'] = this.content;
    data['productId'] = this.productId;
    data['username'] = this.username;
    data['createAt'] = this.createAt;
    return data;
  }
}
