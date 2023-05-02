import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_recipe_app_finproj/main.dart';
import 'package:food_recipe_app_finproj/screens/favoritesScreen.dart';
import 'package:food_recipe_app_finproj/screens/recipeDetail.dart';
import 'package:food_recipe_app_finproj/service/recipe.dart';
import 'package:food_recipe_app_finproj/service/recipe_api.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:food_recipe_app_finproj/screens/loginScreen.dart';
import 'package:food_recipe_app_finproj/widgets/recipeContainer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Home extends StatefulWidget {
  final GoogleSignInAccount? googleUser;
  User? firebaseUser;
  Home({Key? key, this.googleUser}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Recipe> _recipes = [];
  bool _isLoading = true;
  bool isLoggedIn = false;
  bool isFirebaseUser = false;
  String firebaseUserName = '';
  String googleUserName = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isDark = false;

  // Define global theme data
  final ThemeData _darkTheme = ThemeData.dark().copyWith(
      // Customize dark theme colors
      scaffoldBackgroundColor: Color.fromARGB(255, 31, 31, 33),
      drawerTheme:
          DrawerThemeData(backgroundColor: Color.fromARGB(255, 31, 31, 33)),
      appBarTheme: AppBarTheme(
        backgroundColor: Color.fromARGB(255, 38, 38, 41),
      ));
  final ThemeData _lightTheme = ThemeData.light().copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: Color.fromARGB(255, 210, 214, 214),
      actionsIconTheme: IconThemeData(color: Colors.black),
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
    ),
  );

  @override
  void initState() {
    super.initState();
    _loadTheme();
    getRecipes();
    checkFirebaseUserSignIn();
    checkGoogleSignIn();
  }

  Future<void> _saveTheme(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', isDark);
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? savedIsDark = prefs.getBool('isDark');
    if (savedIsDark != null) {
      setState(() {
        isDark = savedIsDark;
      });
    }
  }

  Future<void> getRecipes() async {
    _recipes = await RecipeApi.getRecipe();
    setState(() {
      _isLoading = false;
    });
  }

  Future<String> checkFirebaseUserSignIn() async {
    // Check if a user is signed in with Firebase
    widget.firebaseUser = FirebaseAuth.instance.currentUser;
    if (widget.firebaseUser != null) {
      setState(() {
        isFirebaseUser = true;
        firebaseUserName = widget.firebaseUser!.displayName ?? '';
      });
    }
    return '';
  }

  Future<void> checkGoogleSignIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      this.isLoggedIn = isLoggedIn;
    });

    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? account = await googleSignIn.signIn();

    if (account != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  Future<String> fetchGoogleUserName() async {
    final googleSignIn = GoogleSignIn();
    final currentUser = await googleSignIn.signInSilently(reAuthenticate: true);
    if (currentUser != null) {
      return currentUser.displayName ?? '';
    } else {
      print('Failed to fetch Google user name');
      return 'Aran Sirwan!';
    }
  }

  Future<String> fetchGoogleProfilePicture() async {
    final googleSignIn = GoogleSignIn();
    final currentUser = await googleSignIn.signInSilently();

    if (currentUser != null && currentUser.photoUrl != null) {
      return currentUser.photoUrl!;
    } else {
      try {
        final googleAccount = await googleSignIn.signIn();
        if (googleAccount != null && googleAccount.photoUrl != null) {
          return googleAccount.photoUrl!;
        }
      } catch (error) {
        print('Error fetching profile picture: $error');
      }
    }

    return '';
  }

  String getUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.providerData
          .any((userInfo) => userInfo.providerId == 'google.com')) {
        final googleUser = GoogleSignIn().currentUser;
        return googleUser?.email ?? '';
      } else {
        return user.email ?? '';
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String firebaseUserName = currentUser?.displayName ?? 'Welcome!';
    final String? googleEmail = GoogleSignIn().currentUser?.email;
    return MaterialApp(
      themeAnimationCurve: Curves.easeInOut,
      themeAnimationDuration: Duration(seconds: 1),
      debugShowCheckedModeBanner: false,
      title: 'Recipe App',
      theme: isDark ? _darkTheme : _lightTheme,
      home: SafeArea(
        top: true,
        child: Scaffold(
          key: _scaffoldKey,
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<String>(
                        future: fetchGoogleUserName(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Show a loading indicator while fetching data
                          } else if (snapshot.hasError) {
                            return Text(
                                'Error: ${snapshot.error}'); // Show an error message if fetching data fails
                          } else {
                            final googleUserName = snapshot.data ?? '';
                            return Text(
                              isFirebaseUser
                                  ? 'Hello, $firebaseUserName'
                                  : 'Hello, $googleUserName',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : Color.fromARGB(255, 58, 58, 58),
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 6),
                      Text(
                        'What do you want to cook Today 😊?',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Color.fromARGB(255, 158, 157, 160),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                    onHorizontalDragEnd: (details) =>
                        _scaffoldKey.currentState?.openEndDrawer(),
                    child: FutureBuilder<String>(
                      future: checkFirebaseUserSignIn(),
                      builder: (context, snapshot) {
                        if (widget.googleUser != null) {
                          // Google user is signed in
                          return Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('assets/images/unnamed.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else if (widget.firebaseUser != null) {
                          // Firebase user is signed in
                          return Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('assets/images/pfp.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else {
                          // No user signed in
                          return Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('assets/images/unnamed.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 251, 183, 44), width: 2)),
                  focusColor: Colors.white,
                  prefixIcon: Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    size: 20,
                    color: Color.fromARGB(255, 251, 183, 44),
                  ),
                  hintText: 'Find your Favorite recipe...',
                  // helperText: 'Search among thousands of recipes',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                  filled: true,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: double.infinity,
              child: Expanded(
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Container(
                      width: 126,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Color.fromARGB(255, 55, 55, 60)
                            : Color.fromARGB(255, 176, 181, 181),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          'Popular',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      width: 126,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Color.fromARGB(255, 38, 38, 41)
                            : Color.fromARGB(255, 210, 214, 214),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          'Trending',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      width: 126,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Color.fromARGB(255, 38, 38, 41)
                            : Color.fromARGB(255, 210, 214, 214),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          'New',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  )
                ]),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${_recipes.length} New recipes added 💫',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 255, 200, 0),
                      ),
                    )
                  : SizedBox(
                      height: double.infinity,
                      child: GridView.custom(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        gridDelegate: SliverWovenGridDelegate.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 8,
                          pattern: [
                            WovenGridTile(
                              0.65,
                              crossAxisRatio: 1,
                            ),
                            WovenGridTile(
                              0.56,
                              crossAxisRatio: 1,
                            ),
                          ],
                        ),
                        childrenDelegate: SliverChildBuilderDelegate(
                            childCount: _recipes.length, (context, index) {
                          final title = _recipes[index].name;
                          final image = _recipes[index].images;
                          final totalTime = _recipes[index].totalTime;
                          final rating = _recipes[index].rating;
                          final description = _recipes[index].description;
                          final prepStep1 = _recipes[index].prepStep1;
                          final prepStep2 = _recipes[index].prepStep2;
                          final prepStep3 = _recipes[index].prepStep3;
                          final prepStep4 = _recipes[index].prepStep4;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Theme(
                                        data: isDark ? _darkTheme : _lightTheme,
                                        child: RecDetail(
                                          recipeName: title,
                                          recipe: Recipe(
                                            name: title,
                                            images: image,
                                            totalTime: totalTime,
                                            rating: rating,
                                            description: description,
                                            prepStep1: prepStep1,
                                            prepStep2: prepStep2,
                                            prepStep3: prepStep3,
                                            prepStep4: prepStep4,

                                            // description: description
                                            // proteins: proteins,
                                            // carbohydrates: carbohydrates,
                                            // fats: fats
                                          ),
                                        ),
                                      ),
                                    ));
                              },
                              child: Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Color.fromARGB(255, 38, 38, 41)
                                      : Color.fromARGB(255, 210, 214, 214),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          image: DecorationImage(
                                              image:
                                                  NetworkImage(image, scale: 1),
                                              fit: BoxFit.cover)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Text(
                                        '$title',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.clock,
                                          size: 22,
                                          color:
                                              Color.fromARGB(255, 251, 183, 44),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          '${totalTime}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
            ),
          ]),
          endDrawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Color.fromARGB(255, 64, 66, 66)
                        : Color.fromARGB(255, 210, 214, 214),
                  ),
                  child: FutureBuilder<String>(
                    future: fetchGoogleUserName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // Show a loading indicator while fetching data
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error: ${snapshot.error}'); // Show an error message if fetching data fails
                      } else {
                        final imageUrl = snapshot.data ?? '';
                        Widget profileImage;
                        if (isFirebaseUser) {
                          profileImage = Container(
                              width: 70,
                              height: 70,
                              child: CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/pfp.jpg'),
                              ));
                        } else {
                          profileImage = Container(
                            width: 70,
                            height: 70,
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/unnamed.jpg'),
                            ),
                          );
                        }
                        return Column(
                          children: [
                            profileImage,
                            SizedBox(height: 10),
                            FutureBuilder<String>(
                              future: fetchGoogleUserName(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  final googleUserName = snapshot.data ?? '';
                                  return Text(
                                    isFirebaseUser
                                        ? 'Welcome, $firebaseUserName'
                                        : 'Welcome, $googleUserName',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : Color.fromARGB(255, 58, 58, 58),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                              },
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              getUserEmail(),
                              style: TextStyle(
                                  color: isDark
                                      ? Color.fromARGB(255, 186, 188, 188)
                                      : Color.fromARGB(255, 58, 58, 58)),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(
                    isDark
                        ? FontAwesomeIcons.solidSun
                        : FontAwesomeIcons.solidMoon,
                    color: Color.fromARGB(255, 255, 200, 0),
                  ),
                  title: Text('Toggle Theme'),
                  trailing: CupertinoSwitch(
                    activeColor: Color.fromARGB(255, 255, 200, 0),
                    value: isDark,
                    onChanged: (value) {
                      setState(() {
                        isDark = value;
                        _saveTheme(isDark);
                      });
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Color.fromARGB(255, 255, 200, 0),
                  ),
                  title: Text('Home'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(
                    Icons.favorite,
                    color: Color.fromARGB(255, 255, 200, 0),
                  ),
                  title: Text('Favorites'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Theme(
                          data: isDark
                              ? _darkTheme
                              : _lightTheme, // Use the theme data from the current context
                          child: FavoritesScreen(),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Color.fromARGB(255, 255, 200, 0),
                  ),
                  title: Text('Settings'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout_outlined,
                    color: Color.fromARGB(255, 255, 200, 0),
                  ),
                  title: Text('Log out'),
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          backgroundColor: isDark
                              ? Color.fromARGB(255, 38, 38, 41)
                              : Colors.white,
                          title: Text(
                            'Log Out',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          content: Text(
                            'Are you sure you want to log out?',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 251, 183, 44),
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  primary: Color.fromARGB(255, 251, 183, 44),
                                  fixedSize: Size(100, 50)),
                              onPressed: () async {
                                // Perform logout
                                Future<void> logout() async {
                                  await FirebaseAuth.instance.signOut();
                                  GoogleSignIn googleSignIn = GoogleSignIn();
                                  await googleSignIn.signOut();
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.remove('isLoggedIn');
                                }

                                await logout();

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                child: Text(
                                  'Log Out',
                                  style: TextStyle(
                                    color: isDark ? Colors.black : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
