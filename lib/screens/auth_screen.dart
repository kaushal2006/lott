import 'package:flutter/material.dart';
import 'package:lott/mixins/app_utils_mixin.dart';
import 'package:lott/singletons/app_data.dart';
import 'package:lott/mixins/validator_utils_mixin.dart';
//UI design
//https://www.youtube.com/watch?v=Dst-qoZF2Lc

class AuthScreen extends StatefulWidget {
  AuthScreen({this.onSignedIn});

  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _AuthScreenState();
}

enum FormMode { LOGIN, SIGNUP, FORGOT_PASSWORD }

class _AuthScreenState extends State<AuthScreen>
    with AppUtilsMixin, ValidatorMixin {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  // Initial form is login form
  FormMode _formMode = FormMode.LOGIN;
  bool _isIos;
  bool _isLoading;

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    setState(() {
      _isLoading = false;
    });
    return false;
  }

// Perform login or signup
  void _facebookLogin() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    try {
      String userId = "";
      userId = await AppData().getAuth().facebookSignIn();
      print('Signed in facebook: $userId');

      if (userId != null && userId.length > 0) {
        widget.onSignedIn();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');

      setState(() {
        _isLoading = false;
      });

      setState(() {
        if (_isIos) {
          _errorMessage = e.toString();
        } else
          _errorMessage = (null != e) ? e.message : "Something went wrong";
      });
    }
  }

  // Perform login or signup
  void _googleSingin() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    try {
      String userId = "";
      userId = await AppData().getAuth().googleSignIn();
      print('Signed in Google: $userId');

      if (userId != null && userId.length > 0) {
        widget.onSignedIn();
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
        if (_isIos) {
          _errorMessage = e.toString();
        } else
          _errorMessage = e.message;
      });
    }
  }

  void _validateResetPassword() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      if (_formMode == FormMode.FORGOT_PASSWORD) {
        AppData().getAuth().sendPasswordResetEmail(_email);
        _showForgotPasswordEmailSentDialog();
      }
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  // Perform login or signup
  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await AppData().getAuth().signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          userId = await AppData()
              .getAuth()
              .signUp(_email, _password, ""); //****name pending
          AppData().getAuth().sendEmailVerification();
          _showVerifyEmailSentDialog();
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 &&
            userId != null &&
            _formMode == FormMode.LOGIN) {
          widget.onSignedIn();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.toString();
          } else
            _errorMessage = e.message;
        });
      }
    }
  }

  void _changeFormToSignUp() {
    AppData().clearUserData();
    AppData().getAuth().signOut();
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    AppData().clearUserData();
    AppData().getAuth().signOut();
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  void _changeFormToForgotPassword() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.FORGOT_PASSWORD;
    });
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(
              //backgroundColor: Colors.yellow,
              ));
      //return Center(child: Text("loading auth_screen..."));
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                _changeFormToLogin();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showForgotPasswordEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Password reset email is sent"),
          content: new Text(
              "A message is sent to your email containing a link to reset your password."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                _changeFormToLogin();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showBody() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: _formMode == FormMode.FORGOT_PASSWORD
                ? <Widget>[
                    _showLogo(),
                    _showEmailInput(),
                    _showResetPasswordButton(),
                    _showBackToRootButton(),
                    _showErrorMessage(),
                  ]
                : <Widget>[
                    _showLogo(),
                    _showEmailInput(),
                    _showPasswordInput(),
                    _showForgotPasswordButton(),
                    _showPrimaryButton(),
                    _showErrorMessage(),
                    _showSecondaryButton(),
                    _showSeperator(),
                    _showSigninLabel(),
                    _showGoogleFBButtons(),
                    //_showGoogleButton(),
                    //_showFacebookButton(),
                  ],
          ),
        ));
  }

  Widget _showErrorMessage() {
    if (_errorMessage != null && _errorMessage.length > 0) {
      return new Container(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: Text(
          _errorMessage,
          style: TextStyle(color: Colors.red),
        ),
        alignment: Alignment.center,
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/fluttericon.png'),
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.green[300],
            )),
        validator: (value) => validateEmail(value),
        onSaved: (value) => _email = value,
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.green[300],
            )),
        validator: (value) => validatePassword(value),
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget _showSeperator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 5.0),
      child: new Container(
          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
          height: 1,
          color: Colors.grey[300]),
    );
  }

  Widget _showSigninLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: new Container(
        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: Center(child: Text("or Sign In with")),
      ),
    );
  }

  Widget _showGoogleFBButtons() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        child: SizedBox(
          height: 50.0,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new RaisedButton(
                elevation: 5.0,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                color: Colors.white,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 40.0,
                  child: Image.asset('assets/fireauth_ui/btn_google_icon.png'),
                ),
                onPressed: _googleSingin,
              ),
              new RaisedButton(
                elevation: 5.0,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                color: Colors.indigo[800],
                child: CircleAvatar(
                  backgroundColor: Colors.indigo[800],
                  radius: 40.0,
                  child:
                      Image.asset('assets/fireauth_ui/btn_facebook_icon.png'),
                ),
                onPressed: _facebookLogin,
              )
            ],
          ),
        ));
  }

/*
  Widget _showGoogleButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0)),
            color: Colors.white,
            child: new Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 48.0,
                  child: Image.asset('assets/fireauth_ui/btn_google_icon.png'),
                ),
                Text(
                  'Sign In with Google',
                  style: new TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 18.0),
                )
              ],
            ),
            onPressed: _googleSingin,
          ),
        ));
  }

  Widget _showFacebookButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0)),
            color: Colors.indigo[600],
            child: new Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 48.0,
                  child:
                      Image.asset('assets/fireauth_ui/btn_facebook_icon.png'),
                ),
                Text(
                  'Sign In with Facebook',
                  style: new TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18.0,
                      color: Colors.white),
                )
              ],
            ),
            onPressed: _facebookLogin,
          ),
        ));
  }
*/
  Widget _showSecondaryButton() {
    return new FlatButton(
      child: _formMode == FormMode.LOGIN
          ? new Text('Create an account')
          : new Text('Have an account? Sign in'),
      onPressed: _formMode == FormMode.LOGIN
          ? _changeFormToSignUp
          : _changeFormToLogin,
    );
  }

  Widget _showBackToRootButton() {
    return new FlatButton(
      child: new Text('Cancel'),
      onPressed: _changeFormToLogin,
    );
  }

  Widget _showForgotPasswordButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
      child: _formMode == FormMode.LOGIN
          ? new Container(
              alignment: Alignment.centerRight,
              child: new FlatButton(
                  child: new Text("Forgot pasword?"),
                  onPressed: () => _changeFormToForgotPassword()))
          : new Container(
              alignment: Alignment.centerRight,
              child: Text(""),
            ),
    );
  }

  Widget _showPrimaryButton() {
    return new MaterialButton(
      height: 50.0,
      //minWidth: 200.0,
      color: Colors.green[300],
      textColor: Colors.white,
      child: _formMode == FormMode.LOGIN
          ? new Text("Login")
          : new Text("Create Account"),
      onPressed: () => _validateAndSubmit(),
      splashColor: Colors.green,
    );
  }

  Widget _showResetPasswordButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: MaterialButton(
          height: 50.0,
          color: Colors.green[300],
          textColor: Colors.white,
          child: new Text("Reset Password"),
          onPressed: () => _validateResetPassword(),
          splashColor: Colors.green,
        ));
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return new Scaffold(
        body: Stack(
      children: <Widget>[
        _showBody(),
        _showCircularProgress(),
      ],
    ));
  }
}
