import 'package:flutter/material.dart';
import 'package:flutter_resep_masakan_nusantara_uas/data/models/user_model.dart';
import 'package:flutter_resep_masakan_nusantara_uas/providers/auth_provider.dart';
import 'package:flutter_resep_masakan_nusantara_uas/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Metode untuk menampilkan dialog edit profil
  void _showEditProfileDialog(BuildContext context, User currentUser) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: currentUser.name);
    final phoneController = TextEditingController(text: currentUser.phone);
    final favFoodController = TextEditingController(text: currentUser.favoriteFood);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Ubah Profil'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                    validator: (v) => v!.isEmpty ? 'Nama tidak boleh kosong' : null,
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                    keyboardType: TextInputType.phone,
                     validator: (v) => v!.isEmpty ? 'Telepon tidak boleh kosong' : null,
                  ),
                  TextFormField(
                    controller: favFoodController,
                    decoration: const InputDecoration(labelText: 'Makanan Favorit'),
                     validator: (v) => v!.isEmpty ? 'Makanan favorit tidak boleh kosong' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            ElevatedButton(
              child: const Text('Simpan'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final updatedUser = User(
                    id: currentUser.id,
                    email: currentUser.email, // email tidak diubah
                    password: currentUser.password, // password tidak diubah
                    name: nameController.text,
                    phone: phoneController.text,
                    favoriteFood: favFoodController.text,
                  );
                  // Panggil provider untuk update
                  Provider.of<AuthProvider>(context, listen: false)
                      .updateUser(updatedUser);
                  Navigator.of(ctx).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan Consumer di sini agar UI update saat data berubah
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        final user = authProvider.currentUser;

        if (user == null) {
          return const Center(child: Text('Pengguna tidak ditemukan.'));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profil Saya'),
          ),
          body: ListView(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                child: Text(
                  user.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(fontSize: 40),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  user.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                subtitle: Text(user.email),
              ),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Nomor Telepon'),
                subtitle: Text(user.phone),
              ),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Makanan Favorit'),
                subtitle: Text(user.favoriteFood),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Ubah Profil'),
                // PERBAIKAN: Panggil dialog saat di-tap
                onTap: () {
                  _showEditProfileDialog(context, user);
                },
              ),
              SwitchListTile(
                title: const Text('Mode Gelap'),
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
                secondary: const Icon(Icons.brightness_6),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: () {
                  authProvider.logout();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
