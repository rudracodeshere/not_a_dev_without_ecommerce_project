class Category {
  String? title;
  String? image;
  Category({this.title, this.image});
  Category.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    image = json['image'];
  }
}
