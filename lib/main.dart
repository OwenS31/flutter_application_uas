import 'package:flutter/material.dart';
import 'package:flutter_application_uas/screens/auth_gate.dart';
import 'package:flutter_application_uas/screens/get_started_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Ganti dengan kredensial Supabase Anda
const String supabaseUrl = 'https://cawhwjkidiqzhlizzilu.supabase.co';
const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNhd2h3amtpZGlxemhsaXp6aWx1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAzMzU2NjUsImV4cCI6MjA2NTkxMTY2NX0.0BQzzBpwJ4ZC4o99FTOcP5GBFpjfpaiITozyPRFDMDk';

Future<void> main() async {
  // Pastikan semua binding widget sudah siap sebelum menjalankan kode async
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // Cek apakah ini kali pertama aplikasi dibuka
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
  
  if (isFirstLaunch) {
    await prefs.setBool('isFirstLaunch', false);
  }

  runApp(MyApp(isFirstLaunch: isFirstLaunch));
}

// Instance Supabase client yang bisa diakses di seluruh aplikasi
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;
  const MyApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Keeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          surfaceTintColor: Colors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      // Jika pertama kali, tampilkan GetStartedScreen, jika tidak, AuthGate
      home: isFirstLaunch ? const GetStartedScreen() : const AuthGate(),
    );
  }
}