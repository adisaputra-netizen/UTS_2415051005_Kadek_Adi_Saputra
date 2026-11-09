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
    final noteProvider = context.watch<UserRecipeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Masak Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<UserRecipeProvider>().fetchUserNotes(),
          )
        ],
      ),
      body: Builder(
        builder: (context) {
          if (noteProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFC0392B)),
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
              message: 'Klik tombol + di bawah untuk mencatat pengalaman atau modifikasi resepmu.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: noteProvider.notes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final note = noteProvider.notes[index];

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                '${note.personalRating}/5',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(width: 8),
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
                              const SizedBox(width: 8),
                              // Tombol Hapus
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                                onPressed: () async {
                                  if (note.id == null) return;
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Hapus Catatan'),
                                      content: Text('Yakin ingin menghapus catatan "${note.recipeName}"?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx, false),
                                          child: const Text('Batal'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
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
                                          backgroundColor: success ? Colors.green : Colors.red,
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
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              note.category,
                              style: TextStyle(color: Colors.orange.shade900, fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tingkat: ${note.difficulty}',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        note.cookingNote,
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.3),
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
        backgroundColor: const Color(0xFFC0392B),
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