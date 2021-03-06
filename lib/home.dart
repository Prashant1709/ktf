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
import 'package:ktf/orders.dart';
import 'package:ktf/profile.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:ticket_widget/ticket_widget.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}




List<String> sponsorLogoFileName = [
  "mslogo.jpg",
  "Nvidia.png",
  "rasp.png",
  "dominos.png",
  "dell.png"
];
List<String> sponsorURL = [
  "https://www.microsoft.com/en-in/",
  "https://www.nvidia.com/en-in/",
  "https://www.raspberrypi.com/",
  "https://www.dominos.co.in/",
  "https://www.dell.com/en-in"
];

Widget car =
    carousel("even_page.png", "Welcome Aboard", "We are glad you're here");
Widget car2 = carousel("even_page.png", "Event-1", "I am event 1");
Widget car3 = carousel("even_page.png", "Event-2", "I am event 2");

Widget sponsorLogo(String image,String url) {
  return Container(
    padding: EdgeInsets.only(right: 10),
    height: 80,
    width: 110,
    child: InkWell(
        borderRadius: BorderRadius.circular(80),
        onTap: () async{
            if (!await launchUrl(Uri.parse(url),mode: LaunchMode.inAppWebView,webViewConfiguration: const WebViewConfiguration(
                headers: <String, String>{'my_header_key': 'my_header_value'}),)) throw 'Could not launch $url';
        },
        child: CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage("assets/$image"),
        )),
  );
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
                  top: 15.0, left: 20, bottom: name.length <= 9 ? 20 : 13),
              child: SizedBox(
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
              child: SizedBox(
                width: 160,
                child: Text(details,
                    style: GoogleFonts.sora(color: Colors.white, fontSize: 14)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: InkWell(
                onTap: () {

                },
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
            "assets/$image",
          ),
        ),
      ],
    ),
  );
}
class Prof {
  final String qr;

  const Prof({
    required this.qr,
  });

  factory Prof.fromJson(Map<String, dynamic> json) {
    return Prof(
      qr: json['qrCodeUrl'],

    );
  }
}
class _HomeState extends State<Home> {
  List<Widget> carouselWidget = [car, car2,car3];
  addToCarousel(Widget carousel) {
    carouselWidget.add(carousel);
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
              backgroundColor: Colors.black,
                isScrollControlled: true,
                context: context,
                builder: (BuildContext bs) => Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [TicketWidget(
                        height: h(0.6),
                        width: w(0.9),
                        isCornerRounded: true,
                        padding: const EdgeInsets.all(20),
                        color: Colors.teal,
                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: h(0.3),
                              width: w(0.65),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                //border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: QrImage(
                                  data: FirebaseAuth.instance.currentUser!.uid,
                                  version: QrVersions.auto,
                                  size: 150,
                                  gapless: false,
                                ),
                              ),
                            ),
                            Divider(color: Colors.white,thickness: 1,),
                            AutoSizeText(
                              "Your Digital Ticket",
                              style: GoogleFonts.sora(
                                  color: Colors.white, fontSize: 28),
                            )
                          ],
                        ),
                      ),
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
            child: SizedBox(
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
                              builder: (BuildContext bs) => Home()));
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
              backgroundColor: Colors.black54,
              child: ListView(
                //padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                children: [
                  SizedBox(height: 10,),
                  OutlinedButton(
                    onPressed: (){
                      showModalBottomSheet(
                        isScrollControlled: true,
                          backgroundColor: Colors.black,
                          context: context, builder: (BuildContext bs){
                        return SingleChildScrollView(child: Column(
                          children: [
                              SizedBox(height: h(0.1)),

                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                // height: 100,
                                // width: 500,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: h(0.25),
                                      child: Center(
                                        child: Image.asset("assets/msc logo.png"),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      // ignore: prefer_const_literals_to_create_immutables
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 57.0),
                                          child: Text(
                                            "Microsoft",
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.teal,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          "Student Community",
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.teal,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding:
                                          EdgeInsets.only(left: 63.0),
                                          child: Text(
                                            "KiiT Chapter",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.teal,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: h(0.05),
                              ),
                              //Divider(color: Colors.blue, thickness: 2),
                              Divider(color: Colors.white),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(color: Color.fromARGB(246, 2, 105, 184),
                                  elevation:10,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                        "Microsoft Learn Student Ambassadors are a global group of on-campus ambassadors sponsored by Microsoft who are eager to help fellow students, lead in their local tech community,and develop technical and career skills for the future. ",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                              Divider(color: Colors.white),

                              Center(
                                  child: Text("Developer Team",
                                      style: TextStyle(
                                          color: Colors.cyan, fontSize: 30))),
                              SizedBox(
                                height: h(0.02),
                              ),

                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(60),
                                      color: Color.fromARGB(246, 2, 105,
                                          184)), //rgba(2, 105, 184, 1)
                                  height: h(0.1),
                                  width: w(0.85),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      //???

                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text("Prashant Upadhyay",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          // SizedBox(
                                          //   width: width(0.18),
                                          // ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Text(
                                                    "??? Backend   ??? UI/UX   ??? Debugging",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                    )),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  )),
                              SizedBox(
                                height: h(0.015),
                              ),
                          ],
                        ));
                      });
                    },
                    child: Container(
                      height: 60,
                width: double.maxFinite,
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                    color: Colors.tealAccent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                ),
                child: Row(
                    children: [
                      Icon(
                        Icons.info,
                        color: Colors.white,
                      ),
                      SizedBox(width: 20,),
                      Text("About app ",style: TextStyle(color: Colors.white,fontSize: 20),),
                    ],
                ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  OutlinedButton(
                    onPressed: (){
                      showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.black,
                          context: context, builder: (BuildContext bs){
                        return Column(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Page in making",style: GoogleFonts.sora(color: Colors.white,fontSize: 32),)
                        ],
                        );
                      });
                    },
                    child: Container(
                      height: 60,
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        color: Color(0xffF1b1b1b),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.contact_support,
                            color: Colors.white,
                          ),
                          SizedBox(width: 20,),
                          Text("Contact Us ",style: TextStyle(color: Colors.white,fontSize: 20),),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  OutlinedButton(
                    onPressed: (){
                      showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.black,
                          context: context, builder: (BuildContext bs){
                        return Column(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Page in making",style: GoogleFonts.sora(color: Colors.white,fontSize: 32),)
                          ],
                        );
                      });
                    },
                    child: Container(
                      height: 60,
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        color: Color(0xffF1b1b1b),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.feedback,
                            color: Colors.white,
                          ),
                          SizedBox(width: 20,),
                          Text("Help and Feedback ",style: TextStyle(color: Colors.white,fontSize: 20),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
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
                      onTap: () {
                        if(i==1){
                          showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.black,
                              context: context, builder: (BuildContext bs){
                            return Column();
                          });
                        }
                        else{
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext bs)=>Events()));
                        }
                      },
                    );
                  },
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for (int i = 0; i < sponsorLogoFileName.length; i++)
                        sponsorLogo(sponsorLogoFileName[i],sponsorURL[i]),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: SizedBox(
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
                                        Navigator.push(
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
                                    "Your Orders",
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
                                      "Your purchase in one place",
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
                                        Navigator.push(context,MaterialPageRoute(builder:(BuildContext bs)=>Orders()));
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