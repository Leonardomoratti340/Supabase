import 'package:flutter_supabase/models/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<UserProfile?> fecthUserProfile() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      return null;
    }

    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    return UserProfile.fromMap(response);
  }

  Future<void> createUserProfile(UserProfile profile) async {
    await _client.from('profiles').insert(profile.toMap());
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    await _client.from('profiles').update(profile.toMap()).eq('id', profile.id);
  }
}
