import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/balinese_recipe.dart';

class ApiService {
  Future<List<BalineseRecipe>> fetchRecipes() async {
    try {
      // URL ditambahkan timestamp ?t=... agar melewati cache CDN GitHub
      final url = Uri.parse(
        'https://raw.githubusercontent.com/adisaputra-netizen/UTS_2415051005_Kadek_Adi_Saputra/main/data/recipes.json?t=${DateTime.now().millisecondsSinceEpoch}',
      );

      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => BalineseRecipe.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat resep (Status Code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal menghubungi server REST API: $e');
    }
  }
}