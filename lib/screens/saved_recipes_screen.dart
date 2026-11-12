import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_recipe_note.dart';
import '../providers/recipe_provider.dart';
import '../providers/user_recipe_provider.dart';
import '../widgets/state_feedback_widget.dart';
import 'add_recipe_note_screen.dart';
import 'edit_recipe_note_screen.dart';
import 'recipe_detail_screen.dart';

class SavedRecipesScreen extends StatelessWidget {
  final int initialTabIndex;

  const SavedRecipesScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  // Fungsi dialog konfirmasi sebelum menghapus catatan masak dari Supabase
  void _confirmDelete(BuildContext context, UserRecipeNote note) {
    const primaryTerracotta = Color(0xFF8D3028);
    const textEspresso = Color(0xFF302923);

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFFDF9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: primaryTerracotta),
              SizedBox(width: 8),
              Text(
                'Hapus Catatan?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textEspresso,
                ),
              ),
            ],
          ),
          content: Text(
            'Apakah kamu yakin ingin menghapus catatan masak untuk "${note.recipeName}"? Tindakan ini tidak dapat dibatalkan.',
            style: const TextStyle(color: textEspresso),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryTerracotta,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                Navigator.pop(dialogCtx);

                if (note.id == null) return;

                final success = await context.read<UserRecipeProvider>().deleteNote(note.id!);

                if (!context.mounted) return;

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Catatan resep berhasil dihapus dari database.'),
                      backgroundColor: Color(0xFF526B45),
                    ),
                  );
                } else {
                  final error = context.read<UserRecipeProvider>().errorMessage;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menghapus: $error'),
                      backgroundColor: primaryTerracotta,
                    ),
                  );
                }
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryTerracotta = Color(0xFF8D3028);
    const bgWarmCream = Color(0xFFF4EBDD);
    const textEspresso = Color(0xFF302923);

    final recipeProvider = context.watch<RecipeProvider>();
    final noteProvider = context.watch<UserRecipeProvider>();

    return DefaultTabController(
      length: 2,
      initialIndex: initialTabIndex.clamp(0, 1),
      child: Scaffold(
        backgroundColor: bgWarmCream,
        appBar: AppBar(
          backgroundColor: bgWarmCream,
          elevation: 0,
          title: const Text(
            'Koleksi Disimpan',
            style: TextStyle(fontWeight: FontWeight.bold, color: textEspresso),
          ),
          bottom: TabBar(
            indicatorColor: primaryTerracotta,
            indicatorWeight: 3,
            labelColor: primaryTerracotta,
            unselectedLabelColor: textEspresso.withValues(alpha: 0.6),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 13.5),
            tabs: const [
              Tab(
                icon: Icon(Icons.favorite_rounded),
                text: 'Resep Disukai',
              ),
              Tab(
                icon: Icon(Icons.note_alt_rounded),
                text: 'Catatan Masak',
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: primaryTerracotta),
              tooltip: 'Muat ulang data',
              onPressed: () {
                recipeProvider.fetchRecipesFromApi();
                noteProvider.fetchUserNotes();
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // TAB 1: RESEP YANG DISUKAI
            _buildFavoriteRecipesTab(context, recipeProvider),

            // TAB 2: CATATAN MASAK (SUPABASE CRUD)
            _buildRecipeNotesTab(context, noteProvider),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryTerracotta,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          tooltip: 'Tambah Catatan Masak',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddRecipeNoteScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // Widget tampilan Tab 1: Resep Disukai
  Widget _buildFavoriteRecipesTab(BuildContext context, RecipeProvider recipeProvider) {
    const primaryTerracotta = Color(0xFF8D3028);
    const textEspresso = Color(0xFF302923);
    const accentGold = Color(0xFFD5A34A);
    const secondaryHerbal = Color(0xFF526B45);
    const cardSurface = Color(0xFFFFFDF9);

    final favorites = recipeProvider.favoriteRecipes;

    if (favorites.isEmpty) {
      return const StateFeedbackWidget(
        icon: Icons.favorite_border_rounded,
        title: 'Belum Ada Resep Disukai',
        message: 'Tekan ikon hati ❤️ pada resep di Beranda atau Katalog untuk menambahkannya ke koleksi favoritmu.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: favorites.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final recipe = favorites[index];

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailScreen(recipe: recipe.toJson()),
              ),
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cardSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: primaryTerracotta.withValues(alpha: 0.12)),
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
                // Foto Makanan
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 85,
                    height: 85,
                    child: Image.network(
                      recipe.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: const Color(0xFFEADBC8),
                        child: const Icon(Icons.restaurant_menu, color: primaryTerracotta, size: 30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Info Resep
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: textEspresso,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: secondaryHerbal.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
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
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 13, color: textEspresso.withValues(alpha: 0.6)),
                          const SizedBox(width: 4),
                          Text(
                            '${recipe.cookingTime} Menit',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: textEspresso.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.star_rounded, size: 15, color: accentGold),
                          const SizedBox(width: 2),
                          const Text(
                            '4.9',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: textEspresso,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Tombol Hapus dari Favorit
                IconButton(
                  icon: const Icon(Icons.favorite, color: primaryTerracotta, size: 24),
                  tooltip: 'Hapus dari resep disukai',
                  onPressed: () {
                    recipeProvider.toggleFavorite(recipe.id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget tampilan Tab 2: Catatan Masak Saya (Supabase CRUD)
  Widget _buildRecipeNotesTab(BuildContext context, UserRecipeProvider noteProvider) {
    const primaryTerracotta = Color(0xFF8D3028);
    const textEspresso = Color(0xFF302923);
    const accentGold = Color(0xFFD5A34A);
    const secondaryHerbal = Color(0xFF526B45);
    const cardSurface = Color(0xFFFFFDF9);

    if (noteProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: primaryTerracotta),
      );
    }

    if (noteProvider.errorMessage.isNotEmpty) {
      return StateFeedbackWidget(
        icon: Icons.error_outline,
        title: 'Gagal Memuat Catatan',
        message: noteProvider.errorMessage,
        onRetry: () => noteProvider.fetchUserNotes(),
      );
    }

    if (noteProvider.notes.isEmpty) {
      return const StateFeedbackWidget(
        icon: Icons.note_alt_outlined,
        title: 'Belum Ada Catatan Resep',
        message: 'Klik tombol + di bawah untuk mencatat kreasi atau tips bumbu resep khas Bali pilihanmu.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: noteProvider.notes.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final note = noteProvider.notes[index];

        return Container(
          decoration: BoxDecoration(
            color: cardSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: primaryTerracotta.withValues(alpha: 0.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        note.recipeName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textEspresso,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: accentGold, size: 20),
                        const SizedBox(width: 3),
                        Text(
                          '${note.personalRating}/5',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: textEspresso,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Tombol Edit
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(4),
                          icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.blueGrey),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditRecipeNoteScreen(note: note),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 4),
                        // Tombol Hapus (Delete)
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(4),
                          icon: const Icon(Icons.delete_outline, size: 20, color: primaryTerracotta),
                          onPressed: () => _confirmDelete(context, note),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: secondaryHerbal.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        note.category,
                        style: const TextStyle(
                          color: secondaryHerbal,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tingkat: ${note.difficulty}',
                      style: TextStyle(
                        color: textEspresso.withValues(alpha: 0.65),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  note.cookingNote,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: textEspresso.withValues(alpha: 0.85),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
