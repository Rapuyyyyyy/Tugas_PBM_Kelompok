import 'package:flutter/material.dart';
import 'package:flutter_resep_masakan_nusantara_uas/api/api_service.dart';
import 'package:flutter_resep_masakan_nusantara_uas/data/models/recipe_api_model.dart';

class RecipeApiDetailScreen extends StatelessWidget {
  final String mealId;

  const RecipeApiDetailScreen({super.key, required this.mealId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<MealDetail>(
        future: ApiService().fetchRecipeDetails(mealId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Resep tidak ditemukan.'));
          }

          final meal = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    meal.strMeal,
                    style: const TextStyle(shadows: [
                      Shadow(color: Colors.black, blurRadius: 10)
                    ]),
                  ),
                  background: Image.network(
                    meal.strMealThumb,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bagian Kategori dan Asal
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildInfoChip(Icons.category, meal.strCategory),
                          _buildInfoChip(Icons.public, meal.strArea),
                        ],
                      ),
                      const Divider(height: 32),

                      // Bagian Bahan-bahan
                      Text('Bahan-bahan', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      _buildIngredientsList(meal),
                      const Divider(height: 32),

                      // Bagian Langkah-langkah
                      Text('Langkah-langkah', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text(
                        meal.strInstructions,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon),
      label: Text(text),
    );
  }

  Widget _buildIngredientsList(MealDetail meal) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: List.generate(meal.ingredients.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Expanded(child: Text(meal.ingredients[index])),
                  Text(meal.measures[index]),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
