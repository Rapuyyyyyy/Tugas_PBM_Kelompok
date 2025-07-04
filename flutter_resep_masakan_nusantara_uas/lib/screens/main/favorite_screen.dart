import 'package:flutter/material.dart';
import 'package:flutter_resep_masakan_nusantara_uas/providers/recipe_provider.dart';
import 'package:flutter_resep_masakan_nusantara_uas/screens/detail/add_edit_recipe_screen.dart';
import 'package:flutter_resep_masakan_nusantara_uas/screens/detail/recipe_api_detail_screen.dart';
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
                _buildFavoritesTab(context, provider),
                _buildUserRecipesTab(context, provider),
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

  /// Widget untuk membangun Tab "Favorit"
  Widget _buildFavoritesTab(BuildContext context, RecipeProvider provider) {
    if (provider.favoriteRecipes.isEmpty) {
      return _buildEmptyState(
        icon: Icons.bookmark_border,
        message: 'Anda belum punya resep favorit.',
        suggestion: 'Cari resep di Beranda dan tandai sebagai favorit!',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: provider.favoriteRecipes.length,
      itemBuilder: (context, index) {
        final fav = provider.favoriteRecipes[index];
        return Dismissible(
          key: Key(fav.recipeId),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            provider.removeFavorite(fav.recipeId);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${fav.title} dihapus dari favorit.')),
            );
          },
          background: Container(
            color: Colors.red.withAlpha(204),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              // PERBAIKAN: Pengecekan URL yang aman untuk mencegah error
              child: _buildSafeImage(fav.imageUrl, 50, 50),
            ),
            title: Text(fav.title),
            subtitle: Text(fav.isApiRecipe ? 'Dari Resep Populer' : 'Dari Komunitas'),
            onTap: () {
              // Navigasi ke halaman detail yang sesuai
              if (fav.isApiRecipe) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RecipeApiDetailScreen(mealId: fav.recipeId)),
                );
              } else {
                // Tambahkan navigasi ke detail resep pengguna jika sudah dibuat
              }
            },
          ),
        );
      },
    );
  }

  /// Widget untuk membangun Tab "Resep Saya" dengan tampilan baru
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
        return Card(
          elevation: 4,
          shadowColor: Colors.black.withAlpha(51),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddEditRecipeScreen(recipe: recipe)),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  // PERBAIKAN: Menampilkan gambar resep dengan aman
                  child: _buildSafeImage(recipe.imageUrl, double.infinity, 100),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          recipe.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                            onPressed: () {
                              _showDeleteConfirmation(context, provider, recipe);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Helper untuk menampilkan gambar dengan aman dan placeholder
  Widget _buildSafeImage(String? imageUrl, double width, double height) {
    if (imageUrl != null && imageUrl.isNotEmpty && Uri.tryParse(imageUrl)?.hasAbsolutePath == true) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
      );
    }
    return _buildImagePlaceholder();
  }

  /// Placeholder untuk gambar yang tidak valid atau kosong
  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.restaurant_menu, color: Colors.grey, size: 40),
      ),
    );
  }
  
  /// Helper untuk menampilkan state kosong yang informatif
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

  /// Helper untuk menampilkan dialog konfirmasi hapus
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
