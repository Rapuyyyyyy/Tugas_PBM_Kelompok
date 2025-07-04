import 'dart:convert'; // Diperlukan untuk mengubah data JSON
import 'package:http/http.dart' as http; // Paket untuk melakukan permintaan HTTP
import 'package:flutter_resep_masakan_nusantara_uas/data/models/recipe_api_model.dart'; // Model untuk data resep dari API

/// Kelas ini bertanggung jawab untuk semua interaksi dengan TheMealDB API.
class ApiService {
  // URL dasar dari TheMealDB API.
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1/';

  /// Mengambil daftar resep masakan dari area "Indonesian".
  Future<List<Meal>> fetchIndonesianRecipes() async {
    // Membuat permintaan GET ke endpoint untuk filter berdasarkan area.
    final response = await http.get(Uri.parse('${_baseUrl}filter.php?a=Indonesian'));

    // Memeriksa apakah permintaan berhasil (status code 200).
    if (response.statusCode == 200) {
      // Mendekode respons JSON menjadi Map.
      final data = json.decode(response.body);
      
      // Mengambil list 'meals' dari data.
      final List<dynamic> mealsJson = data['meals'];
      
      // Mengubah setiap item JSON di dalam list menjadi objek Meal dan mengembalikannya sebagai List<Meal>.
      return mealsJson.map((json) => Meal.fromJson(json)).toList();
    } else {
      // Jika permintaan gagal, lemparkan sebuah exception.
      throw Exception('Gagal memuat resep dari API');
    }
  }

  /// Mengambil detail lengkap dari satu resep berdasarkan ID-nya.
  Future<MealDetail> fetchRecipeDetails(String id) async {
    // Membuat permintaan GET ke endpoint untuk mencari resep berdasarkan ID.
    final response = await http.get(Uri.parse('${_baseUrl}lookup.php?i=$id'));

    // Memeriksa apakah permintaan berhasil.
     if (response.statusCode == 200) {
      // Mendekode respons JSON.
      final data = json.decode(response.body);
      
      // Mengambil objek meal pertama dari list 'meals'.
      final Map<String, dynamic> mealJson = data['meals'][0];
      
      // Mengubah JSON menjadi objek MealDetail dan mengembalikannya.
      return MealDetail.fromJson(mealJson);
    } else {
      // Jika permintaan gagal, lemparkan sebuah exception.
      throw Exception('Gagal memuat detail resep');
    }
  }
}
