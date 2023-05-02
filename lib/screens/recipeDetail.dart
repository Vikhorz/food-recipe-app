import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_recipe_app_finproj/service/favorites.dart';
import 'package:food_recipe_app_finproj/service/recipe.dart';
import 'package:provider/provider.dart';

class RecDetail extends StatelessWidget {
  final Recipe recipe;
  final String recipeName;
  final IconData favorited = Icons.favorite;
  final IconData un_favorited = Icons.favorite_outline;

  RecDetail({
    Key? key,
    required this.recipe,
    required this.recipeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Recipe Details'),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, _) {
              bool isFavorite =
                  favoritesProvider.favorites.contains(recipeName);
              return IconButton(
                onPressed: () {
                  if (isFavorite) {
                    favoritesProvider.removeFromFavorites(recipeName);
                  } else {
                    favoritesProvider.addToFavorites(recipeName);
                  }
                },
                icon: Icon(
                  isFavorite ? favorited : un_favorited,
                  color: Color.fromARGB(255, 251, 183, 44),
                ),
                tooltip:
                    isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
              );
            },
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: 25,
          ),
          Center(
            child: Container(
              width: 320,
              height: 275,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(recipe.images), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(),
            child: Center(
              child: Text(
                recipe.name,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(
              //   'Rating',
              //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              // ),
              Center(
                child: Icon(
                  Icons.star,
                  color: Color.fromARGB(255, 255, 200, 0),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(recipe.rating.toString(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              recipe.description,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color.fromARGB(255, 100, 99, 101)),
              overflow: TextOverflow.clip,
            ),
          ),
          SizedBox(
            height: 35,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Text(
                  'Preparation Steps',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
              ),
              Center(
                child: Container(
                  width: 110,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(255, 62, 62, 67)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        FontAwesomeIcons.clock,
                        color: Color.fromARGB(255, 251, 183, 44),
                      ),
                      Text(
                        recipe.totalTime,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: 'Step 1: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 251, 183, 44),
                        fontSize: 18),
                  ),
                  TextSpan(
                      text: recipe.prepStep1,
                      style: TextStyle(
                          color: Color.fromARGB(255, 126, 126, 126),
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: 'Step 2: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 251, 183, 44),
                        fontSize: 18),
                  ),
                  TextSpan(
                      text: recipe.prepStep2,
                      style: TextStyle(
                          color: Color.fromARGB(255, 126, 126, 126),
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: 'Step 3: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 251, 183, 44),
                        fontSize: 18),
                  ),
                  TextSpan(
                      text: recipe.prepStep3,
                      style: TextStyle(
                          color: Color.fromARGB(255, 126, 126, 126),
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: 'Step 4: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 251, 183, 44),
                        fontSize: 18),
                  ),
                  TextSpan(
                      text: recipe.prepStep4,
                      style: TextStyle(
                          color: Color.fromARGB(255, 126, 126, 126),
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
