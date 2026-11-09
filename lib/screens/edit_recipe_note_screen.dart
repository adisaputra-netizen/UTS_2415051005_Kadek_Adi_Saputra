import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_recipe_note.dart';
import '../providers/user_recipe_provider.dart';

class EditRecipeNoteScreen extends StatefulWidget {
  final UserRecipeNote note;

  const EditRecipeNoteScreen({super.key, required this.note});

  @override
  State<EditRecipeNoteScreen> createState() => _EditRecipeNoteScreenState();
}

class _EditRecipeNoteScreenState extends State<EditRecipeNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _noteController;

  late String _selectedCategory;
  late String _selectedDifficulty;
  late int _rating;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Olahan Ayam',
    'Sate & Lilit',
    'Sayur & Lawar',
    'Sambal Autentik',
    'Lainnya',
  ];

  final List<String> _difficulties = ['Mudah', 'Menengah', 'Sulit'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.note.recipeName);
    _noteController = TextEditingController(text: widget.note.cookingNote);
    _selectedCategory = _categories.contains(widget.note.category)
        ? widget.note.category
        : _categories.first;
    _selectedDifficulty = _difficulties.contains(widget.note.difficulty)
        ? widget.note.difficulty
        : 'Mudah';
    _rating = widget.note.personalRating;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final updatedNote = UserRecipeNote(
      id: widget.note.id,
      nim: widget.note.nim,
      recipeName: _nameController.text.trim(),
      category: _selectedCategory,
      cookingNote: _noteController.text.trim(),
      difficulty: _selectedDifficulty,
      personalRating: _rating,
    );

    final success =
        await context.read<UserRecipeProvider>().editNote(updatedNote);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan berhasil diperbarui di database!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      final error = context.read<UserRecipeProvider>().errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Catatan Resep'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Menu Resep *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.restaurant_menu),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Nama menu resep wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori Resep',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDifficulty,
                decoration: const InputDecoration(
                  labelText: 'Tingkat Kesulitan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.speed),
                ),
                items: _difficulties
                    .map((dif) => DropdownMenuItem(value: dif, child: Text(dif)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedDifficulty = val);
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Rating Kepuasan Hasil Masak:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () => setState(() => _rating = index + 1),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Catatan Modifikasi / Tips Bumbu *',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (val) =>
                    (val == null || val.trim().length < 5) ? 'Catatan minimal 5 karakter' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8D3028),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _isSubmitting ? null : _handleUpdate,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle_outline),
                  label: Text(_isSubmitting ? 'Memperbarui...' : 'Perbarui Catatan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}