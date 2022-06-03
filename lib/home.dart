// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ktf/cart.dart';
import 'package:ktf/events.dart';
import 'package:ktf/merch.dart';
import 'package:ktf/profile.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}
/*
Crousel Widget Working

#  Create a widget using crousel(line no. )
#  You have to pass the
  1 - Name of the image to be displayed in the crousel widget. Eg - google.jpg(file must be present in the assets folder)
  2 - Name of the event.
  3 - Details of the event.
# After creating the widget you can use addToCarousel() pass the the widget you created and it
  will be added to List named carouselWidget.
# Now the crousel will be displayed.

*/

List<Widget> carouselWidget = [car, car2];

List<String> sponsorLogoFileName = [
  "dominos.png",
  "dell.png",
  "dominos.png",
  "dell.png",
  "dominos.png",
  "dell.png",
  "dominos.png",
  "dell.png"
];

Widget car =
    carousel("even_page.png", "Main Event Flashback", "Main Event FlashBack");
Widget car2 = carousel("even_page.png", "Card 2", "Main FlashBack");

Widget sponsorLogo(String image) {
  return Container(
    padding: EdgeInsets.only(right: 10),
    height: 80,
    width: 110,
    child: InkWell(
        borderRadius: BorderRadius.circular(80),
        onTap: () {},
        child: CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage("assets/" + image),
        )),
  );
}

addToCarousel(Widget carousel) {
  carouselWidget.add(carousel);
}

Widget carousel(String image, String name, String details) {
  return SizedBox(
    width: 530,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 20.0, left: 20, bottom: name.length <= 9 ? 20 : 13),
              child: Container(
                width: 135,
                child: AutoSizeText(
                  name,
                  style: GoogleFonts.sora(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 21),
                  maxLines: 2,
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 20, bottom: name.length <= 9 ? 30 : 15),
              child: Container(
                width: 160,
                child: Text(details,
                    style: GoogleFonts.sora(color: Colors.white, fontSize: 14)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: 30,
                  width: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      HexColor("#7F5AF0"),
                      HexColor("#481DCB"),
                    ]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "Know More",
                      style: GoogleFonts.sora(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        Container(
          padding: EdgeInsets.only(right: 1),
          width: 134,
          height: 150,
          child: Image.asset(
            "assets/" + image,
          ),
        ),
      ],
    ),
  );
}

class _homeState extends State<home> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
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

  String purl = "";
  @override
  void initState() {
    // this is called when the class is initialized or called for the first time
    super.initState();
    purl = FirebaseAuth.instance.currentUser!.photoURL.toString();
  }

  @override
  Widget build(BuildContext context) {
    double h(double height) {
      return MediaQuery.of(context).size.height * height;
    }

    double w(double width) {
      return MediaQuery.of(context).size.width * width;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        ///automaticallyImplyLeading: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext bs) => Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        QrImage(
                          data: '${FirebaseAuth.instance.currentUser!.uid}',
                          version: QrVersions.auto,
                          size: 320,
                          gapless: false,
                          embeddedImage: AssetImage('assets/msc logo.png'),
                          embeddedImageStyle: QrEmbeddedImageStyle(
                            size: Size(80, 80),
                          ),
                        ),
                        AutoSizeText(
                          "Use this QR to get your entry",
                          style: GoogleFonts.sora(
                              color: Colors.black, fontSize: 17),
                        )
                      ],
                    ));
          },
          child: Icon(
            Icons.qr_code,
            color: Colors.white,
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            //bottom navigation bar on scaffold
            color: Colors.black,
            shape: CircularNotchedRectangle(), //shape of notch
            notchMargin:
                5, //notch margin between floating button and bottom appbar
            child: Container(
              height: h(0.078),
              child: Row(
                //children inside bottom appbar
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext bs) => home()));
                    },
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext bs) => Profile()));
                    },
                  ),
                ],
              ),
            )),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Profile()));
              },
              style: OutlinedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(90))),
                side: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              child: Container(
                width: w(0.12),
                height: h(0.12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(purl), fit: BoxFit.scaleDown),
                ),
              ),
            ),
          ],

        ),
        backgroundColor: Colors.black,
        drawer: Padding(
          padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
            child: Drawer(
              backgroundColor: Colors.transparent,
              child: ListView(
                //padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                children: [
                  Container(
                    height: 60,
                    width: 1,
                    padding: const EdgeInsets.fromLTRB(30,0,0,0),
                    color: Colors.transparent,
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Icon(Icons.arrow_back_ios_rounded,color: Colors.white,)),


                  ),
                  Container(
                    height: 60,
                width: double.maxFinite,
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.adb_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(width: 20,),
                    Text("About App ",style: TextStyle(color: Colors.white),),
                  ],
                ),
                decoration: const BoxDecoration(
                  color: Colors.tealAccent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                  ),
                  Container(
                    height: 60,
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.account_circle,
                          color: Colors.white,
                        ),
                        SizedBox(width: 20,),
                        Text("Contact Us ",style: TextStyle(color: Colors.white),),
                      ],
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add_box_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(width: 20,),
                        Text("Help and Feedback ",style: TextStyle(color: Colors.white),),
                      ],
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    child: CarouselSlider.builder(
                      itemCount: carouselWidget.length == 1
                          ? 1
                          : carouselWidget.length,
                      options: CarouselOptions(
                        enableInfiniteScroll:
                            carouselWidget.length == 1 ? false : true,
                        enlargeCenterPage: true,
                        height: 170,
                        aspectRatio: 5.0,
                      ),
                      itemBuilder: (context, i, id) {
                        //for onTap to redirect to another screen
                        return GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: HexColor("#1B1B1B"),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: carouselWidget[i],
                          ),
                          onTap: () {},
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: h(0.06), left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sponsors",
                        style: GoogleFonts.sora(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(sponsorLogoFileName.length >= 5
                            ? Icons.arrow_forward_rounded
                            : null),
                        color: Colors.white,
                        tooltip: "More",
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for (int i = 0; i < sponsorLogoFileName.length; i++)
                            sponsorLogo(sponsorLogoFileName[i]),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Container(
                    height: h(0.5),
                    child: GridView.count(
                      childAspectRatio: 10 / 10.6,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 18,
                      crossAxisCount: 2,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            //border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/Robot.png"),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 50, left: 5),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                        //border: Border.all(color: Colors.white),
                                        ),
                                    child: AutoSizeText(
                                      "Unleash The Tech Event",
                                      style: GoogleFonts.sora(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Container(
                                      width: 120,
                                      decoration: BoxDecoration(
                                          //border: Border.all(color: Colors.white),

                                          ),
                                      child: AutoSizeText(
                                        "Join the great creators",
                                        style: GoogleFonts.sora(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                        maxLines: 2,
                                        maxFontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Container(
                                      width: 100,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(60)),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          Events()));
                                        },
                                        child: Center(
                                          child: Text(
                                            "Buy Now",
                                            style: GoogleFonts.sora(
                                              color: Colors.black,
                                              fontSize: 13,
                                            ),
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
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/cart.png"),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 50, left: 5),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                        //border: Border.all(color: Colors.white),
                                        ),
                                    child: Text(
                                      "Your Cart",
                                      style: GoogleFonts.sora(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Container(
                                      width: 120,
                                      decoration: BoxDecoration(
                                          //border: Border.all(color: Colors.white),
                                          ),
                                      child: AutoSizeText(
                                        "Looks like you are not interested in many events...",
                                        style: GoogleFonts.sora(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                        maxLines: 3,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 7.0),
                                    child: Container(
                                      width: 80,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(60)),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          cart()));
                                        },
                                        child: Center(
                                          child: Text(
                                            "View",
                                            style: GoogleFonts.sora(
                                              color: Colors.black,
                                              fontSize: 13,
                                            ),
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
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/MSC.png"),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 50, left: 5),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 120,
                                    decoration: BoxDecoration(
                                        //border: Border.all(color: Colors.white),
                                        ),
                                    child: Text(
                                      "Get your exclusive merch",
                                      style: GoogleFonts.sora(
                                          fontSize: 13.9,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Container(
                                      width: 120,
                                      decoration: BoxDecoration(
                                          //border: Border.all(color: Colors.white),
                                          ),
                                      child: Text(
                                        "Join the  MSC tribe",
                                        style: GoogleFonts.sora(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Container(
                                      width: 80,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          Merch()));
                                        },
                                        child: Center(
                                          child: Text(
                                            "Buy Now",
                                            style: GoogleFonts.sora(
                                              color: Colors.black,
                                              fontSize: 13,
                                            ),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// ListTile(
//
//   leading: Icon(
//     Icons.home,
//     color: Colors.teal,
//   ),
//   title: Text("Home"),
//   onTap: () {},
// ),
// ListTile(
//   leading: Icon(
//     Icons.exit_to_app,
//     color: Colors.teal,
//   ),
//   title: Text("Logout"),
//   onTap: () {
//     // _auth.signOut();
//     // Navigator.pop(context);
//     //exit(0);
//   },
// ),
// Text(
//   "© MSC KIIT",
//   textAlign: TextAlign.center,
// ),
