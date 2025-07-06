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
  Map<String, UserRecipe> _userRecipeMap = {};
  Map<String, UserRecipe> get userRecipeMap => _userRecipeMap;

  Future<void> fetchApiRecipes() async {
    _isLoading = true;
    notifyListeners();
    _apiRecipes = await _apiService.fetchIndonesianRecipes();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchApiRecipes(String query) async {
    _isLoading = true;
    notifyListeners();
    _apiRecipes = await _apiService.searchRecipes(query);
    _isLoading = false;
    notifyListeners();
  }

  bool isRecipeFavorite(String recipeId) {
    return _favoriteRecipes.any((fav) => fav.recipeId == recipeId);
  }
  
  Future<void> fetchFavorites() async {
    if (_currentUser == null) return;
    final favMaps = await _dbHelper.getFavorites(_currentUser.id!);
    _favoriteRecipes = favMaps.map((map) => Favorite.fromMap(map)).toList();
    notifyListeners();
  }
  
  Future<void> fetchAllUserRecipes() async {
    _allUserRecipes = await _dbHelper.getAllUserRecipes();
    _userRecipeMap = { for (var recipe in _allUserRecipes) recipe.id.toString(): recipe };
    notifyListeners();
  }

  Future<void> fetchUserRecipes() async {
    if (_currentUser == null) return;
    _userRecipes = await _dbHelper.getUserRecipes(_currentUser.id!);
    notifyListeners();
  }

  Future<void> addApiRecipeToFavorites(Meal meal) async {
    if (_currentUser == null) return;
    final favorite = Favorite(
      recipeId: meal.idMeal,
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
      userId: _currentUser.id!,
      isApiRecipe: false,
      title: recipe.title,
      imageUrl: recipe.imageUrl ?? '',
    );
    await _dbHelper.addFavorite(favorite);
    await fetchFavorites();
  }

  Future<void> removeFavorite(String recipeId) async {
    if (_currentUser == null) return;
    await _dbHelper.removeFavorite(recipeId, _currentUser.id!);
    await fetchFavorites();
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