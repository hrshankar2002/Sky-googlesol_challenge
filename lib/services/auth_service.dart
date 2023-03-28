import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_proj_1/database_manager/database_manager.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

// registration with email and password

  Future createNewUser(String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      await DatabaseManager().createUserData(
          name,
          'Enter Location here',
          'Enter Description here',
          user.uid,
          'https://firebasestorage.googleapis.com/v0/b/fir-proj-1-45b20.appspot.com/o/images%2Fimg1.jpeg?alt=media&token=a3357d81-769f-4d86-86ee-616aa939a555');
      return user;
    } catch (e) {}
  }

// sign with email and password

  Future loginUser(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {}
  }

// signout

  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (error) {
      return null;
    }
  }
}
