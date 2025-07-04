import 'package:flutter/material.dart';
import 'package:flutter_resep_masakan_nusantara_uas/data/models/recipe_db_model.dart';

class RecipeDbDetailScreen extends StatelessWidget {
  final UserRecipe recipe;

  const RecipeDbDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar Resep
            if (recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty)
              Image.network(
                recipe.imageUrl!,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              )
            else
              Container(
                height: 250,
                color: Colors.grey.shade300,
                child: const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
              ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 32),

                  Text('Bahan-bahan', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(recipe.ingredients, style: const TextStyle(fontSize: 16, height: 1.5)),
                  const Divider(height: 32),

                  Text('Langkah-langkah', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(recipe.instructions, style: const TextStyle(fontSize: 16, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
