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
        'description': 'Ayam utuh dengan bumbu rempah base genep pekat yang dipanggang atau dikukus lambat hingga bumbu meresap ke serat daging.',
        'ingredients': [
          '1 ekor ayam utuh (ayam kampung lebih disarankan)',
          '10 butir bawang merah & 6 siung bawang putih',
          '15 buah cabai rawit merah & 5 cabai merah besar',
          '4 rimpang khas Bali: 3 cm lengkuas (isen), 3 cm kunyit bakar, 2 cm jahe, 2 cm kencur (cekuh)',
          '4 butir kemiri sangrai & 1 sdm ketumbar bubuk',
          '1/2 sdt merica hitam & 1/2 sdt terasi bakar khas Bali',
          '3 batang serai (memarkan) & 4 lembar daun salam',
          '3 sdm minyak kelapa asli (lengis tandusan)',
          '1 sdt garam & 1 sdt gula aren',
          'Daun pisang secukupnya untuk membungkus'
        ],
        'steps': [
          'Cincang halus atau ulek kasar bawang merah, bawang putih, cabai, serta 4 rimpang (lengkuas, kunyit, jahe, kencur).',
          'Sangrai kemiri, ketumbar, dan merica, lalu haluskan bersama terasi bakar.',
          'Campurkan semua bumbu halus dengan minyak kelapa asli, garam, dan gula aren.',
          'Lumuri seluruh badan ayam (luar dan rongga dalam) dengan bumbu rempah sambil dipijat perlahan.',
          'Masukkan batang serai dan daun salam ke dalam rongga perut ayam.',
          'Bungkus ayam rapat-rapat dengan beberapa lapis daun pisang.',
          'Kukus selama 60–90 menit dengan api sedang, lalu panggang sebentar di atas wajan/oven hingga aromanya keluar sempurna.'
        ]
      },
      {
        'id': 'rec_02',
        'name': 'Sate Lilit Ikan Khas Bali',
        'category': 'Sate & Lilit',
        'description': 'Daging ikan giling berpadu kelapa parut dan bumbu base genep wangi yang dililitkan pada batang serai segar.',
        'ingredients': [
          '500 gram fillet ikan tenggiri / tongkol (haluskan)',
          '150 gram kelapa parut setengah tua (kupas kulit ari)',
          'Bumbu Halus Base Genep: 8 bawang merah, 4 bawang putih, 2 cm kunyit bakar, 2 cm kencur, 2 cm lengkuas, 1 cm jahe',
          '6 buah cabai rawit merah (cincang halus)',
          '1 sdt ketumbar sangrai bubuk & 1/2 sdt terasi bakar',
          '2 lembar daun jeruk purut (buang tulang, iris sangat halus)',
          '1 sdm santan kental & 1 sdm gula merah sisir',
          '1 sdt garam & 1/2 sdt kaldu jamur',
          '12–15 batang serai segar (sebagai tusuk sate)'
        ],
        'steps': [
          'Tumis bumbu halus base genep hingga matang dan keluar aroma harumnya, lalu dinginkan sejenak.',
          'Campurkan daging ikan giling, kelapa parut, irisan daun jeruk, dan bumbu tumis ke dalam satu wadah.',
          'Tuangkan santan kental, gula merah, dan garam. Uleni adonan hingga kalis dan padat (bisa menempel).',
          'Ambil satu kepalan kecil adonan, lilitkan dan rekatkan pada ujung batang serai.',
          'Panggang di atas grill pan atau bara arang dengan api sedang sambil dibalik hingga matang kecokelatan merata.'
        ]
      },
      {
        'id': 'rec_03',
        'name': 'Lawar Kacang Panjang Bali',
        'category': 'Sayur & Lawar',
        'description': 'Sayuran segar renyah berpadu gurihnya kelapa parut bakar dan siraman bumbu base genep tumis.',
        'ingredients': [
          '250 gram kacang panjang muda (cuci bersih, potong 0.5 cm)',
          '100 gram kelapa setengah tua (bakar di atas bara, lalu parut kasar)',
          'Bumbu Base Genep Tumis: 6 bawang merah, 3 bawang putih, 2 cm kencur, 2 cm lengkuas, 1 cm kunyit, 5 cabai rawit',
          '1/2 sdt terasi bakar & 1/2 sdt ketumbar bubuk',
          '2 sdm minyak kelapa asli untuk menumis',
          '1 buah jeruk limau / lemo (ambil air perasannya)',
          '1 sdt garam & bawang goreng renyah untuk taburan'
        ],
        'steps': [
          'Didihkan air dengan sedikit garam, rebus kacang panjang selama 1–2 menit (cukup sampai layu renyah), lalu tiriskan.',
          'Ulek halus bumbu base genep dan terasi, lalu tumis dengan minyak kelapa sampai harum dan matang.',
          'Dalam wadah bersih, campurkan kacang panjang rebus dan kelapa bakar parut.',
          'Masukkan bumbu tumis base genep dan garam, aduk serta remas perlahan menggunakan sarung tangan hingga bumbu tercampur rata.',
          'Beri perasan air jeruk limau untuk sensasi segar, lalu taburi dengan bawang merah goreng.'
        ]
      },
      {
        'id': 'rec_04',
        'name': 'Sambal Matah Khas Bali',
        'category': 'Sambal Autentik',
        'description': 'Sambal mentah iris segar dengan perpaduan serai, bawang merah, cabai, dan siraman minyak kelapa mendidih.',
        'ingredients': [
          '12 butir bawang merah segar (kupas, iris tipis merata)',
          '10 buah cabai rawit merah (iris tipis bulat)',
          '4 batang serai (ambil hanya bagian putih tengahnya, iris sangat tipis)',
          '3 lembar daun jeruk (buang tulang tengahnya, iris tipis helai rambut)',
          '1/2 sdt terasi bakar berkualitas (haluskan)',
          '1/2 sdt garam & 1/4 sdt gula pasir',
          '4 sdm minyak kelapa asli (lengis tandusan) panas mendidih',
          '1 buah jeruk limau / lemo'
        ],
        'steps': [
          'Campurkan irisan bawang merah, cabai rawit, serai putih, dan daun jeruk ke dalam mangkuk tahan panas.',
          'Tambahkan terasi bakar halus, garam, dan gula pasir.',
          'Remas-remas perlahan menggunakan sendok atau tangan beralas plastik agar aroma alaminya keluar.',
          'Panaskan minyak kelapa hingga benar-benar panas mendidih, lalu langsung siramkan ke dalam campuran sambal.',
          'Aduk rata dan beri perasan air jeruk limau sebelum disajikan.'
        ]
      },
      {
        'id': 'rec_05',
        'name': 'Jukut Ares Tulang Ayam/Bebek',
        'category': 'Sayur & Lawar',
        'description': 'Sup kuah hangat tradisional dari batang pohon pisang muda yang dimasak bersama kaldu dan bumbu base genep.',
        'ingredients': [
          '1 batang pohon pisang muda (ares) bagian dalam yang putih empuk',
          '300 gram tulang ayam / bebek untuk kaldu gurih',
          'Bumbu Base Genep Halus: 8 bawang merah, 5 bawang putih, 3 cm kunyit, 3 cm lengkuas, 2 cm jahe, 2 cm kencur, 7 cabai rawit',
          '1 sdt ketumbar, 1/2 sdt lada hitam, 1/2 sdt terasi bakar',
          '2 batang serai & 3 lembar daun salam',
          '1.5 liter air bersih',
          '2 sdt garam & 1 sdm minyak kelapa untuk menumis'
        ],
        'steps': [
          'Iris tipis batang ares, taburi 2 sdm garam lalu remas-remas kuat hingga getahnya keluar dan batang lemas, kemudian bilas air bersih 2–3 kali.',
          'Rebus tulang ayam/bebek dalam 1.5 liter air hingga keluar kaldunya yang gurih.',
          'Tumis bumbu halus base genep bersama serai dan daun salam hingga harum.',
          'Tuang bumbu tumis ke dalam panci rebusan kaldu tulang.',
          'Masukkan irisan batang ares, bumbui dengan garam dan sedikit gula, lalu masak dengan api sedang hingga batang ares empuk dan bumbu meresap.'
        ]
      },
      {
        'id': 'rec_06',
        'name': 'Sate Plecing Singaraja',
        'category': 'Sate & Lilit',
        'description': 'Sate daging panggang empuk dengan siraman bumbu plecing tomat terasi yang pedas asam gurih.',
        'ingredients': [
          '400 gram daging sapi/ayam (potong dadu 2 cm)',
          'Bumbu Marinasi Sate: 3 siung bawang putih cincang, 1 sdm ketumbar bubuk, 2 sdm kecap manis, 1 sdm minyak kelapa',
          'Bumbu Sambal Plecing: 8 buah cabai rawit merah, 2 buah tomat merah masak, 1 siung bawang putih, 1/2 sdt terasi bakar khas Bali',
          '1/2 sdt garam & 1/2 sdt gula merah sisir',
          '1 buah jeruk limau'
        ],
        'steps': [
          'Campur potongan daging dengan bumbu marinasi, diamkan minimal 20 menit agar meresap.',
          'Tusuk daging ke tusukan sate (3–4 potong per tusuk).',
          'Rebus cabai, tomat, dan bawang putih sebentar, lalu ulek halus bersama terasi bakar, garam, dan gula merah.',
          'Beri perasan jeruk limau pada sambal plecing yang sudah diulek.',
          'Bakar sate di atas bara api hingga matang dan kecokelatan.',
          'Sajikan sate hangat dengan siraman sambal plecing pedas di atasnya.'
        ]
      }
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