import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_recipe_note.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;
  String _tableName = 'user_recipe_notes';

  SupabaseClient get client => _client;

  Future<List<UserRecipeNote>> fetchNotes({String? nim}) async {
    try {
      var query = _client.from(_tableName).select();
      if (nim != null && nim.isNotEmpty) {
        query = query.eq('nim', nim);
      }
      final response = await query.order('created_at', ascending: false);
      return (response as List<dynamic>)
          .map((e) => UserRecipeNote.fromMap(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      if (e.code == '42P01' && _tableName == 'user_recipe_notes') {
        _tableName = 'recipe_notes';
        return fetchNotes(nim: nim);
      }
      rethrow;
    }
  }

  Future<UserRecipeNote> insertNote(UserRecipeNote note) async {
    try {
      final data = note.toMap();
      data.remove('id');
      final response = await _client
          .from(_tableName)
          .insert(data)
          .select()
          .single();
      return UserRecipeNote.fromMap(response);
    } on PostgrestException catch (e) {
      if (e.code == '42P01' && _tableName == 'user_recipe_notes') {
        _tableName = 'recipe_notes';
        return insertNote(note);
      }
      rethrow;
    }
  }

  Future<UserRecipeNote> updateNote(UserRecipeNote note) async {
    if (note.id == null) {
      throw Exception('ID catatan tidak boleh kosong saat memperbarui');
    }
    try {
      final data = note.toMap();
      final response = await _client
          .from(_tableName)
          .update(data)
          .eq('id', note.id!)
          .select()
          .single();
      return UserRecipeNote.fromMap(response);
    } on PostgrestException catch (e) {
      if (e.code == '42P01' && _tableName == 'user_recipe_notes') {
        _tableName = 'recipe_notes';
        return updateNote(note);
      }
      rethrow;
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await _client.from(_tableName).delete().eq('id', id);
    } on PostgrestException catch (e) {
      if (e.code == '42P01' && _tableName == 'user_recipe_notes') {
        _tableName = 'recipe_notes';
        return deleteNote(id);
      }
      rethrow;
    }
  }
}

