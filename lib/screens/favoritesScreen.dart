import 'package:flutter/material.dart';
import 'package:food_recipe_app_finproj/service/recipe.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_recipe_app_finproj/service/favorites.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: favoritesProvider.favorites.length,
        itemBuilder: (context, index) {
          // Use the recipeId to fetch and display the corresponding recipe
          // Here's an example of how you can display the recipe information
          return ListTile(
            title: Text('Recipe: ${favoritesProvider.favorites[index]}'),
            trailing: IconButton(
              icon: Icon(Icons.favorite),
              color: Color.fromARGB(255, 251, 183, 44),
              onPressed: () {
                final recipeName = favoritesProvider.favorites[index];
                favoritesProvider.removeFromFavorites(recipeName);
              },
            ),
          );
        },
      ),
    );
  }
}
