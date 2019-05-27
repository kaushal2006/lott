import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

//https://firebase.google.com/docs/auth/web/manage-users
//https://github.com/tattwei46/flutter_login_demo/blob/master/lib/services/authentication.dart
//https://medium.com/flutterpub/flutter-how-to-do-user-login-with-firebase-a6af760b14d5
abstract class BaseAuth {
  Future<FirebaseUser> getCurrentUser();

  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password, String displayName);
  Future<void> sendPasswordResetEmail(String emailAddress);
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();

  Future<void> signOut();

  Future<String> googleSignIn();
  Future<void> googleSignOut();
  
  Future<String> facebookSignIn();
  Future<void> facebookSignOut();  
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();

  Future<String> facebookSignIn() async {
    final FacebookLoginResult result = await _facebookLogin
        .logInWithReadPermissions(['email']).catchError((onError) {
      print("Error $onError");
    });
    if (result != null && result.status == FacebookLoginStatus.loggedIn) {
      final AuthCredential credential = FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token,
      );
      final FirebaseUser user = await _firebaseAuth
          .signInWithCredential(credential)
          .catchError((onError) {
        print("error $onError");
      });

      if(!user.isEmailVerified)
      {
        sendEmailVerification();
      }
      print("signed in " + user.displayName);
      return user.uid;
    }
    return null;
    /*
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print(result.accessToken.token);
        final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        );
        final FirebaseUser user =
            await _firebaseAuth.signInWithCredential(credential);
        print("signed in " + user.displayName);
        return user.uid;
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("Facebook Login: cancelled by user");
        return null;
        break;
      case FacebookLoginStatus.error:
        print(result.errorMessage);
        return null;
        break;
    }
    return null;*/
  }

//https://pub.dartlang.org/packages/firebase_auth#-readme-tab-
  Future<String> googleSignIn() async {
    final GoogleSignInAccount googleUser =
        await _googleSignIn.signIn().catchError((onError) {
      print("Error $onError");
    });

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user = await _firebaseAuth
          .signInWithCredential(credential)
          .catchError((onError) {
        print("error $onError");
      });
      if (user != null) {
        print("signed in " + user.displayName);
        return user.uid;
      }
    }
    return null;
  }

  Future<void> facebookSignOut() async {
    if (null != _facebookLogin.currentAccessToken)
      try {
        await _facebookLogin.logOut();
      } catch (e) {
        print("Facebook Signout Error:" + e);
      }
  }

  Future<void> googleSignOut() async {
    if (null != _googleSignIn.currentUser)
      try {
        await _googleSignIn.disconnect();
        await _googleSignIn.signOut();        
      } catch (e) {
        print("Google Signout Error:" + e);
      }
  }

  Future<String> signIn(String email, String password) async {
    final FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<String> signUp(
      String email, String password, String displayName) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    try {
      if (null != user) {
        UserUpdateInfo userInfo = new UserUpdateInfo();
        userInfo.displayName = displayName;
        user.updateProfile(userInfo);
      }
    } catch (e) {
      print("SINGUP: failed to set displayName");
    }
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    googleSignOut();
    facebookSignOut();
    _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<void> sendPasswordResetEmail(String emailAddress) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: emailAddress);
    } catch (e) {
      print(e);
    }
  }
}
/*import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
//https://www.youtube.com/watch?v=n9cClPtxUk0
abstract class  BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    user.email;
    return user?.uid;
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user?.uid;
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user?.uid;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
*/
