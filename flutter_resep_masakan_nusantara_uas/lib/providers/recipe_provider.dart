import 'package:flutter/material.dart';
import 'package:flutter_resep_masakan_nusantara_uas/api/api_service.dart';
import 'package:flutter_resep_masakan_nusantara_uas/data/database_helper.dart';
import 'package:flutter_resep_masakan_nusantara_uas/data/models/recipe_api_model.dart';
import 'package:flutter_resep_masakan_nusantara_uas/data/models/recipe_db_model.dart';
import 'package:flutter_resep_masakan_nusantara_uas/data/models/user_model.dart';

class RecipeProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper;
  final User? _currentUser;
  final ApiService _apiService = ApiService();

  RecipeProvider(this._dbHelper, this._currentUser) {
    if (_currentUser != null) {
      fetchApiRecipes();
      fetchFavorites();
      fetchUserRecipes();
      fetchAllUserRecipes();
    }
  }

  User? get currentUser => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Meal> _apiRecipes = [];
  List<Meal> get apiRecipes => _apiRecipes;

  List<Favorite> _favoriteRecipes = [];
  List<Favorite> get favoriteRecipes => _favoriteRecipes;

  List<UserRecipe> _userRecipes = [];
  List<UserRecipe> get userRecipes => _userRecipes;
  
  List<UserRecipe> _allUserRecipes = [];
  List<UserRecipe> get allUserRecipes => _allUserRecipes;

  Future<void> fetchApiRecipes() async {
    _isLoading = true;
    notifyListeners();
    try {
      _apiRecipes = await _apiService.fetchIndonesianRecipes();
    } catch (e) {
      debugPrint('Error fetching API recipes: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  bool isRecipeFavorite(String recipeId) {
    return _favoriteRecipes.any((fav) => fav.recipeId == recipeId);
  }
  
  Future<void> fetchFavorites() async {
    if (_currentUser == null) return;
    // PERBAIKAN: Hapus '!' yang tidak perlu
    final favMaps = await _dbHelper.getFavorites(_currentUser.id!);
    _favoriteRecipes = favMaps.map((map) => Favorite.fromMap(map)).toList();
    notifyListeners();
  }
  
  Future<void> fetchAllUserRecipes() async {
    _allUserRecipes = await _dbHelper.getAllUserRecipes();
    notifyListeners();
  }

  Future<void> fetchUserRecipes() async {
    if (_currentUser == null) return;
    // PERBAIKAN: Hapus '!' yang tidak perlu
    _userRecipes = await _dbHelper.getUserRecipes(_currentUser.id!);
    notifyListeners();
  }

  Future<void> addApiRecipeToFavorites(Meal meal) async {
    if (_currentUser == null) return;
    final favorite = Favorite(
      recipeId: meal.idMeal,
      // PERBAIKAN: Hapus '!' yang tidak perlu
      userId: _currentUser.id!,
      isApiRecipe: true,
      title: meal.strMeal,
      imageUrl: meal.strMealThumb,
    );
    await _dbHelper.addFavorite(favorite);
    await fetchFavorites();
  }

  Future<void> addUserRecipeToFavorites(UserRecipe recipe) async {
    if (_currentUser == null) return;
    final favorite = Favorite(
      recipeId: recipe.id.toString(),
      // PERBAIKAN: Hapus '!' yang tidak perlu
      userId: _currentUser.id!,
      isApiRecipe: false,
      title: recipe.title,
      imageUrl: 'https://placehold.co/600x400/green/white?text=${recipe.title.substring(0,1)}',
    );
    await _dbHelper.addFavorite(favorite);
    await fetchFavorites();
  }

  Future<void> removeFavorite(String recipeId) async {
    if (_currentUser == null) return;
    // PERBAIKAN: Hapus '!' yang tidak perlu
    await _dbHelper.removeFavorite(recipeId, _currentUser.id!);
    await fetchFavorites();
  }

  Future<bool> isFavorite(String recipeId) async {
    if (_currentUser == null) return false;
    // PERBAIKAN: Hapus '!' yang tidak perlu
    return await _dbHelper.isFavorite(recipeId, _currentUser.id!);
  }

  Future<void> addUserRecipe(UserRecipe recipe) async {
    await _dbHelper.addUserRecipe(recipe);
    await fetchUserRecipes();
    await fetchAllUserRecipes();
  }

  Future<void> updateUserRecipe(UserRecipe recipe) async {
    await _dbHelper.updateUserRecipe(recipe);
    await fetchUserRecipes();
    await fetchAllUserRecipes();
  }

  Future<void> deleteUserRecipe(int id) async {
    await _dbHelper.deleteUserRecipe(id);
    await fetchUserRecipes();
    await fetchAllUserRecipes();
  }
}
