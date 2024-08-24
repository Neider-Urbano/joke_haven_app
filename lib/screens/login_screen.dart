import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../providers/theme_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  void _login(BuildContext context) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final email = _emailController.text;
    final password = _passwordController.text;
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      final success = await authService.login(email, password);
      setState(() {
        isLoading = false;
      });

      if (success) {
        Navigator.pushReplacementNamed(context, '/jokes');
      } else {
        setState(() {
          errorMessage = 'Invalid credentials';
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred. Please try again.';
      });
    }
  }

  void _navigateToRegister() {
    Navigator.pushNamed(context, '/register');
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
              Colors.blue.shade300,
              Colors.blue.shade800,
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
                    'Login to Joke Haven',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headlineSmall?.color,
                    ),
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
                        onPressed: () => _login(context),
                        child: Text('Login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: _navigateToRegister, // Aquí se redirige a la pantalla de registro
                        child: Text('Registrarme'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
