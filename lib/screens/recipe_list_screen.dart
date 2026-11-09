import 'package:flutter/material.dart';
import '../widgets/responsive_recipe_grid.dart';
import 'recipe_detail_screen.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dummyList = [
      {
        'id': 'rec_01',
        'name': 'Ayam Betutu Gilimanuk',
        'category': 'Olahan Ayam',
        'description': 'Ayam dengan bumbu base genep lengkap yang dipanggang lambat hingga daging sangat empuk.',
        'ingredients': ['1 ekor ayam utuh', 'Bumbu base genep lengkap', 'Daun pisang pembungkus', 'Minyak kelapa asli'],
        'steps': ['Haluskan bumbu base genep.', 'Balurkan ke seluruh ayam.', 'Bungkus rapat daun pisang.', 'Kukus dan panggang lambat.']
      },
      {
        'id': 'rec_02',
        'name': 'Sate Lilit Ikan',
        'category': 'Sate & Lilit',
        'description': 'Daging ikan tenggiri giling berbumbu rempah wangi dililitkan pada batang serai segar.',
        'ingredients': ['500g fillet ikan cincang', 'Bumbu base genep wangi', 'Kelapa parut muda', 'Batang serai untuk tusuk'],
        'steps': ['Campur daging ikan, kelapa, dan bumbu.', 'Lilitkan adonan ke batang serai.', 'Panggang di atas bara arang hingga matang harum.']
      },
      {
        'id': 'rec_03',
        'name': 'Lawar Bali Campur',
        'category': 'Sayur & Lawar',
        'description': 'Sayuran kacang panjang dan kelapa parut bakar berpadu dengan bumbu base genep khas Bali.',
        'ingredients': ['Kacang panjang iris halus', 'Kelapa parut bakar', 'Bumbu base genep tumis', 'Bawang goreng dan jeruk limau'],
        'steps': ['Rebus sebentar kacang panjang.', 'Campur kacang panjang dengan kelapa bakar dan bumbu.', 'Beri perasan jeruk limau dan aduk rata.']
      },
      {
        'id': 'rec_04',
        'name': 'Sambal Matah Khas Bali',
        'category': 'Sambal Autentik',
        'description': 'Sambal mentah iris segar dengan kombinasi bawang merah, cabai rawit, serai, dan minyak kelapa panas.',
        'ingredients': ['Bawang merah iris', 'Cabai rawit merah iris', 'Batang serai bagian putih', 'Terasi bakar & garam', 'Minyak kelapa panas', 'Jeruk limau'],
        'steps': ['Iris tipis semua bahan mentah.', 'Campur bahan ke dalam wadah dan remas perlahan bersama garam & terasi.', 'Siram dengan minyak kelapa mendidih.', 'Kucuri air jeruk limau.']
      },
      {
        'id': 'rec_05',
        'name': 'Jukut Ares Tulang Bebek',
        'category': 'Sayur & Lawar',
        'description': 'Sup berkuah hangat dari batang pohon pisang muda yang dimasak lambat bersama kaldu tulang bebek.',
        'ingredients': ['Batang pisang muda (ares) diiris tipis', 'Tulang bebek/ayam', 'Base genep lengkap', 'Air kaldu'],
        'steps': ['Remas irisan ares dengan garam dan cuci bersih.', 'Rebus kaldu bersama tulang.', 'Masukkan bumbu tumis dan ares, masak hingga lembut.']
      },
      {
        'id': 'rec_06',
        'name': 'Sate Plecing Singaraja',
        'category': 'Sate & Lilit',
        'description': 'Sate daging bakar empuk yang disajikan dengan siraman sambal plecing pedas gurih khas Singaraja.',
        'ingredients': ['Daging sapi/ayam potong dadu', 'Bumbu marinasi ketumbar dan bawang', 'Sambal plecing tomat terasi'],
        'steps': ['Tusuk daging dan bakar hingga setengah matang.', 'Olesi bumbu dan bakar hingga matang.', 'Sajikan dengan siraman sambal plecing pedas.']
      },
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
              onTap: () {
                // Navigasi List -> Detail dengan Passing Data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailScreen(recipe: item),
                  ),
                );
              },
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