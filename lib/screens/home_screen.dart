import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/balinese_recipe.dart';
import '../providers/recipe_provider.dart';
import 'recipe_detail_screen.dart';
import 'add_recipe_note_screen.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int>? onNavigateToTab;

  const HomeScreen({super.key, this.onNavigateToTab});

  // Data fallback jika API belum selesai memuat
  static final List<BalineseRecipe> _fallbackRecipes = [
    BalineseRecipe(
      id: 'rec_01',
      name: 'Ayam Betutu Gilimanuk',
      category: 'Olahan Ayam',
      difficulty: 'Sedang',
      cookingTime: 90,
      imageUrl: 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?q=80&w=800&auto=format&fit=crop',
      ingredients: ['1 ekor ayam utuh', 'Bumbu Base Genep', 'Daun pisang pembungkus'],
      steps: ['Haluskan bumbu base genep.', 'Balurkan ke seluruh ayam.', 'Kukus dan panggang lambat.'],
      description: 'Ayam dengan bumbu base genep lengkap yang dipanggang lambat hingga daging sangat empuk.',
    ),
    BalineseRecipe(
      id: 'rec_02',
      name: 'Sate Lilit Ikan Khas Bali',
      category: 'Sate & Lilit',
      difficulty: 'Mudah',
      cookingTime: 35,
      imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=800&auto=format&fit=crop',
      ingredients: ['500g fillet ikan tenggiri', 'Kelapa parut', 'Batang serai untuk tusuk'],
      steps: ['Campur daging ikan, kelapa, dan bumbu.', 'Lilitkan adonan ke batang serai.', 'Panggang hingga harum.'],
      description: 'Daging ikan tenggiri giling berbumbu rempah wangi dililitkan pada batang serai segar.',
    ),
    BalineseRecipe(
      id: 'rec_03',
      name: 'Sambal Matah Autentik',
      category: 'Sambal & Bumbu',
      difficulty: 'Mudah',
      cookingTime: 15,
      imageUrl: 'https://images.unsplash.com/photo-1596797038530-2c107229654b?q=80&w=800&auto=format&fit=crop',
      ingredients: ['Bawang merah iris', 'Cabai rawit merah iris', 'Batang serai putih', 'Minyak kelapa panas'],
      steps: ['Iris tipis bahan.', 'Remas dengan garam & terasi.', 'Siram minyak kelapa panas.'],
      description: 'Sambal mentah iris segar dengan perpaduan bawang merah, cabai rawit, serai, dan minyak kelapa panas.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const primaryTerracotta = Color(0xFF8D3028);
    const textEspresso = Color(0xFF302923);
    const accentGold = Color(0xFFD5A34A);
    const cardSurface = Color(0xFFFFFDF9);
    const warmCreamBox = Color(0xFFEADBC8);

    final recipeProvider = context.watch<RecipeProvider>();
    final recipes = recipeProvider.recipes.isNotEmpty
        ? recipeProvider.recipes
        : _fallbackRecipes;

    final popularRecipes = recipes.take(2).toList();
    final latestRecipes = recipes.length > 2
        ? recipes.skip(2).take(3).toList()
        : recipes.take(1).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. CUSTOM HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryTerracotta.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: primaryTerracotta.withValues(alpha: 0.18),
                          ),
                        ),
                        child: const Icon(
                          Icons.account_balance,
                          color: primaryTerracotta,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dapur Dewata',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: primaryTerracotta,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            'Warisan Rasa, Resep Nusantara Bali.',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontStyle: FontStyle.italic,
                              color: textEspresso.withValues(alpha: 0.85),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Container(
                            height: 2.5,
                            width: 44,
                            decoration: BoxDecoration(
                              color: accentGold,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => onNavigateToTab?.call(3),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryTerracotta.withValues(alpha: 0.25)),
                      ),
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: warmCreamBox,
                        child: Icon(Icons.person, color: primaryTerracotta, size: 22),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // 2. SEARCH BAR & TOMBOL FILTER
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => onNavigateToTab?.call(1),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: cardSurface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: primaryTerracotta.withValues(alpha: 0.18),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search_rounded, color: primaryTerracotta, size: 22),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Cari resep makanan khas Bali...',
                                style: TextStyle(
                                  color: textEspresso.withValues(alpha: 0.5),
                                  fontSize: 13.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Tombol Filter Bulat
                  InkWell(
                    onTap: () => onNavigateToTab?.call(1),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: primaryTerracotta,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryTerracotta.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 3. HERO BANNER CARD ("Pulau Dewata")
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C1810),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://raw.githubusercontent.com/adisaputra-netizen/UTS_2415051005_Kadek_Adi_Saputra/main/data/images/Beranda.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.85),
                          Colors.black.withValues(alpha: 0.45),
                          Colors.transparent,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Badge Balinese Gold
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: accentGold,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Jelajahi Cita Rasa',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pulau Dewata',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Resep autentik makanan khas Bali, kini lebih mudah!',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                        // Tombol CTA
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryTerracotta,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            minimumSize: const Size(0, 36),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () => onNavigateToTab?.call(1),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Mulai Sekarang', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_rounded, size: 14),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 4. BAGIAN KATEGORI
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kategori',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textEspresso,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      recipeProvider.setCategory('Semua');
                      onNavigateToTab?.call(1);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Lihat Semua >',
                      style: TextStyle(
                        color: primaryTerracotta,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildCategoryItem(
                    label: 'Makanan\nUtama',
                    icon: Icons.restaurant_rounded,
                    categoryFilter: 'Olahan Ayam',
                    context: context,
                  ),
                  const SizedBox(width: 8),
                  _buildCategoryItem(
                    label: 'Jajanan\nTradisional',
                    icon: Icons.cake_outlined,
                    categoryFilter: 'Jajanan Tradisional',
                    context: context,
                  ),
                  const SizedBox(width: 8),
                  _buildCategoryItem(
                    label: 'Minuman\nSegar',
                    icon: Icons.local_cafe_rounded,
                    categoryFilter: 'Minuman',
                    context: context,
                  ),
                  const SizedBox(width: 8),
                  _buildCategoryItem(
                    label: 'Sambal &\nBumbu',
                    icon: Icons.local_fire_department_rounded,
                    categoryFilter: 'Sambal Autentik',
                    context: context,
                  ),
                ],
              ),
              const SizedBox(height: 26),

              // 5. BAGIAN RESEP POPULER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.local_fire_department_rounded, color: primaryTerracotta, size: 22),
                      SizedBox(width: 6),
                      Text(
                        'Resep Populer',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textEspresso,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => onNavigateToTab?.call(1),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Lihat Semua >',
                      style: TextStyle(
                        color: primaryTerracotta,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: popularRecipes.map((recipe) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: _buildPopularVerticalCard(context, recipe),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 26),

              // 6. BAGIAN RESEP TERBARU
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, color: primaryTerracotta, size: 20),
                      SizedBox(width: 6),
                      Text(
                        'Resep Terbaru',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textEspresso,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => onNavigateToTab?.call(1),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Lihat Semua >',
                      style: TextStyle(
                        color: primaryTerracotta,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...latestRecipes.map((recipe) => _buildLatestHorizontalCard(context, recipe)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem({
    required String label,
    required IconData icon,
    required String categoryFilter,
    required BuildContext context,
  }) {
    const primaryTerracotta = Color(0xFF8D3028);
    const textEspresso = Color(0xFF302923);
    const warmCreamBox = Color(0xFFEADBC8);

    return Expanded(
      child: InkWell(
        onTap: () {
          context.read<RecipeProvider>().setCategory(categoryFilter);
          onNavigateToTab?.call(1);
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: warmCreamBox,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: primaryTerracotta.withValues(alpha: 0.12)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: primaryTerracotta, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: textEspresso,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularVerticalCard(BuildContext context, BalineseRecipe recipe) {
    const primaryTerracotta = Color(0xFF8D3028);
    const textEspresso = Color(0xFF302923);
    const accentGold = Color(0xFFD5A34A);
    const cardSurface = Color(0xFFFFFDF9);

    final provider = context.watch<RecipeProvider>();
    final isFav = provider.isFavorite(recipe.id);

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
        decoration: BoxDecoration(
          color: cardSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: primaryTerracotta.withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto Makanan dengan Tombol Favorit
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                  child: SizedBox(
                    height: 110,
                    width: double.infinity,
                    child: Image.network(
                      recipe.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: const Color(0xFFEADBC8),
                        child: const Icon(Icons.restaurant_menu, color: primaryTerracotta, size: 36),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: InkWell(
                    onTap: () => provider.toggleFavorite(recipe.id),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.redAccent : Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Informasi Bawah
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                      color: textEspresso,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 13, color: textEspresso.withValues(alpha: 0.6)),
                          const SizedBox(width: 3),
                          Text(
                            '${recipe.cookingTime}m',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: textEspresso.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.star_rounded, size: 14, color: accentGold),
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
                      // Tombol Bookmark Kecil
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddRecipeNoteScreen(
                                recipeName: recipe.name,
                                initialCategory: recipe.category,
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: primaryTerracotta,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.bookmark_add_outlined,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestHorizontalCard(BuildContext context, BalineseRecipe recipe) {
    const primaryTerracotta = Color(0xFF8D3028);
    const textEspresso = Color(0xFF302923);
    const accentGold = Color(0xFFD5A34A);
    const cardSurface = Color(0xFFFFFDF9);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
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
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 100,
                  height: 95,
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
              Expanded(
                child: SizedBox(
                  height: 95,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.5,
                              color: textEspresso,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            recipe.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: textEspresso.withValues(alpha: 0.65),
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.schedule, size: 13, color: textEspresso.withValues(alpha: 0.6)),
                              const SizedBox(width: 3),
                              Text(
                                '${recipe.cookingTime} menit',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: textEspresso.withValues(alpha: 0.7),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.star_rounded, size: 14, color: accentGold),
                              const SizedBox(width: 2),
                              const Text(
                                '4.8',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: textEspresso,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddRecipeNoteScreen(
                                    recipeName: recipe.name,
                                    initialCategory: recipe.category,
                                  ),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.bookmark_add_outlined,
                                color: primaryTerracotta,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
