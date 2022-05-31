import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ktf/home.dart';
import 'package:ktf/registration.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
  Future<bool> createUser() async{
    final String id= await FirebaseAuth.instance.currentUser!.getIdToken(false);
    final String? dn=FirebaseAuth.instance.currentUser!.displayName;
    final String? em=FirebaseAuth.instance.currentUser!.email;
    final String? pu=FirebaseAuth.instance.currentUser!.photoURL;
    final String ui=FirebaseAuth.instance.currentUser!.uid;
    final response=await http.post(
      Uri.parse('https://ktf-backend.herokuapp.com/auth/google-data'),
      headers: <String, String>{
        "Authorization": "Bearer $id",
        "content-type": "application/json"
      },
      body: jsonEncode(<String, String>{
        "displayName": dn.toString(),
        "email": em.toString(),
        "photoURL": pu.toString(),
        "uid": ui.toString(),
      }),

    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      print(response.statusCode);
      if(response.body.contains("User already exists")){
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext bs)=>home()));
      }
      else{
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext bs)=>register()));
      }
      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      print(response.statusCode);
      print(response.body);
      return false;
    }
  }
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
                        ),
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
                                    if(createUser()==true){
                                      print(createUser())
                                    }
                                  //print(FirebaseAuth.instance.currentUser!.uid.toString())
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
