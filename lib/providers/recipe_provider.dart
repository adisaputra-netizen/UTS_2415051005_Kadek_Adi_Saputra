import 'package:flutter/foundation.dart';
import '../models/balinese_recipe.dart';

class RecipeProvider with ChangeNotifier {
  List<BalineseRecipe> _allRecipes = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedCategory = 'Semua';
  final Set<String> _favoriteRecipeIds = {};

  // Getter
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  Set<String> get favoriteRecipeIds => _favoriteRecipeIds;

  // Filter resep berdasarkan kategori aktif
  List<BalineseRecipe> get recipes {
    if (_selectedCategory == 'Semua') {
      return _allRecipes;
    }
    return _allRecipes
        .where((r) => r.category.toLowerCase() == _selectedCategory.toLowerCase())
        .toList();
  }

  // Cek apakah resep berstatus favorit
  bool isFavorite(String id) => _favoriteRecipeIds.contains(id);

  // Toggle status favorit (Shared State)
  void toggleFavorite(String id) {
    if (_favoriteRecipeIds.contains(id)) {
      _favoriteRecipeIds.remove(id);
    } else {
      _favoriteRecipeIds.add(id);
    }
    notifyListeners();
  }

  // Ubah kategori filter (Shared State)
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Inisialisasi data resep awal
  void setRecipes(List<BalineseRecipe> recipes) {
    _allRecipes = recipes;
    notifyListeners();
  }

  // Set status loading & error
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}