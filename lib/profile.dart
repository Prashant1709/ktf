// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ktf/login.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}
class Prof {
  final String join;

  const Prof({
    required this.join,
  });

  factory Prof.fromJson(Map<String, dynamic> json) {
    return Prof(
      join: json['createdAt'],

    );
  }
}
class _ProfileState extends State<Profile> {
  String purl="";
  String uname="";
  String email="";
  late Future<Prof> futureprof;
  Future<Prof> fetchDat() async {
    final String id= await FirebaseAuth.instance.currentUser!.getIdToken(false);
    final String uid= await FirebaseAuth.instance.currentUser!.uid;
    final response = await http
        .get(Uri.parse('https://ktf-backend.herokuapp.com/data/user'),
    headers: <String, String>{
      "Authorization": "Bearer $id",
      "content-type": "application/json"
    },);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.statusCode);
      print(response.body);
      return Prof.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load data');
    }
  }
  void initState() {         // this is called when the class is initialized or called for the first time
    super.initState();
    purl=FirebaseAuth.instance.currentUser!.photoURL.toString();
    uname=FirebaseAuth.instance.currentUser!.displayName.toString();
    email=FirebaseAuth.instance.currentUser!.email.toString();
    futureprof = fetchDat();
  }

  @override
  Widget build(BuildContext context) {
    double h(double height) {
      return MediaQuery.of(context).size.height * height;
    }

    double w(double width) {
      return MediaQuery.of(context).size.width * width;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: Text(
            "My Profile",
            style: GoogleFonts.sora(fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: SizedBox(
                      width: w(0.28),
                      child: Container(
                        width: w(0.1),
                        height: h(0.1),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(purl),
                              fit: BoxFit.scaleDown
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: AutoSizeText(
                "$uname",
                style: GoogleFonts.sora(
                    color: HexColor("#2CB67D"),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: AutoSizeText(
                "$email",
                style: GoogleFonts.sora(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
                maxLines: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 40.0, left: 10, right: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {},
                child: Container(
                  width: w(1),
                  height: h(0.07),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 29, 28, 28),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Notification",
                        style: GoogleFonts.sora(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 10, right: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {},
                child: Container(
                  width: w(1),
                  height: h(0.07),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 29, 28, 28),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Wishlist",
                        style: GoogleFonts.sora(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 70.0, left: 15),
              child: Row(
                children: [
                  Text(
                    "Joined: ",
                    style: GoogleFonts.sora(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w300),
                  ),
                  FutureBuilder<Prof>(
                    future: futureprof,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data!.join.substring(0,10),style: GoogleFonts.sora(fontSize: 18,color: Colors.white),);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      // By default, show a loading spinner.
                      return const CircularProgressIndicator(color: Colors.white,strokeWidth: 1,);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, bottom: 20, right: 20, top: 50),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  GoogleSignIn().signOut();
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => logIn()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: HexColor("#2CB67D"),
                      border: Border.all(color: HexColor("#2CB67D")),
                      borderRadius: BorderRadius.circular(20)),
                  width: w(1),
                  height: 50,
                  padding: EdgeInsets.only(left: 20),
                  child: Center(
                    child: Text(
                      "Log Out",
                      style: GoogleFonts.sora(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
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
