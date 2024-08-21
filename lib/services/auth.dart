import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart'; // Import your UserModel

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> registerWithEmailAndPassword(
      String email, String password, String firstName, String lastName) async {
    try {
      // Create user with email and password
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Create UserModel instance
        print("----------------------");
        UserModel newUser = UserModel(
          uid: user.uid,
          firstName: firstName,
          lastName: lastName,
          email: email,
        );

        // Store additional user data in Firestore
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        print("----------------------");
        print(newUser);

        return newUser;
      }

      return null;
    } catch (e) {
      print(e); // Handle errors here
      return null;
    }
  }
}
