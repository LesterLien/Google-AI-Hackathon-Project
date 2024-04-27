import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import for FirebaseFirestore
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for FirebaseFirestore
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final String favoritesCollection = 'favorites';

  static Future<void> saveFavorite(String fdcId) async {
    final userId = await getCurrentUserId(); 
    if (userId == null) {
      return; 
    }

    final favoritesRef = _firestore.collection(favoritesCollection).doc(userId);
    final favoritesSnapshot = await favoritesRef.get(); 

    final List<String> currentFoods = (favoritesSnapshot.exists ? (favoritesSnapshot.data() as Map<String, dynamic>)['foods'] : [])?.cast<String>() ?? [];

    if (currentFoods.contains(fdcId)) {
      return; 
    }

    currentFoods.add(fdcId);

    await favoritesRef.set({
      'foods': currentFoods,
    });

    print("Saved favorite: $fdcId for user: $userId");
  }

  static Future<void> unsaveFavorite(String fdcId) async {
    final userId = await getCurrentUserId(); 
    if (userId == null) {
      return; 
    }

    final favoritesRef = _firestore.collection(favoritesCollection).doc(userId);
    final favoritesSnapshot = await favoritesRef.get(); 

 
    final List<String> currentFoods = (favoritesSnapshot.exists ? (favoritesSnapshot.data() as Map<String, dynamic>)['foods'] : null)?.cast<String>();
    if (currentFoods == null || !currentFoods.contains(fdcId)) {
      return; // Not favorited
    }


    final updatedFoods = currentFoods.where((id) => id != fdcId).toList();

    await favoritesRef.set({
      'foods': updatedFoods,
    });

    print("Unsaved favorite: $fdcId for user: $userId");
  }

  static Future<String?> getCurrentUserId() async {

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }
}