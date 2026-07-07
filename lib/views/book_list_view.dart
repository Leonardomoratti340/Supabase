import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Assicurati che i percorsi siano corretti
import 'package:flutter_supabase/viewmodel/book_view_model.dart';
import 'package:flutter_supabase/views/book_detail_view.dart';

class BookListView extends StatefulWidget {
  const BookListView({super.key});

  @override
  State<BookListView> createState() => _BookListViewState();
}

class _BookListViewState extends State<BookListView> {
  
  @override
  void initState() {
    super.initState();
    // Questo comando dice all'app: "Appena la pagina ha finito di disegnarsi, scarica i libri"
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Usa loadAllBooks() se vuoi mostrare i libri di TUTTI gli utenti.
      // Usa loadBooks() se vuoi mostrare solo i libri dell'utente attualmente loggato.
      context.read<BookViewModel>().loadAllBooks(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tutti i libri"),
      ),
      // Usiamo Consumer per "ascoltare" i cambiamenti del ViewModel
      body: Consumer<BookViewModel>(
        builder: (context, vm, child) {
          
          // 1. Stato: Caricamento in corso
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Stato: Nessun libro trovato
          if (vm.books.isEmpty) {
            return const Center(
              child: Text(
                "Non ci sono ancora libri qui.\nTorna indietro e aggiungine uno!",
                textAlign: TextAlign.center,
              ),
            );
          }

          // 3. Stato: Libri trovati, mostriamo la lista!
          return ListView.builder(
            itemCount: vm.books.length,
            itemBuilder: (context, index) {
              final book = vm.books[index]; // Peschiamo il libro esatto dalla tua lista
              
              return ListTile(
                leading: const Icon(Icons.menu_book),
                title: Text(book.title), // Usa le variabili del tuo Book model
                subtitle: Text(book.author),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Quando clicchi, apri il BookDetailView passandogli l'intero oggetto book
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailView(book: book),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}