import 'package:flutter/material.dart';
import 'views/auth/login_view.dart';
import 'package:provider/provider.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      return FutureBuilder(
        future: context.read<AuthViewModel>().getUserRole(session.user.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()), 
            );
          }
          final role = snapshot.data;
           if(role == 'admin') {
            // Navigate to admin dashboard
            return const Scaffold(
              body: Center(child: Text('Admin Dashboard')), 
            );
          } else {
            // Navigate to student dashboard
            return const Scaffold(
              body: Center(child: Text('Student Dashboard')), 
            );
          }

         
        },
      );
    }



    return const LoginView();
  }
}