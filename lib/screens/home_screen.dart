import 'package:flutter/material.dart';
import 'package:flutter_application_uas/main.dart';
import 'package:flutter_application_uas/models/recipe.dart';
import 'package:flutter_application_uas/screens/add_recipe_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream<List<Recipe>> get _recipesStream {
    final user = supabase.auth.currentUser;
    if (user != null) {
      return supabase
          .from('recipes')
          .stream(primaryKey: ['id'])
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .map((maps) => maps.map((map) => Recipe.fromMap(map)).toList());
    } else {
      return Stream.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Recipes',
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Proses Sign Out
              await supabase.auth.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Recipe>>(
        stream: _recipesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final recipes = snapshot.data;
          if (recipes == null || recipes.isEmpty) {
            return Center(
              child: Text(
                'Belum ada resep.\nTekan tombol + untuk menambahkan.',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(fontSize: 16, color: Colors.grey[600]),
              ),
            );
          }

          // Tampilkan daftar resep menggunakan ListView.builder
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 4.0,
                ),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    recipe.name,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (recipe.description != null &&
                            recipe.description!.isNotEmpty) ...[
                          Text(
                            recipe.description!,
                            style: GoogleFonts.lato(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 8),
                        ],
                        Text(
                          'Bahan:',
                          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          recipe.ingredients.join(', '),
                          style: GoogleFonts.lato(),
                        ),
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red[300]),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Hapus Resep?'),
                          content: Text(
                              'Apakah Anda yakin ingin menghapus resep "${recipe.name}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Hapus',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await supabase.from('recipes').delete().match({
                          'id': recipe.id,
                        });
                        setState(() {});
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigasi ke halaman tambah resep
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
          );
          setState(() {}); // Tambahkan ini agar rebuild setelah kembali
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
