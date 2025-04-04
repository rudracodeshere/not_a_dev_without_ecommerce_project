class ProductColor {
  String title;
  String hexcode;

  ProductColor({required this.title, required this.hexcode});

  Map<String, dynamic> toJson() {
    return {'title': title, 'hexcode': hexcode};
  }

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(title: json['title'], hexcode: json['hexcode']);
  }
}
