import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../providers/theme_provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = '';
  bool isLoading = false;

  void _register(BuildContext context) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      final success = await authService.register(username, email, password);
      setState(() {
        isLoading = false;
      });

      if (success) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        setState(() {
          errorMessage = 'Registration failed';
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred. Please try again.';
      });
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade300,
              Colors.green.shade800,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 20),
              constraints: BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Register to Joke Haven',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headlineSmall?.color,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person),
                    ),
                    style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(height: 20),
                  isLoading
                      ? CircularProgressIndicator()
                      : Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => _register(context),
                        child: Text('Register'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: _navigateToLogin, // Navega a la pantalla de login
                        child: Text('Already have an account? Login'),
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).brightness == Brightness.dark ?
                          Colors.white: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 20),
                      IconButton(
                        icon: Icon(
                          Theme.of(context).brightness == Brightness.dark
                              ? Icons.light_mode
                              : Icons.dark_mode,
                        ),
                        onPressed: () => themeProvider.toggleTheme(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
