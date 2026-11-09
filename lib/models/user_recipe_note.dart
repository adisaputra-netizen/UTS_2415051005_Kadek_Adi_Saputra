class UserRecipeNote {
  final int? id;
  final String nim;
  final String recipeName;
  final String category;
  final String cookingNote;
  final String difficulty;
  final int personalRating;
  final DateTime? createdAt;

  UserRecipeNote({
    this.id,
    required this.nim,
    required this.recipeName,
    required this.category,
    required this.cookingNote,
    required this.difficulty,
    required this.personalRating,
    this.createdAt,
  });

  // Pemetaan baris tabel Supabase ke Dart Object
  factory UserRecipeNote.fromMap(Map<String, dynamic> map) {
    return UserRecipeNote(
      id: map['id'] as int?,
      nim: map['nim'] as String? ?? '',
      recipeName: map['recipe_name'] as String? ?? '',
      category: map['category'] as String? ?? 'Umum',
      cookingNote: map['cooking_note'] as String? ?? '',
      difficulty: map['difficulty'] as String? ?? 'Mudah',
      personalRating: (map['personal_rating'] as num?)?.toInt() ?? 5,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
    );
  }

  // Pemetaan Dart Object ke format Map untuk dikirim saat INSERT/UPDATE ke Supabase
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'nim': nim,
      'recipe_name': recipeName,
      'category': category,
      'cooking_note': cookingNote,
      'difficulty': difficulty,
      'personal_rating': personalRating,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}