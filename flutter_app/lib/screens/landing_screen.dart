import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math' as math;

import '../models/user.dart';
import '../screens/home_screen.dart';
import '../services/auth_service.dart';
import '../services/cloud_firestore_service.dart';
import '../services/firebase_storage_service.dart';
import '../utils/constants.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late GoogleSignIn _googleSignIn;
  late SharedPreferences _sharedPreferences;
  late FirebaseAuth _firebaseAuth;
  late FirebaseFirestore _firestore;
  late FirebaseStorage _firebaseStorage;
  late User? _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn();
    _sharedPreferences = await SharedPreferences.getInstance();
    _firebaseAuth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    _firebaseStorage = FirebaseStorage.instance;
    _currentUser = _firebaseAuth.currentUser;
  }

  @override
  void dispose() {
    _googleSignIn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement Google Sign-In
                },
                icon: const GoogleIcon(),
                label: const Text('Sign in with Google'),
              ),
            ),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement Apple Sign-In
                },
                icon: const Icon(Icons.apple),
                label: const Text('Sign in with Apple'),
              ),
            ),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement Facebook Sign-In
                },
                icon: const Icon(Icons.facebook),
                label: const Text('Sign in with Facebook'),
              ),
            ),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement Twitter Sign-In
                },
                icon: const Icon(Icons.twitter),
                label: const Text('Sign in with Twitter'),
              ),
            ),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement GitHub Sign-In
                },
                icon: const Icon(Icons.github),
                label: const Text('Sign in with GitHub'),
              ),
            ),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement Email Sign-In
                },
                icon: const Icon(Icons.email),
                label: const Text('Sign in with Email'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}