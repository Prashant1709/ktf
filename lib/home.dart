// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ktf/merch.dart';
import 'package:ktf/profile.dart';

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
Widget car2 = carousel("even_page.png", "Car 2", "Main FlashBack");

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
  return Container(
    width: 540,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 20.0, left: 20, bottom: name.length <= 9 ? 20 : 13),
              child: Container(
                width: 135,
                child: Text(
                  name,
                  style: GoogleFonts.sora(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 21),
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
  @override
  Widget build(BuildContext context) {
    double h(double height) {
      return MediaQuery.of(context).size.height * height;
    }

    double w(double width) {
      return MediaQuery.of(context).size.width * width;
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        // unselectedLabelStyle: TextStyle(color: Colors.white),

          backgroundColor: Colors.black,
          unselectedLabelStyle:
          const TextStyle(color: Colors.white, fontSize: 14),
          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.account_circle, color: Colors.white),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag, color: Colors.white),
                label: "Shop"),
          ]),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          CircleAvatar(
            radius: 30,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Profile())),
              child: Image.asset("assets/google.png"),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.transparent),
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.black,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
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
                    itemCount:
                    carouselWidget.length == 1 ? 1 : carouselWidget.length,
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
                                  child: Text(
                                    "Unleash The Tech Event",
                                    style: GoogleFonts.sora(
                                        fontSize: 14,
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
                                    child: Text(
                                      "Join with the great creators",
                                      style: GoogleFonts.sora(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    width: 100,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(60)),
                                    child: InkWell(
                                      onTap: () {
                                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Home()));
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
                                    child: Text(
                                      "Looks like you are not interested in may events...",
                                      style: GoogleFonts.sora(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    width: 80,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(60)),
                                    child: InkWell(
                                      onTap: () {
                                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Home()));
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
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Merch()));
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
    );
  }
}