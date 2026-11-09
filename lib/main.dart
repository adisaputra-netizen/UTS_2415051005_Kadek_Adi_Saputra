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
    anonKey: 'sb_publishable_iNaKCFVLbvAfWx3_DP7BCA_hzxmZra5',
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
    return MaterialApp(
      title: 'Dapur Dewata',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC0392B),
          brightness: Brightness.light,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}