import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:joke_haven/services/auth_service.dart';
import 'package:http/http.dart' as http;

class FavoritesProvider extends ChangeNotifier {
  List<Map<String, dynamic>> favorites = [];

  final String baseUrl = 'http://192.168.100.6:3000/api';
  final AuthService _authService;

  FavoritesProvider(this._authService);

  Future<void> loadFavorites() async {
    final token = await _authService.getToken();
    if (token == null) return;

    final response = await http.get(
      Uri.parse('$baseUrl/jokes/favorites'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      favorites = List<Map<String, dynamic>>.from(data['jokes']);
      notifyListeners();
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  Future<void> addFavorite(String joke) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('User not authenticated');

    final response = await http.post(
      Uri.parse('$baseUrl/jokes/favorites'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'joke': joke}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add joke to favorites');
    }

    notifyListeners();
  }

  Future<void> deleteFavorite(String jokeId) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('User not authenticated');

    final response = await http.delete(
      Uri.parse('$baseUrl/jokes/favorites/$jokeId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete joke');
    }

    await loadFavorites();
  }

  Future<String?> getRandomJoke() async {
    final token = await _authService.getToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse('$baseUrl/jokes/random'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['joke'];
    } else {
      throw Exception('Failed to load joke');
    }
  }
}
