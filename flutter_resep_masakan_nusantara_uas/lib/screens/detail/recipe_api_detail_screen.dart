import 'package:flutter/material.dart';
import 'package:flutter_resep_masakan_nusantara_uas/api/api_service.dart';
import 'package:flutter_resep_masakan_nusantara_uas/data/models/recipe_api_model.dart';

class RecipeApiDetailScreen extends StatelessWidget {
  final String mealId;
  // PERBAIKAN: Tambahkan parameter ini
  final String imageUrl; 

  // PERBAIKAN: Tambahkan parameter ini ke konstruktor
  const RecipeApiDetailScreen({super.key, required this.mealId, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<MealDetail?>(
        future: ApiService().fetchRecipeDetails(mealId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Gagal memuat detail resep: ${snapshot.error ?? 'Data tidak ditemukan'}'));
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
                    style: const TextStyle(shadows: [Shadow(color: Colors.black, blurRadius: 10)]),
                  ),
                  // PERBAIKAN: Gunakan Hero untuk animasi yang mulus
                  background: Hero(
                    tag: imageUrl, // Gunakan imageUrl yang dikirim dari halaman sebelumnya
                    child: Image.network(
                      meal.strMealThumb,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Chip(avatar: const Icon(Icons.category), label: Text(meal.strCategory)),
                          Chip(avatar: const Icon(Icons.public), label: Text(meal.strArea)),
                        ],
                      ),
                      const Divider(height: 32),
                      Text('Bahan-bahan', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      _buildIngredientsList(context, meal),
                      const Divider(height: 32),
                      Text('Langkah-langkah', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(meal.strInstructions, style: const TextStyle(fontSize: 16, height: 1.5)),
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
  
  Widget _buildIngredientsList(BuildContext context, MealDetail meal) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: List.generate(meal.ingredients.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Expanded(child: Text(meal.ingredients[index], style: const TextStyle(fontSize: 15))),
                  Text(meal.measures[index], style: TextStyle(fontSize: 15, color: Colors.grey.shade700)),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
