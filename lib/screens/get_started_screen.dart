import 'package:flutter/material.dart';
import 'package:flutter_application_uas/screens/auth_gate.dart';
import 'package:google_fonts/google_fonts.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant_menu, size: 100, color: Colors.teal[400]),
              const SizedBox(height: 24),
              Text(
                'Selamat Datang di Recipe Keeper',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Simpan semua resep masakan favoritmu di satu tempat yang aman dan mudah diakses.',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  // Arahkan ke halaman utama aplikasi (AuthGate) dan hapus halaman ini dari stack
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const AuthGate()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('Mulai Sekarang'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}