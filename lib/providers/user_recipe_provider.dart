import 'package:flutter/foundation.dart';
import '../models/user_recipe_note.dart';
import '../repositories/user_recipe_repository.dart';

class UserRecipeProvider with ChangeNotifier {
  final UserRecipeRepository repository;

  List<UserRecipeNote> _notes = [];
  bool _isLoading = false;
  String _errorMessage = '';

  UserRecipeProvider({required this.repository});

  List<UserRecipeNote> get notes => _notes;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Mengambil seluruh catatan resep dari Supabase
  Future<void> fetchUserNotes({String? nim}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _notes = await repository.getUserNotes(nim: nim);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Menambah catatan baru ke Supabase
  Future<bool> addNote(UserRecipeNote note) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final newNote = await repository.addNote(note);
      _notes.insert(0, newNote);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Memperbarui catatan di Supabase
  Future<bool> updateNote(UserRecipeNote note) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final updatedNote = await repository.updateNote(note);
      final index = _notes.indexWhere((n) => n.id == updatedNote.id);
      if (index != -1) {
        _notes[index] = updatedNote;
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Alias untuk kompatibilitas pemanggilan editNote
  Future<bool> editNote(UserRecipeNote note) => updateNote(note);

  // Menghapus catatan di Supabase
  Future<bool> deleteNote(int id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await repository.deleteNote(id);
      _notes.removeWhere((item) => item.id == id);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setNotes(List<UserRecipeNote> notes) {
    _notes = notes;
    notifyListeners();
  }

  void addNoteLocally(UserRecipeNote note) {
    _notes.insert(0, note);
    notifyListeners();
  }

  void removeNoteLocally(int id) {
    _notes.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
