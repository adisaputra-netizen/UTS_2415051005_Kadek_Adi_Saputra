import 'package:flutter/material.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Resep Bali'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text(
              'Daftar Resep Autentik Bali',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Data akan dihubungkan dengan REST API pada milestone berikutnya.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}