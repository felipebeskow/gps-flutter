import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Facebook Login",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var facebookLogin = new FacebookLogin();
  String photo = "";

  void loginWithFacebook() async {
    var result = await facebookLogin.logIn(['email', 'public_profile']);

    final facebookLoginResult = await facebookLogin.logIn(['email']);
    FacebookAccessToken myToken = facebookLoginResult.accessToken;

    AuthCredential credential= FacebookAuthProvider.getCredential(accessToken: myToken.token);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        FirebaseUser user =(await FirebaseAuth.instance.signInWithCredential(credential)).user;

        setState(() {
          photo = user.photoUrl;
        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("Facebook login cancelled");
        break;
      case FacebookLoginStatus.error:
        print(result.errorMessage);
        break;
    }
  }

  void facebookLogout() {
    facebookLogin.logOut();
    FirebaseAuth.instance.signOut();
    setState(() {
      photo = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              (photo != "")
                  ? Image.network(photo)
                  : new RaisedButton(
                child: Text("Conectar com o Facebook"),
                color: Colors.lightBlue,
                textColor: Colors.white,
                onPressed: loginWithFacebook,
              ),
              new RaisedButton(
                child: Text("Sair"),
                color: Colors.lightBlue,
                textColor: Colors.white,
                onPressed: facebookLogout,
              )
            ],
          ),
        ));
  }
}