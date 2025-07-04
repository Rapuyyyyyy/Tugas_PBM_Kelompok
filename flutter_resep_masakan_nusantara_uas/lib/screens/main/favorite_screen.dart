import 'package:flutter/material.dart';
import 'package:flutter_resep_masakan_nusantara_uas/data/models/recipe_db_model.dart';
import 'package:flutter_resep_masakan_nusantara_uas/providers/recipe_provider.dart';
import 'package:flutter_resep_masakan_nusantara_uas/screens/detail/add_edit_recipe_screen.dart';
import 'package:flutter_resep_masakan_nusantara_uas/screens/detail/recipe_api_detail_screen.dart';
import 'package:flutter_resep_masakan_nusantara_uas/screens/detail/recipe_db_detail_screen.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Koleksiku'),
          bottom: const TabBar(
            indicatorWeight: 3,
            tabs: [
              Tab(icon: Icon(Icons.bookmark), text: 'Favorit'),
              Tab(icon: Icon(Icons.edit_note), text: 'Resep Saya'),
            ],
          ),
        ),
        body: Consumer<RecipeProvider>(
          builder: (context, provider, child) {
            return TabBarView(
              children: [
                KeepAlivePage(child: _buildFavoritesTabAsCards(context, provider)),
                KeepAlivePage(child: _buildUserRecipesTab(context, provider)),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddEditRecipeScreen()),
            );
          },
          label: const Text('Tambah Resep'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildFavoritesTabAsCards(BuildContext context, RecipeProvider provider) {
    if (provider.favoriteRecipes.isEmpty) {
      return _buildEmptyState(
        icon: Icons.bookmark_border,
        message: 'Anda belum punya resep favorit.',
        suggestion: 'Cari resep di Beranda dan tandai sebagai favorit!',
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8, // Kembalikan ke rasio yang lebih baik
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: provider.favoriteRecipes.length,
      itemBuilder: (context, index) {
        final fav = provider.favoriteRecipes[index];
        // PERBAIKAN: Gunakan layout kartu yang lebih sederhana dan anti-overflow
        return _buildRecipeCard(
          context: context,
          provider: provider,
          imageUrl: fav.imageUrl,
          title: fav.title,
          onTap: () => _navigateToFavoriteDetail(context, provider, fav),
          onDelete: () {
            provider.removeFavorite(fav.recipeId);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${fav.title} dihapus dari favorit.')),
            );
          },
        );
      },
    );
  }

  Widget _buildUserRecipesTab(BuildContext context, RecipeProvider provider) {
    if (provider.userRecipes.isEmpty) {
      return _buildEmptyState(
        icon: Icons.note_add_outlined,
        message: 'Anda belum membuat resep sendiri.',
        suggestion: 'Klik tombol + untuk memulai!',
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: provider.userRecipes.length,
      itemBuilder: (context, index) {
        final recipe = provider.userRecipes[index];
        // PERBAIKAN: Gunakan layout kartu yang sama untuk konsistensi
        return _buildRecipeCard(
          context: context,
          provider: provider,
          imageUrl: recipe.imageUrl,
          title: recipe.title,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddEditRecipeScreen(recipe: recipe)),
            );
          },
          onDelete: () => _showDeleteConfirmation(context, provider, recipe),
        );
      },
    );
  }

  // PERBAIKAN: Buat satu metode untuk membangun kartu agar tidak duplikat kode
  Widget _buildRecipeCard({
    required BuildContext context,
    required RecipeProvider provider,
    required String? imageUrl,
    required String title,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withAlpha(51),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar
            Expanded(
              child: _buildSafeImage(imageUrl, double.infinity, 100),
            ),
            // Judul dan Tombol Hapus
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 22),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToFavoriteDetail(BuildContext context, RecipeProvider provider, Favorite fav) {
    if (fav.isApiRecipe) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => RecipeApiDetailScreen(mealId: fav.recipeId)),
      );
    } else {
      // PERBAIKAN: Gunakan Map untuk pencarian super cepat
      final userRecipe = provider.userRecipeMap[fav.recipeId];
      if (userRecipe != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RecipeDbDetailScreen(recipe: userRecipe)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Detail resep tidak ditemukan.')),
        );
      }
    }
  }

  // ... (sisa helper widget lainnya: _buildSafeImage, _buildEmptyState, _showDeleteConfirmation)
  Widget _buildSafeImage(String? imageUrl, double width, double height) {
    if (imageUrl != null && imageUrl.isNotEmpty && Uri.tryParse(imageUrl)?.hasAbsolutePath == true) {
      return Image.network(imageUrl, width: width, height: height, fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
      );
    }
    return _buildImagePlaceholder();
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(child: Icon(Icons.restaurant_menu, color: Colors.grey, size: 40)),
    );
  }
  
  Widget _buildEmptyState({required IconData icon, required String message, required String suggestion}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(suggestion, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, RecipeProvider provider, dynamic recipe) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Anda yakin ingin menghapus resep "${recipe.title}"?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            onPressed: () {
              provider.deleteUserRecipe(recipe.id!);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}

// Widget helper untuk menjaga state tab tetap hidup
class KeepAlivePage extends StatefulWidget {
  final Widget child;
  const KeepAlivePage({super.key, required this.child});

  @override
  State<KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
