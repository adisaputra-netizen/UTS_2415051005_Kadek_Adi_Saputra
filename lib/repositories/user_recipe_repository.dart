import '../models/user_recipe_note.dart';
import '../services/supabase_service.dart';

class UserRecipeRepository {
  final SupabaseService supabaseService;

  UserRecipeRepository(this.supabaseService);

  Future<List<UserRecipeNote>> getUserNotes({String? nim}) async {
    return await supabaseService.fetchNotes(nim: nim);
  }

  Future<UserRecipeNote> addNote(UserRecipeNote note) async {
    return await supabaseService.insertNote(note);
  }

  Future<UserRecipeNote> updateNote(UserRecipeNote note) async {
    return await supabaseService.updateNote(note);
  }

  Future<void> deleteNote(int id) async {
    await supabaseService.deleteNote(id);
  }
}

