import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/user.dart';

class DBHandler {
  static UserData currentUser;

  static Future<String> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      currentUser = new UserData();
      currentUser.email = email;

      FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: email)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          currentUser.cardNum = result.get('cardNum');
          currentUser.balance = result.get('balance');
          currentUser.name = result.get('name');
          currentUser.points = result.get('points');
          currentUser.ImageUrl= result.get('profilePic');
          print("!!!!!!@@@" + currentUser.balance.toString());
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }

      return e.toString();
    }
    return "";
  }

  static Future<String> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return e.toString();
    } catch (e) {
      print(e);
      return e.toString();
    }
    currentUser = new UserData();
    currentUser.email = FirebaseAuth.instance.currentUser.email;
    return "";
  }

  static Future<bool> signOut() async {
    await FirebaseAuth.instance.signOut();
    return true;
  }
}
