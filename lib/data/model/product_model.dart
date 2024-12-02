class Product {
  final String id;
  final String name;
  final ProductData? data;

  Product({required this.id, required this.name, this.data});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      data: json['data'] != null ? ProductData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'data': data?.toJson(),
    };
  }
}

class ProductData {
  final String? color;
  final String? capacity;

  ProductData({this.color, this.capacity});

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      color: json['color'] as String?,
      capacity: json['capacity'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'color': color,
      'capacity': capacity,
    };
  }
}
