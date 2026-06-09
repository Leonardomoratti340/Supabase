import 'package:flutter/material.dart';
import 'package:flutter_supabase/core/profile.service.dart';
import 'package:flutter_supabase/models/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  final SupabaseClient _client = Supabase.instance.client;

  UserProfile? profile;
  bool isLoading = false;

  Future<void> loadUserProfile() async {
    await Future.microtask(() {
      isLoading = true;
      notifyListeners();
    });

    try {
      profile = await _profileService.fecthUserProfile();
    } catch (e) {
      print("errore caricamento profilo $e");
    }

    await Future.microtask(() {
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> createUserProfile(String username, DateTime birthdate) async {
    final id = _client.auth.currentUser?.id;
    if (id == null) return;

    final newProfile = UserProfile(
      id: id,
      username: username,
      birthdate: birthdate,
      avatarUrl: null,
    );

    try {
      await _profileService.createUserProfile(newProfile);
      profile = newProfile;
    } catch (e) {
      print("errore nella creazione del profilo utente $e");
    }

    await Future.microtask(() {
      notifyListeners();
    });
  }

  Future<void> updateUserProfile(UserProfile updateUserProfile) async {
    try {
      await _profileService.updateUserProfile(updateUserProfile);
      profile = updateUserProfile;
    } catch (e) {
      print("errore aggiornamento profilo utente $e");
    }
    await Future.microtask(() {
      notifyListeners();
    });
  }
}
