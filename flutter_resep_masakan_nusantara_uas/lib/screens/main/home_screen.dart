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
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      Provider.of<RecipeProvider>(context, listen: false).searchApiRecipes(query);
    } else {
      Provider.of<RecipeProvider>(context, listen: false).fetchApiRecipes();
    }
  }

  void _navigateToApiDetail(String mealId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeApiDetailScreen(mealId: mealId),
      ),
    );
  }
  
  void _navigateToUserRecipeDetail(UserRecipe recipe) {
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
      appBar: AppBar(title: const Text('Resep Nusantara')),
      body: Consumer<RecipeProvider>(
        builder: (context, provider, child) {
          final filteredUserRecipes = _searchController.text.isEmpty
              ? provider.allUserRecipes
              : provider.allUserRecipes
                  .where((recipe) => recipe.title.toLowerCase().contains(_searchController.text.toLowerCase()))
                  .toList();

          return RefreshIndicator(
            onRefresh: () => provider.fetchApiRecipes(),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (_) => _performSearch(),
                      decoration: InputDecoration(
                        hintText: 'Cari soto, rendang...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: _performSearch,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                      ),
                    ),
                  ),
                ),
                
                if (_searchController.text.isEmpty) ...[
                  _buildSectionTitle(context, 'KREASI KOMUNITAS'),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: filteredUserRecipes.isEmpty
                        ? const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text('Belum ada resep dari komunitas.'))))
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
                                  imageUrl: recipe.imageUrl ?? 'https://placehold.co/600x400/green/white?text=${recipe.title.substring(0,1)}',
                                  onTap: () => _navigateToUserRecipeDetail(recipe),
                                  userRecipe: recipe,
                                );
                              },
                              childCount: filteredUserRecipes.length,
                            ),
                          ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16.0)),
                  _buildSectionTitle(context, 'Resep Populer'),
                ],

                if (_searchController.text.isNotEmpty)
                  _buildSectionTitle(context, 'Hasil Pencarian'),

                if (provider.isLoading)
                  const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
                
                if (!provider.isLoading && provider.apiRecipes.isEmpty)
                  SliverFillRemaining(child: Center(child: Text(_searchController.text.isEmpty ? 'Gagal memuat resep.' : 'Resep tidak ditemukan.'))),
                
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final recipe = provider.apiRecipes[index];
                        return RecipeCard(
                          id: recipe.idMeal,
                          title: recipe.strMeal,
                          imageUrl: recipe.strMealThumb,
                          meal: recipe, 
                          onTap: () => _navigateToApiDetail(recipe.idMeal),
                        );
                      },
                      childCount: provider.apiRecipes.length,
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
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}