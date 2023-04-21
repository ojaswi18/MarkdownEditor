import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meproject/models/user.dart';
import 'package:meproject/services/databases.dart';

class AuthServices {
  
  
  UserN _userFromFirebaseUser(User? user) {
    return UserN(uid: (user == null) ? '' : user.uid);
  }


  Stream<UserN> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  //sign in
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? fbuser = result.user;
      return {_userFromFirebaseUser(fbuser)};
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //signout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register
  Future registerWithEandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
          
      User? fbuser = result.user;
      // uidFinal=fbuser!.uid;
      // print(uidFinal);
      await DatabaseService(uid :fbuser!.uid).updateUserData([],'username' , '');
      return _userFromFirebaseUser(fbuser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  
}
}