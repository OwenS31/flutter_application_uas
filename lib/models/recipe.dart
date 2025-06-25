class Recipe {
  final int id;
  final String name;
  final String? description;
  final List<String> ingredients;

  Recipe({
    required this.id,
    required this.name,
    this.description,
    required this.ingredients,
  });

  // Factory constructor untuk membuat instance Recipe dari map (data JSON dari Supabase)
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      // Konversi dari List<dynamic> ke List<String>
      ingredients: List<String>.from(map['ingredients']),
    );
  }
}