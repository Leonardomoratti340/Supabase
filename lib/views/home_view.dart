import 'package:flutter/material.dart';
import 'package:flutter_supabase/viewmodel/auth_view_model.dart';
import 'package:flutter_supabase/views/auth/login_view.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(onPressed: ()async {
            await vm.logout();
            if(context.mounted) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const LoginView()));
            }
            // Qui potresti aggiungere la logica per il logout
          }, icon: const Icon(Icons.logout))
        ],
      ),
      body: const Center(
        child: Text("Benvenuto nella Home!"),
      ),
    );
  }
}