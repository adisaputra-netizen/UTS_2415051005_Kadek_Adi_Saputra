import 'package:flutter/material.dart';
import '../widgets/responsive_recipe_grid.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk memvalidasi fungsi responsive sebelum integrasi REST API
    final List> dummyList = [
      {'name': 'Ayam Betutu Gilimanuk', 'category': 'Olahan Ayam'},
      {'name': 'Sate Lilit Ikan', 'category': 'Sate & Lilit'},
      {'name': 'Lawar Bali Campur', 'category': 'Sayur & Lawar'},
      {'name': 'Sambal Matah Khas Bali', 'category': 'Sambal Autentik'},
      {'name': 'Jukut Ares Tulang Bebek', 'category': 'Sayur & Lawar'},
      {'name': 'Sate Plecing Singaraja', 'category': 'Sate & Lilit'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Resep Bali'),
      ),
      body: ResponsiveRecipeGrid(
        itemCount: dummyList.length,
        itemBuilder: (context, index) {
          final item = dummyList[index];
          return Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.restaurant_menu, color: Color(0xFFC0392B)),
              ),
              title: Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item['category']!),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            ),
          );
        },
      ),
    );
  }
}