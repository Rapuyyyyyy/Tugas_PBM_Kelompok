import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_resep_masakan_nusantara_uas/data/models/recipe_api_model.dart';

class ApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1/';

  Future<List<Meal>> fetchIndonesianRecipes() async {
    try {
      final response = await http.get(Uri.parse('${_baseUrl}filter.php?a=Indonesian'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          final List<dynamic> meals = data['meals'];
          return meals.map((json) => Meal.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching Indonesian recipes: $e");
      return [];
    }
  }

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