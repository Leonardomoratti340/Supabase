import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_supabase/viewmodel/auth_view_model.dart';
import 'package:flutter_supabase/views/add_book_view.dart';
import 'package:flutter_supabase/views/auth/login_view.dart';
import 'package:flutter_supabase/views/widgets/bottom_nav_bar.dart';
import 'package:flutter_supabase/views/book_list_view.dart'; 

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () async {
              await vm.logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginView()),
                );
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const AddBookView())
                );
              },
              child: const Text("Aggiungi un libro"),
            ),
            
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const BookListView()) 
                );
              },
              child: const Text("Esplora tutti i libri"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}