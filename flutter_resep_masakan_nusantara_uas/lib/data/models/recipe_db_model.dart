class Favorite {
  final String recipeId; // Bisa idMeal dari API atau id dari UserRecipe
  final int userId;
  final bool isApiRecipe;
  final String title;
  final String imageUrl;

  Favorite({
    required this.recipeId,
    required this.userId,
    required this.isApiRecipe,
    required this.title,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'recipeId': recipeId,
      'userId': userId,
      'isApiRecipe': isApiRecipe ? 1 : 0,
      'title': title,
      'imageUrl': imageUrl,
    };
  }

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      recipeId: map['recipeId'],
      userId: map['userId'],
      isApiRecipe: map['isApiRecipe'] == 1,
      title: map['title'],
      imageUrl: map['imageUrl'],
    );
  }
}

class UserRecipe {
  final int? id;
  final String title;
  final String ingredients;
  final String instructions;
  final String? imageUrl;
  final int userId;

  UserRecipe({
    this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    this.imageUrl,
    required this.userId,
  });

   Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      'imageUrl': imageUrl,
      'userId': userId
    };
  }

  factory UserRecipe.fromMap(Map<String, dynamic> map) {
    return UserRecipe(
      id: map['id'],
      title: map['title'],
      ingredients: map['ingredients'],
      instructions: map['instructions'],
      imageUrl: map['imageUrl'],
      userId: map['userId'],
    );
  }
}