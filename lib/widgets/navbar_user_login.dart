import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/favorites_jokes_modal.dart';
import '../providers/theme_provider.dart';
import '../services/auth_service.dart';

class NavbarUserLogin extends StatelessWidget {
  final String username;

  NavbarUserLogin({required this.username});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.favorite),
          onPressed: () async {
            try {
              await favoritesProvider.loadFavorites();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: FavoritesModal(
                      favorites: favoritesProvider.favorites,
                      onRemove: (joke) async {
                        try {
                          await favoritesProvider.deleteFavorite(joke);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Joke removed successfully'),
                          ));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Failed to remove joke'),
                          ));
                        }
                      },
                    ),
                  );
                },
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Failed to load favorites'),
              ));
            }
          },
        ),
        SizedBox(width: 10),
        PopupMenuButton<String>(
          icon: Icon(Icons.person),
          onSelected: (value) {
            if (value == 'logout') {
              Provider.of<AuthService>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/login');
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'profile',
                child: Text(username),
              ),
              PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ];
          },
        ),
        IconButton(
          icon: Icon(
            themeProvider.themeMode == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
          onPressed: () {
            themeProvider.toggleTheme();
          },
        ),
      ],
    );
  }
}
