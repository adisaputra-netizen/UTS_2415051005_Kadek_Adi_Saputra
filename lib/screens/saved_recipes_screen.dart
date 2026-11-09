import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_recipe_note.dart';
import '../providers/user_recipe_provider.dart';
import '../widgets/state_feedback_widget.dart';
import 'add_recipe_note_screen.dart';
import 'edit_recipe_note_screen.dart';

class SavedRecipesScreen extends StatelessWidget {
  const SavedRecipesScreen({super.key});

  // Fungsi menampilkan dialog konfirmasi sebelum menghapus dari Supabase
  void _confirmDelete(BuildContext context, UserRecipeNote note) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFFDF9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFF8D3028)),
              SizedBox(width: 8),
              Text(
                'Hapus Catatan?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF302923),
                ),
              ),
            ],
          ),
          content: Text(
            'Apakah kamu yakin ingin menghapus catatan masak untuk "${note.recipeName}"? Tindakan ini tidak dapat dibatalkan.',
            style: const TextStyle(color: Color(0xFF302923)),
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
                backgroundColor: const Color(0xFF8D3028),
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
                      backgroundColor: const Color(0xFF8D3028),
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
    final noteProvider = context.watch<UserRecipeProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4EBDD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4EBDD),
        elevation: 0,
        title: const Text(
          'Catatan Masak Saya',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF302923)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF8D3028)),
            onPressed: () => context.read<UserRecipeProvider>().fetchUserNotes(),
          )
        ],
      ),
      body: Builder(
        builder: (context) {
          if (noteProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF8D3028)),
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
              message: 'Klik tombol + di bawah untuk mencatat kreasi atau tips bumbu resepmu.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: noteProvider.notes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final note = noteProvider.notes[index];

              return Card(
                color: const Color(0xFFFFFDF9),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: Colors.brown.shade100, width: 0.8),
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
                                color: Color(0xFF302923),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Color(0xFFD5A34A), size: 18),
                              const SizedBox(width: 4),
                              Text(
                                '${note.personalRating}/5',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color(0xFF302923),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Tombol Edit
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
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
                              const SizedBox(width: 12),
                              // Tombol Hapus (Delete)
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.delete_outline, size: 20, color: Color(0xFF8D3028)),
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
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF526B45).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              note.category,
                              style: const TextStyle(
                                color: Color(0xFF526B45),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tingkat: ${note.difficulty}',
                            style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        note.cookingNote,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF302923),
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
        backgroundColor: const Color(0xFF8D3028),
        foregroundColor: Colors.white,
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