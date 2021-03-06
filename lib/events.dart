import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:ktf/cart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ktf/home.dart';
import 'package:ktf/profile.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

  @override
  State<Events> createState() => _EventsState();
}

class Eve {
  final String? name;
  final String? desct;
  final String? date;
  final int? eid;
  final int? price;
  final String? imgurl;
  const Eve({
    required this.name,
    required this.date,
    required this.desct,
    required this.eid,
    required this.imgurl,
    required this.price,
  });
  factory Eve.fromJson(Map<String, dynamic> json) {
    return Eve(
      name: json['name'],
      date: json['eventDate'],
      eid: json['eventID'],
      price: json['price'],
      imgurl: json['imageURL'],
      desct: json['description'],
    );
  }
}

class _EventsState extends State<Events> {
  final int duration = 10;
  late List<Map<String, dynamic>> eventd;
  Future<List<Map<String, dynamic>>> fetchDat() async {
    List<Map<String, dynamic>> _events = [];

    final response = await http.get(
      Uri.parse('https://ktf-backend.herokuapp.com/data/events'),
      headers: <String, String>{"content-type": "application/json"},
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.statusCode);
      print(response.body);
      for (var i in jsonDecode(response.body)) {
        _events.add({
          "name": Eve.fromJson(i).name,
          "date": Eve.fromJson(i).date,
          "desc": Eve.fromJson(i).desct,
          "imgurl": Eve.fromJson(i).imgurl,
          "price": Eve.fromJson(i).price,
          "eid": Eve.fromJson(i).eid,
        });
      }
      return _events;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load data json');
    }
  }

  Future<bool> cartadd(int eid) async {
    final String id =
        await FirebaseAuth.instance.currentUser!.getIdToken(false);
    //final String ui=FirebaseAuth.instance.currentUser!.uid;
    final response = await http.post(
      Uri.parse('https://ktf-backend.herokuapp.com/cart/add'),
      headers: <String, String>{
        "Authorization": "Bearer $id",
        "content-type": "application/json"
      },
      body: jsonEncode(<String, dynamic>{
        "eventID": eid,
        //"uid": ui.toString(),
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      print(response.statusCode);
      Fluttertoast.showToast(
          msg:
          "Added to Cart",
          toastLength: Toast
              .LENGTH_LONG,
          gravity:
          ToastGravity.SNACKBAR,
          fontSize: 17,
          backgroundColor:
          Colors
              .deepPurple,
          textColor:
          Colors.white);
      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      print(response.statusCode);
      print(response.body);
      Fluttertoast.showToast(
          msg:response.body.substring(12,response.body.length-2),
          toastLength: Toast
              .LENGTH_LONG,
          gravity:
          ToastGravity.SNACKBAR,
          fontSize: 17,
          backgroundColor:
          Colors
              .deepPurple,
          textColor:
          Colors.white);
      return false;
    }
  }

  void initState() {
    // this is called when the class is initialized or called for the first time
    super.initState();
    Future.delayed(const Duration(seconds: 0)).then((e) async {
      eventd = await fetchDat();
    });
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.qr_code,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          //bottom navigation bar on scaffold
          color: Colors.black,
          shape: const CircularNotchedRectangle(), //shape of notch
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
                  icon: const Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext bs) => const Home()));
                  },
                ),
                const SizedBox(
                  width: 30,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext bs) => const Profile()));
                  },
                ),
              ],
            ),
          )),
      appBar: AppBar(
        title: Text(
          "Events",
          style: GoogleFonts.sora(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const cart()));
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.teal,
            ),
            color: Colors.grey.shade300,
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding:const EdgeInsets.only(top: 15.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: FutureBuilder(
              future: fetchDat(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white,),
                  );
                } else {
                  if (snap.hasError) {
                    return Text(snap.error.toString());
                  } else {
                    final events = snap.data as List<Map<String, dynamic>>;

                    return ListView.builder(
                      itemBuilder: (context, position) {
                        return Card(
                          shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: HexColor("#1B1B1B"),
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: AutoSizeText(
                                  "${events[position]['name']}",
                                  style: GoogleFonts.sora(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: AutoSizeText(
                                  "${events[position]['desc']}",
                                  style: GoogleFonts.sora(
                                      color: Colors.white, fontSize: 13),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(28.0),
                                        ),
                                        backgroundColor: Colors.black,
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (BuildContext bc) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Stack(
                                                fit: StackFit.passthrough,
                                                children: [
                                                  Container(
                                                    width: w(1),
                                                    height: h(0.47),
                                                    decoration:
                                                        BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(28),
                                                      color: const Color(
                                                          0xff2cb67d),
                                                    ),
                                                  ),
                                                  Positioned(
                                                      top: 35,
                                                      right: 5,
                                                      child: IconButton(
                                                          onPressed: () {},
                                                          icon: const Icon(
                                                            Icons.favorite,
                                                            color:
                                                                Colors.red,
                                                          ))),
                                                  Positioned(
                                                      top: 35,
                                                      left: 5,
                                                      child: IconButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          icon: const Icon(
                                                            Icons
                                                                .arrow_back,
                                                            color: Colors
                                                                .black,
                                                          ))),
                                                  Positioned(
                                                      top: 100,
                                                      right: 70,
                                                      left: 70,
                                                      child: Image.asset(
                                                          "assets/img.png")),
                                                  Positioned(
                                                      top: 280,
                                                      right: 40,
                                                      left: 40,
                                                      child: Card(
                                                        color: Colors.white,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            const Icon(
                                                              Icons.people,
                                                              color: Colors
                                                                  .black,
                                                            ),
                                                            Column(
                                                              children: [
                                                                AutoSizeText(
                                                                  "40+",
                                                                  style: GoogleFonts
                                                                      .sora(
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                                AutoSizeText(
                                                                  "People",
                                                                  style: GoogleFonts
                                                                      .sora(
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      8.0),
                                                              child:
                                                                  SizedBox(
                                                                height: 60,
                                                                width: 60,
                                                                child:
                                                                    Stack(
                                                                  children: <
                                                                      Widget>[
                                                                    const Center(
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            60,
                                                                        height:
                                                                            60,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          strokeWidth: 5,
                                                                          value: 0.6,
                                                                          backgroundColor: Colors.grey,
                                                                          color: Color.fromRGBO(79, 9, 29, 1),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Center(
                                                                        child:
                                                                            Row(
                                                                      children: const [
                                                                        Text(
                                                                          "\t\t60%",
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ],
                                                                    )),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            CircularCountDownTimer(
                                                              width: 60,
                                                              height: 60,
                                                              duration:
                                                                  duration,
                                                              fillColor:
                                                                  Colors
                                                                      .grey,
                                                              ringColor:
                                                                  Colors
                                                                      .green,
                                                              textStyle: const TextStyle(
                                                                  fontSize:
                                                                      20,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          ],
                                                        ),
                                                      )),
                                                ],
                                              ),
                                              SizedBox(
                                                height: h(0.05),
                                              ),
                                              AutoSizeText(
                                                "About Event",
                                                style: GoogleFonts.sora(
                                                    fontSize: 17,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              AutoSizeText(
                                                "${events[position]['desc']}",
                                                style: GoogleFonts.sora(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                ),
                                                maxLines: 8,
                                              ),
                                              SizedBox(
                                                height: h(0.1),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      //print("EID is ${_events[position]['eid']}");
                                                      cartadd(events[position]
                                                                  ['eid']).then((value) => const CircularProgressIndicator())
                                                          .whenComplete(() =>
                                                              Navigator.pop(
                                                                  context));

                                                    },
                                                    child: Container(
                                                      height: h(0.06),
                                                      width: h(0.4),
                                                      decoration:
                                                          BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                                colors: [
                                                              HexColor(
                                                                  "#7F5AF0"),
                                                              HexColor(
                                                                  "#481DCB"),
                                                            ]),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    20),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "Add to Cart",
                                                          style: GoogleFonts
                                                              .sora(
                                                            color: Colors
                                                                .white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: h(0.01),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pop(
                                                          context);
                                                      cartadd(events[position]
                                                      ['eid']).then((value) => const CircularProgressIndicator())
                                                          .whenComplete(() =>Navigator.push(context, MaterialPageRoute(builder: (BuildContext bs)=>const cart())));
                                                    },
                                                    child: Container(
                                                      height: h(0.06),
                                                      width: h(0.4),
                                                      decoration:
                                                          BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                                colors: [
                                                              HexColor(
                                                                  "#ffffff"),
                                                              HexColor(
                                                                  "#2CB67D"),
                                                            ]),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    20),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "Buy Now",
                                                          style: GoogleFonts
                                                              .sora(
                                                            color: Colors
                                                                .white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        HexColor("#7F5AF0"),
                                        HexColor("#481DCB"),
                                      ]),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "${events[position]['price']}/-",
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
                          const SizedBox(
                              height: 125,
                              width: 125,
                              child: Image(
                                  image: AssetImage("assets/img.png")))
                        ],
                          ),
                        );
                      },
                      itemCount: events.length,
                    );
                  }
                }
              }),
        ),
      ),
    );
  }
}
