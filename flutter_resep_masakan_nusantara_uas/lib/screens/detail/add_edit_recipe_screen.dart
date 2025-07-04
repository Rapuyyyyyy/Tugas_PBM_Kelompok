import 'package:flutter/material.dart';
import 'package:flutter_resep_masakan_nusantara_uas/data/models/recipe_db_model.dart';
import 'package:flutter_resep_masakan_nusantara_uas/providers/auth_provider.dart';
import 'package:flutter_resep_masakan_nusantara_uas/providers/recipe_provider.dart';
import 'package:provider/provider.dart';

class AddEditRecipeScreen extends StatefulWidget {
  final UserRecipe? recipe; // Jika null, berarti mode 'Tambah Baru'

  const AddEditRecipeScreen({super.key, this.recipe});

  @override
  State<AddEditRecipeScreen> createState() => _AddEditRecipeScreenState();
}

class _AddEditRecipeScreenState extends State<AddEditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _ingredientsController;
  late TextEditingController _instructionsController;
  late TextEditingController _imageUrlController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data resep jika dalam mode 'Edit'
    _titleController = TextEditingController(text: widget.recipe?.title ?? '');
    _ingredientsController = TextEditingController(text: widget.recipe?.ingredients ?? '');
    _instructionsController = TextEditingController(text: widget.recipe?.instructions ?? '');
    _imageUrlController = TextEditingController(text: widget.recipe?.imageUrl ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.currentUser!.id!;

      final userRecipe = UserRecipe(
        id: widget.recipe?.id, // id akan null jika mode 'Tambah'
        title: _titleController.text,
        ingredients: _ingredientsController.text,
        instructions: _instructionsController.text,
        imageUrl: _imageUrlController.text,
        userId: userId,
      );

      try {
        if (widget.recipe == null) {
          // Mode Tambah
          await recipeProvider.addUserRecipe(userRecipe);
        } else {
          // Mode Edit
          await recipeProvider.updateUserRecipe(userRecipe);
        }
        
        if (mounted) {
          Navigator.of(context).pop(); // Kembali ke halaman sebelumnya setelah menyimpan
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan resep: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe == null ? 'Tambah Resep Baru' : 'Edit Resep'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(child: CircularProgressIndicator(color: Colors.white)),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveRecipe,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Resep',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Judul tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL Gambar (Opsional)',
                  hintText: 'https://contoh.com/gambar.jpg',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
              ),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(
                  labelText: 'Bahan-bahan',
                  hintText: 'Contoh: Bawang merah, 2 siung\nGaram, 1 sdt',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) => value!.isEmpty ? 'Bahan tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _instructionsController,
                decoration: const InputDecoration(
                  labelText: 'Langkah-langkah',
                  hintText: '1. Tumis bawang...\n2. Masukkan ayam...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 10,
                validator: (value) => value!.isEmpty ? 'Langkah-langkah tidak boleh kosong' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
