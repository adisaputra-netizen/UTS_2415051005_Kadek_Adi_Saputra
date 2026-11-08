import 'package:flutter/material.dart';

class SavedRecipesScreen extends StatelessWidget {
  const SavedRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Masak Saya'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border_rounded, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text(
              'Belum Ada Catatan Resep',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Fitur CRUD catatan resep terintegrasi dengan database Supabase.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}