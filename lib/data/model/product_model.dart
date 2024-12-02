class ProductModelResponse {
  final String id;
  final String name;

  const ProductModelResponse({
    required this.id,
    required this.name,
  });

  factory ProductModelResponse.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'name': String name,
      } =>
        ProductModelResponse(
          id: id,
          name: name,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
