import 'package:flutter/material.dart';

class FavoritesModal extends StatefulWidget {
  final List<dynamic> favorites;
  final Function(String) onRemove;

  FavoritesModal({required this.favorites, required this.onRemove});

  @override
  _FavoritesModalState createState() => _FavoritesModalState();
}

class _FavoritesModalState extends State<FavoritesModal> {
  late List<dynamic> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = widget.favorites;
  }

  void _removeFavorite(String jokeId) {
    setState(() {
      _favorites.removeWhere((item) => item['_id'] == jokeId);
    });
    widget.onRemove(jokeId);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mis Favoritos',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  color: iconColor,
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final joke = _favorites[index]['joke'];

                return ListTile(
                  title: Text(joke),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeFavorite(_favorites[index]['_id']),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_favorites.length}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
