// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:share_food/models/user.dart';
// import 'package:share_food/services/database.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   //create user obj
//   MyUser? _userFromFirebase(User? user) {
//     return user != null ? MyUser(uid: user.uid) : null;
//   }

//   //auth change user stream
//   Stream<MyUser?> get user {
//     return _auth.authStateChanges().map(_userFromFirebase);
//   }

//   Future signInAnon() async {
//     try {
//       UserCredential result = await _auth.signInAnonymously();

//       User? user = result.user;
//       return _userFromFirebase(user);
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }

//   //sigup with google

//   // sign in usig eamil and p[assword]
//   Future signinWithEmail(String email, String password) async {
//     try {
//       UserCredential result = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       User? user = result.user;
//       return _userFromFirebase(user);
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }

//   // regster with eamil and passkey
//   Future registerWithEmail(String name, String mobile,String log, String email, String password) async {
//     try {
//       UserCredential result = await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       User? user = result.user;
//       //
//       await Database(uid: user!.uid).createUserData(name, 'city', mobile, log,user.uid);
//       return _userFromFirebase(user);
//     }on FirebaseAuthException catch(e){
//       if(e.code=='email-already-in-use'){
//         print('The account  already esits');
//       }
//     } 
    
//     catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }

//   //sign out
//   Future signOut() async {
//     try {
//       return await _auth.signOut();
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }
// }
