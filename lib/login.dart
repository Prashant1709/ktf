// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ktf/home.dart';
import 'package:ktf/main.dart';
import 'package:text_divider/text_divider.dart';

class logIn extends StatefulWidget {
  const logIn({super.key});

  @override
  State<logIn> createState() => _logInState();
}

class _logInState extends State<logIn> {
  @override
  double h(double height) {
    return MediaQuery.of(context).size.height * height;
  }

  double w(double width) {
    return MediaQuery.of(context).size.width * width;
  }

  Widget build(BuildContext context) {
    return Scaffold(
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
                height: h(0.7),
                width: w(0.79),
                borderRadius: BorderRadius.circular(50),
                borderColor: Colors.white,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 40),
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
                                "Sign Up",
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
                          thickness: 1),
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
                            onTap: () {},
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
                                        fontSize: 12,
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
    );
  }
}
