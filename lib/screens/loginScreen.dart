// ignore_for_file: file_names
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_recipe_app_finproj/screens/home.dart';
import 'package:food_recipe_app_finproj/screens/signupScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isLoggedIn = false;

  final _formKey = GlobalKey<FormState>();

  String? _email;
  String? _password;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        // Sign-in successful, now authenticate with Firebase
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ));
      }
    } catch (e) {
      // Handle sign-in error
      print('Sign-in with Google failed: $e');
    }
  }

  Future<void> login() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email!,
          password: _password!,
        );

        // Login successful, navigate to the Home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
        // Save login status in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Handle user not found error
      } else if (e.code == 'wrong-password') {
        // Handle wrong password error
      }
      // Handle other authentication errors
    }
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // User is already logged in, navigate to the home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    }
  }

  Future<void> _signInWithPhoneNumber(BuildContext context) async {
    String phoneNumber = ''; // Initialize the phone number variable
    String verificationId = '';

    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException exception) {
      print('Phone verification failed: ${exception.message}');
      // Handle verification failure
    };

    final PhoneCodeSent codeSent = (String verId, int? resendToken) {
      verificationId = verId;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          String smsCode = '';
          return AlertDialog(
            title: const Text('Enter SMS Code'),
            content: TextField(
              onChanged: (value) {
                smsCode = value;
              },
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (smsCode.isNotEmpty) {
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: smsCode,
                    );
                    await FirebaseAuth.instance
                        .signInWithCredential(credential);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          );
        },
      );
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verId) {
      verificationId = verId;
    };

    // Prompt the user to enter their phone number
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Phone Number'),
          content: TextField(
            onChanged: (value) {
              phoneNumber = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (phoneNumber.isNotEmpty) {
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: phoneNumber,
                    verificationCompleted: verificationCompleted,
                    verificationFailed: verificationFailed,
                    codeSent: codeSent,
                    codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
                  );
                }
                Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color.fromARGB(255, 31, 31, 33),
      body: ListView(
        physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2.7,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bg5.jpg"),
                  fit: BoxFit.cover),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value;
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 22),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 61, 63, 69),
                      prefixIcon: const Icon(Icons.person, color: Colors.white),
                      label: const Text('Your Email',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300)),
                      hintText: 'example@mail.com',
                      hintStyle: const TextStyle(color: Colors.white24),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(55),
                          borderSide: const BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(55),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 251, 183, 44),
                              width: 3)),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value;
                    },
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 22),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 61, 63, 69),
                      prefixIcon: const Icon(Icons.key, color: Colors.white),
                      label: const Text('Your Password',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300)),
                      hintText: 'password',
                      hintStyle: const TextStyle(color: Colors.white24),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(55),
                          borderSide: const BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(55),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 251, 183, 44),
                              width: 2.5)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 85, vertical: 5),
              child: GestureDetector(
                onTap: login,
                child: Container(
                  width: 150,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(55),
                    color: const Color.fromARGB(255, 251, 183, 44),
                  ),
                  child: const Center(
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                          color: Color.fromARGB(255, 31, 31, 33),
                          fontSize: 21,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                TextButton(
                  child: const Text(
                    'Sign up',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => signupScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: ElevatedButton.icon(
              icon: const Icon(
                FontAwesomeIcons.google,
                size: 30,
              ),
              label: const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'Sign in with Google',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  fixedSize: const Size(20, 65)),
              onPressed: _signInWithGoogle,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.phone,
                  size: 35,
                ),
                label: const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Sign in with Phone Number',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  fixedSize: const Size(25, 65),
                ),
                onPressed: () {
                  _signInWithPhoneNumber(context);
                }
                // Set onPressed to null initially
                ),
          ),
        ],
      ),
    );
  }
}
