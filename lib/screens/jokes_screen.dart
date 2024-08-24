import 'package:flutter/material.dart';
import 'package:joke_haven/providers/favorites_provider.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/navbar_user_login.dart';

class JokesScreen extends StatefulWidget {
  @override
  _JokesScreenState createState() => _JokesScreenState();
}

class _JokesScreenState extends State<JokesScreen> {
  String username = '';
  String _randomJoke = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchRandomJoke();
  }

  Future<void> _loadUserData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userData = await authService.getUserData();
    if (userData != null) {
      setState(() {
        username = userData['username'];
      });
    }
  }

  Future<void> _fetchRandomJoke() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final favoritesProvider= Provider.of<FavoritesProvider>(context, listen: false);
      final response = await favoritesProvider.getRandomJoke();
      setState(() {
        _randomJoke = response ?? "";
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load joke'),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addToFavorites() async {

    try {
      final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
      await favoritesProvider.addFavorite(_randomJoke);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Joke added to favorites'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add joke to favorites'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Colors.deepPurple;

    return Scaffold(
      appBar: AppBar(
        title: Text('Jokes'),
        backgroundColor: isDarkMode ? Colors.grey[900] : primaryColor,
        foregroundColor: Colors.white,
        actions: [
          NavbarUserLogin(username: username),
        ],
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.black54 : Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _randomJoke,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _fetchRandomJoke,
                    child: Text('Get New Joke'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.favorite_border),
                    color: primaryColor,
                    onPressed: _addToFavorites,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
