import 'package:flutter/material.dart';
import 'package:flutter_resep_masakan_nusantara_uas/data/database_helper.dart';
import 'package:flutter_resep_masakan_nusantara_uas/data/models/user_model.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class AuthProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper;
  User? _currentUser;

  AuthProvider(this._dbHelper) {
    // Di aplikasi nyata, Anda akan memuat status login dari penyimpanan aman
  }

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  String _hashPassword(String password) {
    var bytes = utf8.encode(password); // data being hashed
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> register(User user) async {
    final hashedPassword = _hashPassword(user.password);
    final newUser = User(
      name: user.name,
      email: user.email,
      phone: user.phone,
      password: hashedPassword,
      favoriteFood: user.favoriteFood,
    );
    try {
      final id = await _dbHelper.registerUser(newUser);
      // Cukup kembalikan true jika berhasil, jangan auto-login
      return id > 0;
    } catch (e) {
      // Ini akan menangani error jika email sudah ada (UNIQUE constraint)
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    final hashedPassword = _hashPassword(password);
    final user = await _dbHelper.login(email, hashedPassword);
    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> updateUser(User user) async {
    final result = await _dbHelper.updateUser(user);
    if (result > 0) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }
}