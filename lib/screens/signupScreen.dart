// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app_finproj/screens/loginScreen.dart';
import 'package:lottie/lottie.dart';

import 'home.dart';

class signupScreen extends StatefulWidget {
  signupScreen({super.key});

  @override
  State<signupScreen> createState() => _signupScreenState();
}

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class _signupScreenState extends State<signupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 0,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 31, 31, 33),
        title: Text('Register'),
      ),
      backgroundColor: Color.fromARGB(255, 31, 31, 33),
      body: ListView(
        physics: ScrollPhysics(parent: BouncingScrollPhysics()),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              height: 265,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(65),
                color: Color.fromARGB(255, 15, 15, 16),
              ),
              child: Stack(
                children: [
                  Positioned(
                      left: 10,
                      right: 10,
                      top: -50,
                      child: Lottie.asset('assets/lottie/pan.json',
                          fit: BoxFit.cover)),
                  Center(
                      child: Text('Sign Up!',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 65,
                              fontWeight: FontWeight.w700))),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: TextFormField(
                    controller: _firstNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 22),
                      filled: true,
                      fillColor: Color.fromARGB(255, 61, 63, 69),
                      prefixIcon: Icon(Icons.person, color: Colors.white),
                      label: Text('First Name',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300)),
                      hintText: 'Zhiar',
                      hintStyle: TextStyle(color: Colors.white24),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(55),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.8)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(55),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 251, 183, 44),
                              width: 3)),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: TextFormField(
                    controller: _lastNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 22),
                      filled: true,
                      fillColor: Color.fromARGB(255, 61, 63, 69),
                      prefixIcon: Icon(Icons.person, color: Colors.white),
                      label: Text('Last Name',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300)),
                      hintText: 'Ahmed',
                      hintStyle: TextStyle(color: Colors.white24),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(55),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.8)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(55),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 251, 183, 44),
                              width: 3)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: TextFormField(
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 22),
                filled: true,
                fillColor: Color.fromARGB(255, 61, 63, 69),
                prefixIcon: Icon(Icons.email_rounded, color: Colors.white),
                label: Text('Your Email',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300)),
                hintText: 'example@mail.com',
                hintStyle: TextStyle(color: Colors.white24),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(55),
                    borderSide: BorderSide(color: Colors.white, width: 1.8)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(55),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 251, 183, 44), width: 3)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 18),
            child: TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              style: TextStyle(color: Colors.white),
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 22),
                filled: true,
                fillColor: Color.fromARGB(255, 61, 63, 69),
                prefixIcon: Icon(Icons.key, color: Colors.white),
                label: Text('Your Password',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300)),
                hintText: 'password',
                hintStyle: TextStyle(color: Colors.white24),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(55),
                    borderSide: BorderSide(color: Colors.white, width: 1.8)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(55),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 251, 183, 44), width: 3)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 85, vertical: 5),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color.fromARGB(255, 251, 183, 44),
              ),
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      fixedSize: Size(80, 75)),
                  onPressed: () async {
                    _formKey.currentState?.save();
                    if (_formKey.currentState!.validate()) {
                      // Perform signup
                      try {
                        final auth = FirebaseAuth.instance;
                        final newUser =
                            await auth.createUserWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text);

                        // Get the email, password, first name, and last name from the text controllers
                        String email = _emailController.text;
                        String password = _passwordController.text;
                        String firstName = _firstNameController.text;
                        String lastName = _lastNameController.text;

                        // Update user's profile with first and last name
                        await newUser.user!
                            .updateProfile(displayName: '$firstName $lastName');

                        // Save user data to Firestore
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(newUser.user!.uid)
                            .set({
                          'email': email,
                          'password': password,
                          'firstName': firstName,
                          'lastName': lastName,
                        });

                        // Navigate to the Home screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      } catch (e) {
                        print('Signup error: $e');
                      }
                    }
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
