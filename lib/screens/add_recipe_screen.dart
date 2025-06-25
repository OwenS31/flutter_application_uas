import 'package:flutter/material.dart';
import 'package:flutter_application_uas/main.dart';
import 'package:google_fonts/google_fonts.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientsController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    super.dispose();
  }

  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);

    final user = supabase.auth.currentUser;
    if (user == null) return;

    // Pisahkan bahan berdasarkan koma, dan hapus spasi berlebih
    final ingredients = _ingredientsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    try {
      // Simpan data ke tabel 'recipes'
      await supabase.from('recipes').insert({
        'user_id': user.id,
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'ingredients': ingredients,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resep berhasil disimpan!'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan resep: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
       if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Resep Baru', style: GoogleFonts.lato()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Resep'),
                validator: (value) => value!.isEmpty ? 'Nama resep tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi Singkat (Opsional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(
                  labelText: 'Bahan-bahan',
                  hintText: 'Contoh: Nasi, Telur, Bawang merah',
                  helperText: 'Pisahkan setiap bahan dengan koma (,)',
                ),
                 validator: (value) => value!.isEmpty ? 'Bahan tidak boleh kosong' : null,
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _saveRecipe,
                       style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white
                        ),
                      child: Text('Simpan Resep'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}