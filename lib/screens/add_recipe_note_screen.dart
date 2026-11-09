import 'package:flutter/material.dart';

class AddRecipeNoteScreen extends StatefulWidget {
  final String? recipeName;

  const AddRecipeNoteScreen({super.key, this.recipeName});

  @override
  State<AddRecipeNoteScreen> createState() => _AddRecipeNoteScreenState();
}

class _AddRecipeNoteScreenState extends State<AddRecipeNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.recipeName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Catatan Masak'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Menu Resep',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.restaurant),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Nama resep wajib diisi' : null,
              ),
              const SizedBox(height: 16),
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
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC0392B),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Navigasi form berhasil. Integrasi database di milestone berikutnya.'),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Simpan Catatan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}