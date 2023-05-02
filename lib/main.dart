import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app_finproj/screens/home.dart';
import 'package:food_recipe_app_finproj/screens/loginScreen.dart';
import 'package:food_recipe_app_finproj/service/favorites.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  // Check if a user is already signed in
  User? user = FirebaseAuth.instance.currentUser;

  runApp(ChangeNotifierProvider(
    create: (context) => FavoritesProvider(),
    child: Main(
      user: user,
      isLoggedIn: isLoggedIn,
    ),
  ));
}

class Main extends StatelessWidget {
  final User? user;
  final bool isLoggedIn;

  Main({Key? key, required this.user, required this.isLoggedIn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      home: user != null ? Home() : LoginScreen(),
    );
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold();
}
