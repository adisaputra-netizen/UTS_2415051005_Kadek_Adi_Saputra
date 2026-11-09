import 'package:flutter/material.dart';
import 'add_recipe_note_screen.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    final String name = recipe['name'] ?? 'Resep Bali';
    final String category = recipe['category'] ?? 'Umum';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Gambar / Banner Placeholder
            Container(
              height: 220,
              width: double.infinity,
              color: Colors.orange.shade100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.restaurant_menu, size: 70, color: Color(0xFFC0392B)),
                  const SizedBox(height: 8),
                  Text(
                    category,
                    style: const TextStyle(
                      color: Color(0xFFC0392B),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.4),
                  ),
                  const Divider(height: 32),

                  // Bagian Bahan-Bahan
                  const Text(
                    'Bahan & Bumbu Base Genep',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...ingredients.map(
                    (ing) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(child: Text(ing, style: const TextStyle(fontSize: 14))),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 32),

                  // Bagian Langkah Memasak
                  const Text(
                    'Cara Memasak',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...steps.asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 11,
                            backgroundColor: const Color(0xFFC0392B),
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(fontSize: 11, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(entry.value, style: const TextStyle(fontSize: 14))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Tombol Aksi: Tambah Catatan Masak
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC0392B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddRecipeNoteScreen(recipeName: name),
                          ),
                        );
                      },
                      icon: const Icon(Icons.note_add_outlined),
                      label: const Text('Buat Catatan Masak Pribadi', style: TextStyle(fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}