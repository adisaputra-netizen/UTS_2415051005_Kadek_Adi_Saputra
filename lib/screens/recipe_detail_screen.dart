import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import 'add_recipe_note_screen.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    const primaryTerracotta = Color(0xFF8D3028);
    const textEspresso = Color(0xFF302923);
    const secondaryHerbal = Color(0xFF526B45);
    const cardSurface = Color(0xFFFFFDF9);
    const bgWarmCream = Color(0xFFF4EBDD);

    final String recipeId = recipe['id']?.toString() ?? '';
    final String name = recipe['name'] ?? 'Resep Bali';
    final String category = recipe['category'] ?? 'Umum';
    final int cookingTime = (recipe['cooking_time'] ?? recipe['cookingTime'] ?? 45) as int;
    final String imageUrl = recipe['image_url'] ?? recipe['imageUrl'] ?? '';
    final String description = recipe['description'] ??
        'Resep autentik khas Bali dengan perpaduan rempah bumbu base genep yang kaya rasa.';
    final List<String> ingredients = List<String>.from(recipe['ingredients'] ?? [
          'Daging atau bahan utama pilihan',
          'Bumbu Base Genep (bawang merah, putih, cabai, kencur, jahe, lengkuas, kunyit)',
          'Garam, gula aren, dan minyak kelapa asli',
          'Daun salam dan serai segar'
        ]);
    final List<String> steps = List<String>.from(recipe['steps'] ?? [
          'Haluskan semua rempah base genep sampai merata.',
          'Tumis bumbu dengan sedikit minyak kelapa hingga harum semerbak.',
          'Campurkan bumbu ke bahan utama dan masak hingga bumbu meresap sempurna.',
          'Sajikan selagi hangat bersama nasi putih dan sambal matah.'
        ]);

    final provider = context.watch<RecipeProvider>();
    final bool isFav = recipeId.isNotEmpty && provider.isFavorite(recipeId);

    return Scaffold(
      backgroundColor: bgWarmCream,
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.redAccent : primaryTerracotta,
            ),
            onPressed: () {
              if (recipeId.isNotEmpty) {
                provider.toggleFavorite(recipeId);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER GAMBAR MAKANAN
            Container(
              height: 230,
              width: double.infinity,
              color: const Color(0xFF2C1810),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _buildImagePlaceholder(primaryTerracotta, category),
                    )
                  : _buildImagePlaceholder(primaryTerracotta, category),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul dan Kategori Badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textEspresso,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: secondaryHerbal.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: secondaryHerbal.withValues(alpha: 0.35)),
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            color: secondaryHerbal,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 16, color: textEspresso.withValues(alpha: 0.6)),
                      const SizedBox(width: 4),
                      Text(
                        'Waktu Memasak: $cookingTime Menit',
                        style: TextStyle(
                          fontSize: 13,
                          color: textEspresso.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: textEspresso.withValues(alpha: 0.8),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 2. TIGA TOMBOL AKSI SEKUNDER (SIMPAN, FAVORIT, BAGIKAN)
                  Row(
                    children: [
                      _buildSecondaryActionButton(
                        context: context,
                        icon: Icons.bookmark_add_outlined,
                        label: 'Simpan',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddRecipeNoteScreen(
                                recipeName: name,
                                initialCategory: category,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      _buildSecondaryActionButton(
                        context: context,
                        icon: isFav ? Icons.favorite : Icons.favorite_border,
                        iconColor: isFav ? Colors.redAccent : primaryTerracotta,
                        label: 'Favorit',
                        onTap: () {
                          if (recipeId.isNotEmpty) {
                            provider.toggleFavorite(recipeId);
                          }
                        },
                      ),
                      const SizedBox(width: 10),
                      _buildSecondaryActionButton(
                        context: context,
                        icon: Icons.share_outlined,
                        label: 'Bagikan',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Tautan resep "$name" telah disalin ke papan klip!'),
                              backgroundColor: primaryTerracotta,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 3. KARTU BAHAN & BUMBU
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: primaryTerracotta.withValues(alpha: 0.12)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.inventory_2_outlined, color: primaryTerracotta, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Bahan & Bumbu Base Genep',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textEspresso,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...ingredients.map(
                          (ing) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle_outline, size: 17, color: secondaryHerbal),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    ing,
                                    style: const TextStyle(fontSize: 13.5, color: textEspresso),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 4. KARTU LANGKAH MEMASAK
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: primaryTerracotta.withValues(alpha: 0.12)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.format_list_numbered_rounded, color: primaryTerracotta, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Cara Memasak',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textEspresso,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...steps.asMap().entries.map(
                          (entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 11,
                                  backgroundColor: primaryTerracotta,
                                  child: Text(
                                    '${entry.key + 1}',
                                    style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    entry.value,
                                    style: const TextStyle(fontSize: 13.5, color: textEspresso, height: 1.35),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 5. TOMBOL UTAMA: BUAT CATATAN MASAK PRIBADI
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryTerracotta,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddRecipeNoteScreen(
                              recipeName: name,
                              initialCategory: category,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.note_add_outlined),
                      label: const Text(
                        'Buat Catatan Masak Pribadi',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(Color color, String category) {
    return Container(
      color: const Color(0xFFEADBC8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 64, color: color),
            const SizedBox(height: 6),
            Text(
              category,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    const primaryTerracotta = Color(0xFF8D3028);
    const textEspresso = Color(0xFF302923);
    const cardSurface = Color(0xFFFFFDF9);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: cardSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: primaryTerracotta.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor ?? primaryTerracotta, size: 20),
              const SizedBox(height: 3),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: textEspresso,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
