// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Image.asset("assets/dp.png"),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 220.0, top: 120),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(17),
                    onTap: () {},
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 17,
                      child: Icon(Icons.edit),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "Shashank Deepak",
                style: GoogleFonts.sora(
                    color: HexColor("#2CB67D"),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "dummyemail@dum.com",
                style: GoogleFonts.sora(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
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
                  Text(
                    "12/04/2022",
                    style: GoogleFonts.sora(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, bottom: 20, right: 20, top: 50),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {},
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
