import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snapsheetapp/services/auth/auth_impl.dart';
import 'package:snapsheetapp/ui/config/config.dart';
import 'package:snapsheetapp/ui/shared/shared.dart';
import 'package:snapsheetapp/ui/views/screens.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthServiceImpl _auth = AuthServiceImpl();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String pwd = '';
  String error = '';
  bool obscurePwd = true;

  FocusNode pwdFocus;

  @override
  void initState() {
    super.initState();
    pwdFocus = FocusNode();
  }

  @override
  void dispose() {
    pwdFocus.dispose();
    super.dispose();
  }

  void login() async {
    if (_formKey.currentState.validate()) {
      setState(() => loading = true);
      dynamic result = await _auth.signInWithEmailAndPassword(email, pwd);

      if (result == null) {
        setState(() {
          error = 'Invalid email and password';
          loading = false;
        });
      }
    }
  }

  void loadingCallback() => loading = true;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Loading();
    } else {
      return GestureDetector(
        onTap: () => unfocus(context),
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: false,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SnapSheetBanner(),
                  SizedBox(height: 10.0),
                  Theme(
                    data:
                        Theme.of(context).copyWith(primaryColor: Colors.black),
                    child: TextFormField(
                      initialValue: email,
                      decoration: kEmailTextFieldDecoration,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.left,
                      validator: (val) =>
                          val.isEmpty ? "Enter a valid email" : null,
                      onChanged: (val) => setState(() => email = val),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (val) {
                        FocusScope.of(context).requestFocus(pwdFocus);
                      },
                    ),
                  ),
                  SizedBox(height: 12),
                  Theme(
                    data:
                        Theme.of(context).copyWith(primaryColor: Colors.black),
                    child: TextFormField(
                      initialValue: pwd,
                      decoration: kPasswordTextFieldDecoration.copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePwd
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() => obscurePwd = !obscurePwd);
                          },
                        ),
                      ),
                      cursorColor: Colors.black,
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical(y: 0),
                      obscureText: obscurePwd,
                      validator: (val) => val.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null,
                      onChanged: (val) => setState(() => pwd = val),
                      textInputAction: TextInputAction.done,
                      focusNode: pwdFocus,
                      onFieldSubmitted: (val) => login(),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                  RoundedButton(
                    textColor: Colors.white,
                    color: Colors.black,
                    onPressed: () {
                      login();
                    },
                    title: 'Login',
                    icon: Icon(
                      FontAwesomeIcons.solidEnvelope,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  Divider(),
                  RoundedButton(
                    textColor: Colors.black,
                    color: Colors.white,
                    onPressed: () async {
                      //Go to login screen.
                      setState(() => loading = true);
                      dynamic result = await _auth.signInWithGoogle();
                      setState(() => loading = false);
                    },
                    title: 'Login with Google',
                    icon: Icon(
                      FontAwesomeIcons.google,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                  SignUp()
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Don't have an account? ",
            style: TextStyle(fontSize: 12),
          ),
          GestureDetector(
            onTap: () {
              unfocus(context);
              return Navigator.pushNamed(context, SignupScreen.id);
            },
            child: Text(
              "Create account",
              style: kLoginSignupTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
