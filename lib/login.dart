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
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class _logInState extends State<logIn> {
  String email="";
  String pass="";
  Future<dynamic> createUser() async {
    final String id =
        await FirebaseAuth.instance.currentUser!.getIdToken(false);
    final String? dn = FirebaseAuth.instance.currentUser!.displayName;
    final String? em = FirebaseAuth.instance.currentUser!.email;
    final String? pu = FirebaseAuth.instance.currentUser!.photoURL;
    final response = await http.post(
      Uri.parse('https://ktf-backend.herokuapp.com/auth/google-data'),
      headers: <String, String>{
        "Authorization": "Bearer $id",
        "content-type": "application/json"
      },
      body: jsonEncode(<String, dynamic>{
        "displayName": dn.toString(),
        "email": em.toString(),
        "photoURL": pu.toString(),
        //"uid": ui.toString(),
      }),
    );
    if (response.statusCode == 200) {
      print(response.body);
      print(response.statusCode);
      if (response.body.contains("User already exists")) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext bs) => const Home()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext bs) => const register()));
      }
      return const CircularProgressIndicator();
    } else {
      print(response.statusCode);
      print(response.body);
      return showDialog(
          context: context,
          builder: (BuildContext bs) => AlertDialog(
                title: Text(response.body),
              ));
    }
  }
  Future<dynamic> createEshan() async {
    final String id =
    await FirebaseAuth.instance.currentUser!.getIdToken(false);
    final String? dn = "Eshaan";
    final String? em = FirebaseAuth.instance.currentUser!.email;
    final String? pu = "https://lh3.googleusercontent.com/a/AATXAJzk0hp5_w1AWY8nRBMrI6QMzAm33eyOULeQPp_9=s96-c";
    final response = await http.post(
      Uri.parse('https://ktf-backend.herokuapp.com/auth/google-data'),
      headers: <String, String>{
        "Authorization": "Bearer $id",
        "content-type": "application/json"
      },
      body: jsonEncode(<String, dynamic>{
        "displayName": dn.toString(),
        "email": em.toString(),
        "photoURL": pu.toString(),
        //"uid": ui.toString(),
      }),
    );
    if (response.statusCode == 200) {
      print(response.body);
      print(response.statusCode);
      if (response.body.contains("User already exists")) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext bs) => const Home()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext bs) => const register()));
      }
      return const CircularProgressIndicator();
    } else {
      print(response.statusCode);
      print(response.body);
      return showDialog(
          context: context,
          builder: (BuildContext bs) => AlertDialog(
            title: Text(response.body),
          ));
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.black54,
      content: Row(
        children: [
          const CircularProgressIndicator(
            color: Colors.white,
          ),
          Container(
              margin: const EdgeInsets.only(left: 17),
              child: Text(
                "Loading...",
                style: GoogleFonts.sora(
                  color: Colors.white,
                ),
              )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(), // <-- SEE HERE
                child: const Text('Yes'),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: h(1),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: GlassContainer.frostedGlass(
                  height: h(0.7),
                  width: w(0.79),
                  borderRadius: BorderRadius.circular(50),
                  borderColor: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          height: h(0.2),
                          width: w(0.48),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/msc logo.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(5)),
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.7,
                        padding:const EdgeInsets.only(left: 4),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.mail,color: Colors.white,),
                              border: InputBorder.none,
                              hintText: "Email ID",
                              hintStyle: TextStyle(color: Colors.white)),
                          onChanged: (value)=>email=value,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(5)),
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.7,
                        padding:const EdgeInsets.only(left: 4),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.password,color: Colors.white,),
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.white)),
                          onChanged: (value)=>pass=value,
                        ),
                      ),
                      MaterialButton(onPressed: ()async{
                        try {
                          await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email,
                        password: pass
                        ).then((value) => {
                            showLoaderDialog(context),
                            createEshan()
                            //signInWithGoogle().then((value) => createUser())
                            //print(FirebaseAuth.instance.currentUser!.uid.toString())
                          });
                        } on FirebaseAuthException catch (e) {
                          //print('Failed with error code: ${e.code}');
                          showDialog(
                              context: context,
                              builder: (BuildContext b) {
                                return AlertDialog(
                                  title: Text(
                                      "Login Failed due to ${e.message}"),
                                );
                              });
                          //print(e.message);
                        }
                      },color: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),child: Text("Login",style: GoogleFonts.sora(color: Colors.black,fontSize: 16),),),
                      const Divider(color: Colors.grey,thickness: 1,indent: 10,endIndent: 10,),
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
                          padding: const EdgeInsets.only(left: 20),
                          child: InkWell(
                            onTap: () async {
                              try {
                                await signInWithGoogle().then((value) => {
                                      showLoaderDialog(context),
                                      createUser()
                                      //signInWithGoogle().then((value) => createUser())
                                      //print(FirebaseAuth.instance.currentUser!.uid.toString())
                                    });
                              } on FirebaseAuthException catch (e) {
                                //print('Failed with error code: ${e.code}');
                                showDialog(
                                    context: context,
                                    builder: (BuildContext b) {
                                      return AlertDialog(
                                        title: Text(
                                            "Login Failed due to ${e.message}"),
                                      );
                                    });
                                //print(e.message);
                              }
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                      padding:
                                          const EdgeInsets.only(left: 5)),
                                  const Image(
                                      image: const AssetImage(
                                          "assets/google.png"),
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
          ],
        ),
      ),
    );
  }
}
