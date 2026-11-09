import 'package:flutter/foundation.dart';
import '../models/balinese_recipe.dart';
import '../repositories/recipe_repository.dart';

class RecipeProvider with ChangeNotifier {
  final RecipeRepository repository;

  List<BalineseRecipe> _allRecipes = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedCategory = 'Semua';
  final Set<String> _favoriteRecipeIds = {};

  RecipeProvider({required this.repository});

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  Set<String> get favoriteRecipeIds => _favoriteRecipeIds;

  List<BalineseRecipe> get recipes {
    if (_selectedCategory == 'Semua') {
      return _allRecipes;
    }
    return _allRecipes
        .where((r) => r.category.toLowerCase() == _selectedCategory.toLowerCase())
        .toList();
  }

  bool isFavorite(String id) => _favoriteRecipeIds.contains(id);

  void toggleFavorite(String id) {
    if (_favoriteRecipeIds.contains(id)) {
      _favoriteRecipeIds.remove(id);
    } else {
      _favoriteRecipeIds.add(id);
    }
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Integrasi pemanggilan REST API melalui Repository
  Future<void> fetchRecipesFromApi() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _allRecipes = await repository.getRecipes();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}