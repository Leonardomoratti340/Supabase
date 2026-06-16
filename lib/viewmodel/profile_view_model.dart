import 'dart:io';

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

  Future<String?> _uploadAvatar(File file, String userId) async {
    try {
      final fileExt = file.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = '$userId/$fileName';

      await _client.storage.from('avatars').upload(filePath, file);
      
      final imageUrl = _client.storage.from('avatars').getPublicUrl(filePath);
      return imageUrl;
    } catch (e) {
      print("Errore durante il caricamento dell'immagine su Storage: $e");
      return null;
    }
  }

  Future<void> createUserProfile(String username, DateTime birthdate, {File? avatarFile}) async {
    final id = _client.auth.currentUser?.id;
    if (id == null) return;

    String? avatarUrl;

    if (avatarFile != null) {
      avatarUrl = await _uploadAvatar(avatarFile, id);
    }

    final newProfile = UserProfile(
      id: id,
      username: username,
      birthdate: birthdate,
      avatarUrl: avatarUrl,
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

  Future<void> updateUserProfile(UserProfile updateUserProfile, {File? avatarFile}) async {
    final id = _client.auth.currentUser?.id;
    if (id == null) return;

    if (avatarFile != null) {
      final newAvatarUrl = await _uploadAvatar(avatarFile, id);
      if (newAvatarUrl != null) {
        updateUserProfile = UserProfile(
          id: updateUserProfile.id,
          username: updateUserProfile.username,
          birthdate: updateUserProfile.birthdate,
          avatarUrl: newAvatarUrl,
        );
      }
    }

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