import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/balinese_recipe.dart';
import '../providers/recipe_provider.dart';
import '../widgets/responsive_recipe_grid.dart';
import '../widgets/state_feedback_widget.dart';
import 'recipe_detail_screen.dart';
import 'add_recipe_note_screen.dart';
import 'saved_recipes_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _categories = const [
    'Semua',
    'Olahan Ayam',
    'Sate & Lilit',
    'Sayur & Lawar',
    'Sambal Autentik',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryTerracotta = Color(0xFF8D3028);
    const textEspresso = Color(0xFF302923);
    const accentGold = Color(0xFFD5A34A);
    const secondaryHerbal = Color(0xFF526B45);
    const cardSurface = Color(0xFFFFFDF9);

    final recipeProvider = context.watch<RecipeProvider>();

    // Filter berdasarkan kategori provider dan search query lokal
    List<BalineseRecipe> displayedRecipes = recipeProvider.recipes;
    if (_searchQuery.isNotEmpty) {
      displayedRecipes = displayedRecipes.where((r) {
        final q = _searchQuery.toLowerCase();
        return r.name.toLowerCase().contains(q) ||
            r.category.toLowerCase().contains(q) ||
            r.description.toLowerCase().contains(q);
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Resep Bali'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_rounded, color: primaryTerracotta),
            tooltip: 'Resep yang Disukai',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SavedRecipesScreen(initialTabIndex: 0),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat ulang resep',
            onPressed: () => recipeProvider.fetchRecipesFromApi(),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. SEARCH BAR AKTIF
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: cardSurface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: primaryTerracotta.withValues(alpha: 0.18)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.trim();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Cari resep makanan khas Bali...',
                  hintStyle: TextStyle(
                    color: textEspresso.withValues(alpha: 0.45),
                    fontSize: 13.5,
                  ),
                  prefixIcon: const Icon(Icons.search_rounded, color: primaryTerracotta, size: 22),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18, color: primaryTerracotta),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // 2. KATEGORI FILTER CHIPS
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = recipeProvider.selectedCategory.toLowerCase() == cat.toLowerCase();

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) {
                      recipeProvider.setCategory(cat);
                    },
                    selectedColor: primaryTerracotta,
                    backgroundColor: cardSurface,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : textEspresso,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? primaryTerracotta : primaryTerracotta.withValues(alpha: 0.18),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    showCheckmark: false,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),

          // 3. DAFTAR RESEP (LOADING, ERROR, EMPTY, DATA)
          Expanded(
            child: Builder(
              builder: (context) {
                // 1. Loading State
                if (recipeProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: primaryTerracotta),
                  );
                }

                // 2. Error State
                if (recipeProvider.errorMessage.isNotEmpty) {
                  return StateFeedbackWidget(
                    icon: Icons.cloud_off_rounded,
                    title: 'Koneksi Terkendala',
                    message: recipeProvider.errorMessage,
                    onRetry: () => recipeProvider.fetchRecipesFromApi(),
                  );
                }

                // 3. Empty State
                if (displayedRecipes.isEmpty) {
                  return StateFeedbackWidget(
                    icon: Icons.search_off_rounded,
                    title: 'Resep Tidak Ditemukan',
                    message: _searchQuery.isNotEmpty
                        ? 'Tidak ada resep dengan kata kunci "$_searchQuery".'
                        : 'Belum ada resep untuk kategori ${recipeProvider.selectedCategory}.',
                    onRetry: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                      recipeProvider.setCategory('Semua');
                      recipeProvider.fetchRecipesFromApi();
                    },
                  );
                }

                // 4. Data State: Responsive Grid Kartu Horizontal
                return ResponsiveRecipeGrid(
                  itemCount: displayedRecipes.length,
                  mainAxisExtent: 124.0,
                  itemBuilder: (context, index) {
                    final recipe = displayedRecipes[index];
                    final isFav = recipeProvider.isFavorite(recipe.id);

                    return InkWell(
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
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: cardSurface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: primaryTerracotta.withValues(alpha: 0.12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Foto Makanan di Sebelah Kiri
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: SizedBox(
                                width: 90,
                                height: 90,
                                child: Image.network(
                                  recipe.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Container(
                                    color: const Color(0xFFEADBC8),
                                    child: const Icon(
                                      Icons.restaurant_menu,
                                      color: primaryTerracotta,
                                      size: 32,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Informasi di Sebelah Kanan Foto
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Judul Resep (bold, ukuran 16, #302923)
                                  Text(
                                    recipe.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.5,
                                      color: textEspresso,
                                    ),
                                  ),
                                  const SizedBox(height: 5),

                                  // Badge Kategori Kapsul Herbal Green
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                                    decoration: BoxDecoration(
                                      color: secondaryHerbal.withValues(alpha: 0.16),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: secondaryHerbal.withValues(alpha: 0.35),
                                      ),
                                    ),
                                    child: Text(
                                      recipe.category,
                                      style: const TextStyle(
                                        color: secondaryHerbal,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // Waktu Memasak & Rating Bintang
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.schedule,
                                        size: 13,
                                        color: textEspresso.withValues(alpha: 0.6),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Waktu: ${recipe.cookingTime} menit',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: textEspresso.withValues(alpha: 0.65),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(Icons.star_rounded, size: 15, color: accentGold),
                                      const SizedBox(width: 2),
                                      const Text(
                                        '4.9',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: textEspresso,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Aksi Cepat di Ujung Kanan (Bookmark & Favorit)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    recipeProvider.toggleFavorite(recipe.id);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(
                                      isFav ? Icons.favorite : Icons.favorite_border,
                                      color: isFav ? Colors.redAccent : textEspresso.withValues(alpha: 0.4),
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddRecipeNoteScreen(
                                          recipeName: recipe.name,
                                          initialCategory: recipe.category,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.bookmark_add_outlined,
                                      color: primaryTerracotta,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
