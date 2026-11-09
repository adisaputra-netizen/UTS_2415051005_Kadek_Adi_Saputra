import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../widgets/responsive_recipe_grid.dart';
import '../widgets/state_feedback_widget.dart';
import 'recipe_detail_screen.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeProvider = context.watch<RecipeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Resep Bali (API)'),
      ),
      body: Builder(
        builder: (context) {
          // 1. Loading State
          if (recipeProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFC0392B)),
            );
          }

          // 2. Error State
          if (recipeProvider.errorMessage.isNotEmpty) {
            return StateFeedbackWidget(
              icon: Icons.cloud_off_rounded,
              title: 'Koneksi Terkendala',
              message: recipeProvider.errorMessage,
              onRetry: () => context.read<RecipeProvider>().fetchRecipesFromApi(),
            );
          }

          // 3. Empty State
          if (recipeProvider.recipes.isEmpty) {
            return StateFeedbackWidget(
              icon: Icons.inventory_2_outlined,
              title: 'Resep Tidak Ditemukan',
              message: 'Belum ada resep untuk kategori terpilih.',
              onRetry: () => context.read<RecipeProvider>().fetchRecipesFromApi(),
            );
          }

          // 4. Data State
          return ResponsiveRecipeGrid(
            itemCount: recipeProvider.recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipeProvider.recipes[index];
              final isFav = recipeProvider.isFavorite(recipe.id);

              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailScreen(
                          recipe: recipe.toJson(),
                        ),
                      ),
                    );
                  },
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 52,
                      height: 52,
                      child: Image.network(
                        recipe.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.red.shade50,
                          child: const Icon(Icons.restaurant_menu, color: Color(0xFFC0392B)),
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    recipe.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${recipe.category} • ${recipe.cookingTime} Menit'),
                  trailing: IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      context.read<RecipeProvider>().toggleFavorite(recipe.id);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}