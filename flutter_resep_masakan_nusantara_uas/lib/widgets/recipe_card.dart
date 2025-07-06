import 'package:flutter/material.dart';
import 'package:flutter_resep_masakan_nusantara_uas/data/models/recipe_api_model.dart';
import 'package:flutter_resep_masakan_nusantara_uas/data/models/recipe_db_model.dart';
import 'package:flutter_resep_masakan_nusantara_uas/providers/recipe_provider.dart';
import 'package:provider/provider.dart';

class RecipeCard extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final VoidCallback onTap;
  final Meal? meal; 
  final UserRecipe? userRecipe;

  const RecipeCard({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.onTap,
    this.meal,
    this.userRecipe,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Gambar dengan efek Parallax sederhana
            Hero(
              tag: imageUrl, // Tag unik untuk animasi transisi
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.restaurant_menu, size: 50, color: Colors.grey)),
              ),
            ),
            // Gradien gelap di bagian bawah untuk keterbacaan teks
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black.withAlpha(204)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Judul dan Ikon Bookmark
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Consumer<RecipeProvider>(
                    builder: (context, provider, child) {
                      final isFav = provider.isRecipeFavorite(id);
                      final isMyOwnRecipe = userRecipe?.userId == provider.currentUser?.id;

                      return InkWell(
                        onTap: () {
                           if (isMyOwnRecipe) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Anda tidak bisa memfavoritkan resep sendiri.')),
                            );
                            return;
                          }
                          if (isFav) {
                            provider.removeFavorite(id);
                          } else {
                            if (meal != null) {
                              provider.addApiRecipeToFavorites(meal!);
                            } else if (userRecipe != null) {
                              provider.addUserRecipeToFavorites(userRecipe!);
                            }
                          }
                        },
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white.withAlpha(51), 
                          child: Icon(
                            isFav ? Icons.bookmark : Icons.bookmark_border,
                            color: isMyOwnRecipe ? Colors.grey.shade400 : Colors.amber,
                            size: 22,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
