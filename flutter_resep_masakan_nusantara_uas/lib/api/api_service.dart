import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_resep_masakan_nusantara_uas/data/models/recipe_api_model.dart';

class ApiService {
  // Hanya gunakan satu base URL yang stabil
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1/';

  // Mengambil resep masakan Indonesia
  Future<List<Meal>> fetchIndonesianRecipes() async {
    try {
      final response = await http.get(Uri.parse('${_baseUrl}filter.php?a=Indonesian'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Pengecekan aman jika 'meals' null
        if (data['meals'] != null) {
          final List<dynamic> meals = data['meals'];
          return meals.map((json) => Meal.fromJson(json)).toList();
        }
      }
      // Jika status code bukan 200 atau 'meals' null, kembalikan list kosong
      return [];
    } catch (e) {
      debugPrint("Error fetching Indonesian recipes: $e");
      // Jika ada error koneksi, kembalikan list kosong agar aplikasi tidak crash
      return [];
    }
  }

  // Mencari resep berdasarkan nama
  Future<List<Meal>> searchRecipes(String query) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final response = await http.get(Uri.parse('${_baseUrl}search.php?s=$encodedQuery'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          final List<dynamic> meals = data['meals'];
          return meals.map((json) => Meal.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint("Error searching recipes: $e");
      return [];
    }
  }

  // Mengambil detail resep berdasarkan ID
  Future<MealDetail?> fetchRecipeDetails(String id) async {
    try {
      final response = await http.get(Uri.parse('${_baseUrl}lookup.php?i=$id'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          return MealDetail.fromJson(data['meals'][0]);
        }
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching recipe details: $e");
      return null;
    }
  }
}
