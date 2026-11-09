class BalineseRecipe {
  final String id;
  final String name;
  final String category;
  final String difficulty;
  final int cookingTime;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final String description;

  BalineseRecipe({
    required this.id,
    required this.name,
    required this.category,
    required this.difficulty,
    required this.cookingTime,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.description,
  });

  // Factory constructor untuk konversi JSON dari REST API ke Dart Object
  factory BalineseRecipe.fromJson(Map<String, dynamic> json) {
    return BalineseRecipe(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Resep Tanpa Nama',
      category: json['category'] as String? ?? 'Umum',
      difficulty: json['difficulty'] as String? ?? 'Mudah',
      cookingTime: (json['cooking_time'] as num?)?.toInt() ?? 30,
      imageUrl: json['image_url'] as String? ?? '',
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      steps: (json['steps'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      description: json['description'] as String? ?? '',
    );
  }

  // Konversi Dart Object ke Map/JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'difficulty': difficulty,
      'cooking_time': cookingTime,
      'image_url': imageUrl,
      'ingredients': ingredients,
      'steps': steps,
      'description': description,
    };
  }
}