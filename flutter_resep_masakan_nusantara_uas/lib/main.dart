import 'package:flutter/material.dart';
import 'package:flutter_resep_masakan_nusantara_uas/data/database_helper.dart';
import 'package:flutter_resep_masakan_nusantara_uas/providers/auth_provider.dart';
import 'package:flutter_resep_masakan_nusantara_uas/providers/recipe_provider.dart';
import 'package:flutter_resep_masakan_nusantara_uas/providers/theme_provider.dart';
import 'package:flutter_resep_masakan_nusantara_uas/screens/auth/login_screen.dart';
import 'package:flutter_resep_masakan_nusantara_uas/screens/main/main_screen_wrapper.dart';
import 'package:flutter_resep_masakan_nusantara_uas/utils/app_theme.dart';
import 'package:provider/provider.dart';

// Impor tambahan untuk tes koneksi
import 'package:http/http.dart' as http;
import 'dart:convert';

/// FUNGSI TES KONEKSI API SECARA LANGSUNG
Future<void> testApiConnection() async {
  // Pesan ini akan muncul di Debug Console
  debugPrint("===================================");
  debugPrint("MEMULAI TES KONEKSI API LANGSUNG...");
  
  final url = Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?a=Indonesian');
  
  try {
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      debugPrint("✅ BERHASIL: Koneksi sukses dan data diterima.");
      debugPrint("Contoh judul resep: ${data['meals'][0]['strMeal']}");
    } else {
      debugPrint("❌ GAGAL: Server merespons dengan status code: ${response.statusCode}");
      debugPrint("Isi respons: ${response.body}");
    }
  } catch (e) {
    debugPrint("❌ GAGAL: Terjadi error saat mencoba menghubungkan ke API.");
    debugPrint("Detail Error: $e");
  }
  
  debugPrint("===================================");
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Panggil fungsi tes sebelum menjalankan aplikasi
  await testApiConnection();

  final dbHelper = DatabaseHelper.instance;
  runApp(MyApp(dbHelper: dbHelper));
}

class MyApp extends StatelessWidget {
  final DatabaseHelper dbHelper;
  const MyApp({super.key, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider(dbHelper)),
        ChangeNotifierProxyProvider<AuthProvider, RecipeProvider>(
          create: (_) => RecipeProvider(dbHelper, null),
          update: (_, auth, previous) => RecipeProvider(dbHelper, auth.currentUser),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Resep Nusantara',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            home: Consumer<AuthProvider>(
              builder: (context, auth, _) {
                if (auth.isAuthenticated) {
                  return const MainScreenWrapper();
                } else {
                  return const LoginScreen();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
