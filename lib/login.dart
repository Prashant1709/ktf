import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ktf/home.dart';
import 'package:text_divider/text_divider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class logIn extends StatefulWidget {
  const logIn({super.key});

  @override
  State<logIn> createState() => _logInState();
}
Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class _logInState extends State<logIn> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(), // <-- SEE HERE
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }
  @override
  double h(double height) {
    return MediaQuery.of(context).size.height * height;
  }

  double w(double width) {
    return MediaQuery.of(context).size.width * width;
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: h(1),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: GlassContainer.frostedGlass(
                  height: h(0.5),
                  width: w(0.79),
                  borderRadius: BorderRadius.circular(50),
                  borderColor: Colors.white,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Container(
                            height: h(0.2),
                            width: w(0.48),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/msc logo.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),/*
                        Padding(
                          padding:
                          EdgeInsets.only(left: 20.0, right: 20, top: 30),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(20)),
                            width: w(1),
                            height: 50,
                            padding: EdgeInsets.only(left: 20),
                            child: TextFormField(
                              style: TextStyle(fontSize: 18, color: Colors.black),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Username",
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, bottom: 10, right: 20, top: 20),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(20)),
                            width: w(1),
                            height: 50,
                            padding: EdgeInsets.only(left: 20),
                            child: TextFormField(
                              style: TextStyle(fontSize: 18, color: Colors.black),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, bottom: 20, right: 20, top: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                color: HexColor("#2CB67D"),
                                border: Border.all(color: HexColor("#2CB67D")),
                                borderRadius: BorderRadius.circular(20)),
                            width: w(1),
                            height: 50,
                            padding: EdgeInsets.only(left: 20),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => home()));
                              },
                              child: Center(
                                child: Text(
                                  "Sign In",
                                  style: GoogleFonts.sora(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        TextDivider.horizontal(
                            text: const Text('or',
                                style: TextStyle(color: Colors.white)),
                            color: Colors.white,
                            thickness: 1),*/
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, bottom: 20, right: 20, top: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(20)),
                            width: w(1),
                            height: 50,
                            padding: EdgeInsets.only(left: 20),
                            child: InkWell(
                              onTap: () async {
                                try {
                                  await signInWithGoogle().whenComplete(() => {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => home()))
                                  });
                                } on FirebaseAuthException catch  (e) {
                                  //print('Failed with error code: ${e.code}');
                                  showDialog(context: context, builder: (BuildContext b){
                                    return AlertDialog(
                                      title: Text("Login Failed due to ${e.message}"),
                                    );
                                  });
                                  //print(e.message);
                                }
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(padding: EdgeInsets.only(left: 5)),
                                    Image(
                                        image: AssetImage("assets/google.png"),
                                        height: 20),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Sign in with google",
                                        style: GoogleFonts.sora(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
