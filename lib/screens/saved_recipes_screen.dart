import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_recipe_provider.dart';
import '../widgets/state_feedback_widget.dart';
import 'add_recipe_note_screen.dart';
import 'edit_recipe_note_screen.dart';

class SavedRecipesScreen extends StatelessWidget {
  const SavedRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryTerracotta = Color(0xFF8D3028);
    const textEspresso = Color(0xFF302923);
    const accentGold = Color(0xFFD5A34A);
    const secondaryHerbal = Color(0xFF526B45);
    const cardSurface = Color(0xFFFFFDF9);

    final noteProvider = context.watch<UserRecipeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Masak Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat ulang catatan',
            onPressed: () => context.read<UserRecipeProvider>().fetchUserNotes(),
          )
        ],
      ),
      body: Builder(
        builder: (context) {
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
              onRetry: () => context.read<UserRecipeProvider>().fetchUserNotes(),
            );
          }

          if (noteProvider.notes.isEmpty) {
            return const StateFeedbackWidget(
              icon: Icons.note_alt_outlined,
              title: 'Belum Ada Catatan Resep',
              message: 'Klik tombol + di bawah untuk mencatat pengalaman atau modifikasi resep khas Bali pilihanmu.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: noteProvider.notes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
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
                              // Tombol Hapus
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.all(4),
                                icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                                onPressed: () async {
                                  if (note.id == null) return;
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      backgroundColor: cardSurface,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      title: const Text('Hapus Catatan', style: TextStyle(color: textEspresso)),
                                      content: Text('Yakin ingin menghapus catatan "${note.recipeName}"?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx, false),
                                          child: const Text('Batal'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () => Navigator.pop(ctx, true),
                                          child: const Text('Hapus'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true && context.mounted) {
                                    final success = await context.read<UserRecipeProvider>().deleteNote(note.id!);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            success
                                                ? 'Catatan berhasil dihapus dari database!'
                                                : 'Gagal menghapus: ${context.read<UserRecipeProvider>().errorMessage}',
                                          ),
                                          backgroundColor: success ? Colors.green.shade700 : Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
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
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryTerracotta,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
    );
  }
}
