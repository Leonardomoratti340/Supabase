import 'package:flutter/material.dart';
import 'package:flutter_supabase/viewmodel/auth_view_model.dart';
import 'package:flutter_supabase/viewmodel/book_view_model.dart';
import 'package:flutter_supabase/viewmodel/profile_view_model.dart';
import 'package:flutter_supabase/views/auth/login_view.dart';
import 'package:flutter_supabase/views/home_view.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Creiamo un'istanza globale (opzionale, ma comodissima) per accedere al database da qualsiasi file
final supabase = Supabase.instance.client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rcmtaxkojastwhqejung.supabase.co',
    anonKey: 'sb_publishable_amk03t4RORVrTaOCz9l6Dg_NGFouXMq',
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => BookViewModel()),
        ChangeNotifierProvider(
          create: (_) => ProfileViewModel()..loadUserProfile(),
          lazy: false,
          ),
      ],
      child: Consumer<AuthViewModel>(
        builder: (context, auth, child) {
          return MaterialApp(
          title: 'Supabase App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: auth.session != null ? const HomeView() : const LoginView()
      );
      },
      
      
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _fetchData() async {
    try {
      print("Supabase è connesso e pronto!");
    } catch (e) {
      print("Errore: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text('Guarda la console per vedere se Supabase risponde.'),
      ),
    );
  }
}