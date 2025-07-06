import 'package:flutter/material.dart';
import 'package:flutter_resep_masakan_nusantara_uas/api/api_service.dart';
import 'package:flutter_resep_masakan_nusantara_uas/data/models/recipe_api_model.dart';

class RecipeApiDetailScreen extends StatelessWidget {
  final String mealId;

  const RecipeApiDetailScreen({super.key, required this.mealId});

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
            return Center(child: Text('Gagal memuat detail resep.\nError: ${snapshot.error ?? 'Data tidak ditemukan'}'));
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
                      // PERBAIKAN: Panggil metode baru untuk menampilkan daftar langkah
                      _buildStepsList(context, meal.strInstructions),
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

  // PERBAIKAN: Widget baru untuk menampilkan daftar langkah-langkah
  Widget _buildStepsList(BuildContext context, String instructions) {
    // Memecah string instruksi menjadi daftar berdasarkan baris baru
    final steps = instructions.split('\r\n').where((s) => s.isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 14,
                child: Text('${index + 1}'),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(steps[index], style: const TextStyle(fontSize: 16, height: 1.4))),
            ],
          ),
        );
      }),
    );
  }
}
