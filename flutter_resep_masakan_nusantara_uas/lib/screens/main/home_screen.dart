import 'package:flutter/material.dart';
import 'package:flutter_resep_masakan_nusantara_uas/data/models/recipe_db_model.dart';
import 'package:flutter_resep_masakan_nusantara_uas/providers/recipe_provider.dart';
import 'package:flutter_resep_masakan_nusantara_uas/screens/detail/recipe_api_detail_screen.dart';
import 'package:flutter_resep_masakan_nusantara_uas/screens/detail/recipe_db_detail_screen.dart';
import 'package:flutter_resep_masakan_nusantara_uas/widgets/recipe_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';

  void _navigateToApiDetail(String recipeId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeApiDetailScreen(mealId: recipeId),
      ),
    );
  }
  
  void _navigateToUserRecipeDetail(UserRecipe recipe) {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDbDetailScreen(recipe: recipe),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resep Nusantara'),
      ),
      body: Consumer<RecipeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.apiRecipes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Memuat resep...'),
                ],
              ),
            );
          }

          final filteredApiRecipes = provider.apiRecipes
              .where((recipe) => recipe.strMeal.toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList();

          final filteredUserRecipes = provider.allUserRecipes
              .where((recipe) => recipe.title.toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList();

          return RefreshIndicator(
            onRefresh: () async {
              await provider.fetchApiRecipes();
              await provider.fetchAllUserRecipes();
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() { _searchQuery = value; });
                      },
                      decoration: InputDecoration(
                        hintText: 'Cari resep apa hari ini?',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor.withAlpha(200),
                      ),
                    ),
                  ),
                ),
                _buildSectionTitle(context, 'Kreasi Komunitas'),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: filteredUserRecipes.isEmpty
                      ? const SliverToBoxAdapter(child: Center(child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('Belum ada resep dari pengguna.'),
                        )))
                      : SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 0.8, crossAxisSpacing: 10, mainAxisSpacing: 10,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final recipe = filteredUserRecipes[index];
                              return RecipeCard(
                                id: recipe.id.toString(),
                                title: recipe.title,
                                imageUrl: (recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty)
                                    ? recipe.imageUrl!
                                    : 'https://placehold.co/600x400/green/white?text=${recipe.title.substring(0,1)}',
                                onTap: () => _navigateToUserRecipeDetail(recipe),
                                userRecipe: recipe,
                              );
                            },
                            childCount: filteredUserRecipes.length,
                          ),
                        ),
                ),
                // Jarak antar bagian
                const SliverToBoxAdapter(
                  child: SizedBox(height: 16.0),
                ),
                _buildSectionTitle(context, 'Populer dari Nusantara'),
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: filteredApiRecipes.isEmpty && _searchQuery.isNotEmpty
                  ? const SliverToBoxAdapter(child: Center(child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('Tidak ada resep yang cocok.'),
                        )))
                  : SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 0.8, crossAxisSpacing: 10, mainAxisSpacing: 10,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final recipe = filteredApiRecipes[index];
                              return RecipeCard(
                                id: recipe.idMeal,
                                title: recipe.strMeal,
                                imageUrl: recipe.strMealThumb,
                                meal: recipe, // Penting untuk fitur favorit
                                onTap: () => _navigateToApiDetail(recipe.idMeal),
                              );
                            },
                            childCount: filteredApiRecipes.length,
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
