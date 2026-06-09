import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientManager {

  Future<void> init() async {
    await dotenv.load();
    await Supabase.initialize(
      url: dotenv.env["https://rcmtaxkojastwhqejung.supabase.co"]!,
      anonKey:dotenv.env["sb_publishable_amk03t4RORVrTaOCz9l6Dg_NGFouXMq"]!,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
