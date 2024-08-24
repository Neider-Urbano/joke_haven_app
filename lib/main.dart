import 'package:flutter/material.dart';
import 'package:joke_haven/providers/favorites_provider.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/jokes_screen.dart';
import 'services/auth_service.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<FavoritesProvider>(
          create: (context) => FavoritesProvider(Provider.of<AuthService>(context, listen: false)),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Joke Haven',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
            ),
            themeMode: themeProvider.themeMode,
            initialRoute: '/login',
            builder: (context, child) {
              return SafeArea(child: child!);
            },
            routes: {
              '/login': (context) => LoginScreen(),
              '/register': (context) => RegisterScreen(),
              '/jokes': (context) => JokesScreen(),
            },
          );
        },
      ),
    );
  }
}
