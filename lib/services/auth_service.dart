import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthService() {
   
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  User? get user => _user;

  bool get isAuthenticated => _user != null;

  Future<String?> createUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }


  void _onAuthStateChanged(User? firebaseUser) {
    _user = firebaseUser;
    print("Estado de autenticación cambiado. Usuario: $_user");
    notifyListeners(); 
  }
}