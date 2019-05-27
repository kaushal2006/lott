import 'package:flutter/material.dart';
import 'package:lott/singletons/app_data.dart';
import 'package:lott/screens/home_screen.dart';
import 'package:lott/screens/auth_screen.dart';
//import 'package:lott/common/route_list.dart';
import 'package:lott/models/user.dart';

class RootScreen extends StatefulWidget {
  //final BaseAuth _auth = AppData().getAuth();

  @override
  State<StatefulWidget> createState() => new _RootScreenState();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
  LOGGED_IN_PENDING_EMAIL_VERIFICATION
}

class _RootScreenState extends State<RootScreen> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    AppData().getAuth().getCurrentUser().then((user) {
      AppData().clearUserData();
      setState(() {
        if (user != null) {
          _userId = user?.uid;
          _isEmailVerified = user?.isEmailVerified;
        }
        authStatus = user?.uid == null
            ? AuthStatus.NOT_LOGGED_IN
            : (_isEmailVerified
                ? AuthStatus.LOGGED_IN
                : AuthStatus.LOGGED_IN_PENDING_EMAIL_VERIFICATION);

        if (authStatus == AuthStatus.LOGGED_IN) {
          AppData().setUser(User(user.email));
          AppData()
              .getUser()
              .setFirstName(user.displayName != null ? user.displayName : "");
        }
      });
    });
  }

  void _onLoggedIn() async {
    AppData().getAuth().getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
        _isEmailVerified = user?.isEmailVerified;
        authStatus = _isEmailVerified
            ? AuthStatus.LOGGED_IN
            : AuthStatus.LOGGED_IN_PENDING_EMAIL_VERIFICATION;
        AppData().clearUserData();
        if (authStatus == AuthStatus.LOGGED_IN) {
          AppData().setUser(User(user.email));
          AppData()
              .getUser()
              .setFirstName(user.displayName != null ? user.displayName : "");
        }
      });
    });
    setState(() {
      authStatus = AuthStatus.NOT_DETERMINED;
    });
  }

  void _onSignedOut() {
    AppData().clearUserData();
    AppData().getAuth().signOut();
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
      _isEmailVerified = false;
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.green[50],
        child: CircularProgressIndicator(),
        //child: Center(child: Text("loading root_screen...")),
      ),
    );
  }

  Widget _buildPendingEmailVerificationScreen() {
    return AlertDialog(
      title: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          leading: Container(
            padding: EdgeInsets.only(left: 0),
            child: Icon(Icons.info, color: Colors.orange[300]),
          ),
          title: Text(
            "Pending Email Verification",
            style: TextStyle(
                color: Colors.orange[300], fontWeight: FontWeight.bold),
          )),
      content: new Text(
          "We sent you email, please follow the instruction to activate your account. Send me email again if you haven't received yet",
          style: TextStyle(color: Colors.grey)),
      actions: <Widget>[
        new RaisedButton(
          color: Colors.green[300],
          textColor: Colors.white,
          child: new Text("Dismiss"),
          onPressed: () {
            _onSignedOut();
          },
        ),
        new FlatButton(
          textColor: Colors.grey,
          child: new Text("Resend email"),
          onPressed: () {
            AppData().getAuth().sendEmailVerification().then((onValue) {
              _onSignedOut();
            }).catchError((onError) {
              print("SIGNUP: error sendEmailVerification");
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new AuthScreen(onSignedIn: _onLoggedIn);
        break;
      case AuthStatus.LOGGED_IN_PENDING_EMAIL_VERIFICATION:
        return _buildPendingEmailVerificationScreen();
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null && _isEmailVerified) {
          return new HomeScreen(onSignedOut: _onSignedOut);
        } else
          return _buildWaitingScreen();
        break;
      default:
        return _buildWaitingScreen();
    }
  }
}
