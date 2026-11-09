// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:dapur_dewata/main.dart';
import 'package:dapur_dewata/services/api_service.dart';
import 'package:dapur_dewata/repositories/recipe_repository.dart';
import 'package:dapur_dewata/services/supabase_service.dart';
import 'package:dapur_dewata/repositories/user_recipe_repository.dart';
import 'package:dapur_dewata/providers/recipe_provider.dart';
import 'package:dapur_dewata/providers/user_recipe_provider.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    final apiService = ApiService();
    final recipeRepository = RecipeRepository(apiService);
    final supabaseService = SupabaseService();
    final userRecipeRepository = UserRecipeRepository(supabaseService);

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => RecipeProvider(repository: recipeRepository),
          ),
          ChangeNotifierProvider(
            create: (_) => UserRecipeProvider(repository: userRecipeRepository),
          ),
        ],
        child: const DapurDewataApp(),
      ),
    );

    // Verify that Dapur Dewata title exists
    expect(find.text('Dapur Dewata'), findsWidgets);
  });
}
