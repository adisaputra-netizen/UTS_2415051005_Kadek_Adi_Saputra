import '../models/balinese_recipe.dart';
import '../services/api_service.dart';

class RecipeRepository {
  final ApiService apiService;

  RecipeRepository(this.apiService);

  Future<List<BalineseRecipe>> getRecipes() async {
    return await apiService.fetchRecipes();
  }
}