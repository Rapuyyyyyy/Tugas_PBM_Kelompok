import 'package:flutter/material.dart';
import 'package:flutter_resep_masakan_nusantara_uas/data/models/user_model.dart';
import 'package:flutter_resep_masakan_nusantara_uas/providers/auth_provider.dart';
import 'package:flutter_resep_masakan_nusantara_uas/widgets/password_field.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _favFoodController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = User(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        favoriteFood: _favFoodController.text,
        password: _passwordController.text, // akan di-hash di provider
      );

      final success = await authProvider.register(user);

      if (!mounted) return; // Selalu cek mounted setelah await

      setState(() { _isLoading = false; });

      if (success) {
        // Tampilan pesan sukses dan arahkan ke halaman login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi berhasil! Silakan login.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } else {
        // Tampilkan pesan gagal
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal mendaftar. Email mungkin sudah digunakan.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Akun Baru')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                  validator: (v) => v!.isEmpty ? 'Nama tidak boleh kosong' : null),
              const SizedBox(height: 16),
              TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) => v!.isEmpty || !v.contains('@') ? 'Email tidak valid' : null),
              const SizedBox(height: 16),
               TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                  validator: (v) => v!.isEmpty ? 'Nomor telepon tidak boleh kosong' : null),
              const SizedBox(height: 16),
               TextFormField(
                  controller: _favFoodController,
                  decoration: const InputDecoration(labelText: 'Makanan Favorit'),
                  validator: (v) => v!.isEmpty ? 'Makanan favorit tidak boleh kosong' : null),
              const SizedBox(height: 16),
              PasswordField(controller: _passwordController, labelText: 'Password'),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _register,
                      child: const Text('Daftar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}