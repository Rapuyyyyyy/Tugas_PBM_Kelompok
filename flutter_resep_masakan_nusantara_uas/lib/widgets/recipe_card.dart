import 'package:flutter/material.dart';
// PERBAIKAN: Tambahkan import yang hilang
import 'package:flutter_resep_masakan_nusantara_uas/data/models/recipe_db_model.dart';
import 'package:flutter_resep_masakan_nusantara_uas/data/models/recipe_api_model.dart';
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
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.restaurant_menu, size: 50, color: Colors.grey)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Consumer<RecipeProvider>(
                builder: (context, provider, child) {
                  // PERBAIKAN: Panggil metode dengan nama yang benar
                  final isFav = provider.isRecipeFavorite(id);
                  // PERBAIKAN: Panggil getter dengan nama yang benar
                  final isMyOwnRecipe = userRecipe?.userId == provider.currentUser?.id;

                  return CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(scale: animation, child: child);
                        },
                        child: Icon(
                          isFav ? Icons.bookmark : Icons.bookmark_border,
                          color: isMyOwnRecipe ? Colors.grey : Colors.amber,
                          key: ValueKey<bool>(isFav),
                        ),
                      ),
                      onPressed: () {
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
