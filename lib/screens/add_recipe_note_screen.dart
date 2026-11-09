import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_recipe_note.dart';
import '../providers/user_recipe_provider.dart';

class AddRecipeNoteScreen extends StatefulWidget {
  final String? recipeName;
  final String? initialCategory;
  final UserRecipeNote? existingNote;

  const AddRecipeNoteScreen({
    super.key,
    this.recipeName,
    this.initialCategory,
    this.existingNote,
  });

  @override
  State<AddRecipeNoteScreen> createState() => _AddRecipeNoteScreenState();
}

class _AddRecipeNoteScreenState extends State<AddRecipeNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _noteController;

  late String _selectedCategory;
  late String _selectedDifficulty;
  late int _rating;
  bool _isSubmitting = false;

  final List<String> _categories = const [
    'Olahan Ayam',
    'Sate & Lilit',
    'Sayur & Lawar',
    'Sambal Autentik',
    'Umum',
    'Lainnya',
  ];

  final List<String> _difficulties = const [
    'Mudah',
    'Sedang',
    'Sulit',
  ];

  @override
  void initState() {
    super.initState();
    final note = widget.existingNote;
    _nameController = TextEditingController(
      text: note?.recipeName ?? widget.recipeName ?? '',
    );
    _noteController = TextEditingController(
      text: note?.cookingNote ?? '',
    );
    _selectedCategory = note?.category ?? widget.initialCategory ?? 'Olahan Ayam';
    if (!_categories.contains(_selectedCategory)) {
      _selectedCategory = 'Umum';
    }
    _selectedDifficulty = note?.difficulty ?? 'Mudah';
    if (!_difficulties.contains(_selectedDifficulty)) {
      _selectedDifficulty = 'Mudah';
    }
    _rating = note?.personalRating ?? 5;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final provider = context.read<UserRecipeProvider>();
    final isEditing = widget.existingNote != null;

    final noteData = UserRecipeNote(
      id: widget.existingNote?.id,
      nim: '2415051005',
      recipeName: _nameController.text.trim(),
      category: _selectedCategory,
      cookingNote: _noteController.text.trim(),
      difficulty: _selectedDifficulty,
      personalRating: _rating,
    );

    bool success;
    if (isEditing) {
      success = await provider.updateNote(noteData);
    } else {
      success = await provider.addNote(noteData);
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? 'Catatan resep berhasil diperbarui!'
                : 'Catatan resep berhasil disimpan ke Supabase!',
          ),
          backgroundColor: Colors.green.shade700,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan catatan: ${provider.errorMessage}'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingNote != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Catatan Masak' : 'Tambah Catatan Masak'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama Menu Resep
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Menu Resep',
                  hintText: 'Contoh: Ayam Betutu Gilimanuk',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.restaurant),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Nama resep wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Kategori Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori Resep',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: _categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: 16),

              // Tingkat Kesulitan Dropdown
              DropdownButtonFormField<String>(
                value: _selectedDifficulty,
                decoration: const InputDecoration(
                  labelText: 'Tingkat Kesulitan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.speed),
                ),
                items: _difficulties.map((diff) {
                  return DropdownMenuItem(value: diff, child: Text(diff));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedDifficulty = val);
                },
              ),
              const SizedBox(height: 16),

              // Rating Bintang
              const Text(
                'Rating Kepuasan / Rasa (1 - 5)',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 6),
              Row(
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  return IconButton(
                    iconSize: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      starIndex <= _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber.shade700,
                    ),
                    onPressed: () {
                      setState(() => _rating = starIndex);
                    },
                  );
                }),
              ),
              const SizedBox(height: 16),

              // Catatan Modifikasi / Catatan Masak
              TextFormField(
                controller: _noteController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Catatan Modifikasi / Pengalaman Memasak',
                  hintText: 'Contoh: Takaran cabai dikurangi sedikit, base genep ditumis lebih lama...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Catatan tidak boleh kosong' : null,
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8D3028),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    _isSubmitting
                        ? 'Menyimpan...'
                        : (isEditing ? 'Perbarui Catatan' : 'Simpan ke Supabase'),
                    style: const TextStyle(fontSize: 15),
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
