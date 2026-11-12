import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/api_service.dart';
import 'services/supabase_service.dart';
import 'repositories/recipe_repository.dart';
import 'repositories/user_recipe_repository.dart';
import 'providers/recipe_provider.dart';
import 'providers/user_recipe_provider.dart';
import 'screens/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase dengan kredensial proyek
  await Supabase.initialize(
    url: 'https://rznzycchynbewjmabpog.supabase.co',
    publishableKey: 'sb_publishable_iNaKCFVLbvAfWx3_DP7BCA_hzxmZra5',
  );

  final apiService = ApiService();
  final supabaseService = SupabaseService();

  final recipeRepository = RecipeRepository(apiService);
  final userRecipeRepository = UserRecipeRepository(supabaseService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RecipeProvider(
            repository: recipeRepository,
          )..fetchRecipesFromApi(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserRecipeProvider(
            repository: userRecipeRepository,
          )..fetchUserNotes(),
        ),
      ],
      child: const DapurDewataApp(),
    ),
  );
}

class DapurDewataApp extends StatelessWidget {
  const DapurDewataApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryTerracotta = Color(0xFF8D3028);
    const bgWarmCream = Color(0xFFF4EBDD);
    const accentGold = Color(0xFFD5A34A);
    const secondaryHerbal = Color(0xFF526B45);
    const textEspresso = Color(0xFF302923);
    const cardSurface = Color(0xFFFFFDF9);

    return MaterialApp(
      title: 'Dapur Dewata',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: bgWarmCream,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: primaryTerracotta,
          onPrimary: Colors.white,
          secondary: secondaryHerbal,
          onSecondary: Colors.white,
          tertiary: accentGold,
          onTertiary: Colors.white,
          surface: cardSurface,
          onSurface: textEspresso,
          error: Color(0xFFBA1A1A),
          onError: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: bgWarmCream,
          foregroundColor: primaryTerracotta,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: primaryTerracotta,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: primaryTerracotta),
        ),
        cardTheme: CardThemeData(
          color: cardSurface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: primaryTerracotta.withValues(alpha: 0.12)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryTerracotta,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryTerracotta,
            side: BorderSide(color: primaryTerracotta.withValues(alpha: 0.2)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cardSurface,
          labelStyle: TextStyle(color: textEspresso.withValues(alpha: 0.8)),
          hintStyle: TextStyle(color: textEspresso.withValues(alpha: 0.45)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: primaryTerracotta.withValues(alpha: 0.2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: primaryTerracotta.withValues(alpha: 0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primaryTerracotta, width: 1.5),
          ),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}
