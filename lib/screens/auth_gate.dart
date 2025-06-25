import 'package:flutter/material.dart';
import 'package:flutter_application_uas/screens/auth_screen.dart';
import 'package:flutter_application_uas/screens/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // StreamBuilder mendengarkan perubahan status otentikasi dari Supabase
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final session = snapshot.data?.session;
          // Jika ada sesi (pengguna login), arahkan ke HomeScreen
          if (session != null) {
            return const HomeScreen();
          }
        }
        // Jika tidak ada sesi (pengguna logout), arahkan ke AuthScreen
        return const AuthScreen();
      },
    );
  }
}