import 'package:flutter/foundation.dart';
import '../models/user_recipe_note.dart';

class UserRecipeProvider with ChangeNotifier {
  List<UserRecipeNote> _notes = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<UserRecipeNote> get notes => _notes;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

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