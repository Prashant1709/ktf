// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ktf/cart.dart';

class Merch extends StatefulWidget {
  const Merch({super.key});

  @override
  State<Merch> createState() => _MerchState();
}
class Mer {
  final String? name;
  final String? desct;
  final int? eid;
  final int? price;
  final String? imgurl;
  final List<String>? size;
  const Mer({
    required this.name,
    required this.desct,
    required this.eid,
    required this.imgurl,
    required this.price,
    required this.size,
  });
  factory Mer.fromJson(Map<String, dynamic> json) {
    List<String> temp=[];
    for(var i in json['availableSize']){
      temp.add(i.toString());
    }
    return Mer(
      name: json['name'],
      eid: json['merchID'],
      price: json['price'],
      imgurl: json['imageURL'],
      desct: json['description'],
      size: temp
    );
  }
}
class _MerchState extends State<Merch> {
  final int duration = 10;
  int quant=1;

  String size="Select Size";
  late List<Map<String, dynamic>> merchs;
  Future<List<Map<String, dynamic>>> fetchDat() async {
    List<Map<String, dynamic>> _merch = [];

    final response = await http.get(
      Uri.parse('https://ktf-backend.herokuapp.com/data/merchs'),
      headers: <String, String>{"content-type": "application/json"},
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.statusCode);
      print(response.body);
      for (var i in jsonDecode(response.body)) {
        _merch.add({
          "name":Mer.fromJson(i).name,
          "eid":Mer.fromJson(i).eid,
          "price":Mer.fromJson(i).price,
          "imgurl":Mer.fromJson(i).imgurl,
          "desc":Mer.fromJson(i).desct,
          "size":Mer.fromJson(i).size,
        });
      }
      return _merch;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      //print(response.statusCode);
      //print(response.body);
      throw Exception('Failed to load data json');
    }
  }

  Future<bool> cartadd(String eid,int quant,String size) async {
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
        "merchID": eid,
        "quantity": quant,
        "merchSize": size,
        //"uid": ui.toString(),
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      print(response.statusCode);
      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      print(response.statusCode);
      print(response.body);
      return false;
    }
  }

  @override
  void initState() {
    // this is called when the class is initialized or called for the first time
    super.initState();
    Future.delayed(const Duration(seconds: 0)).then((e) async {
      merchs = await fetchDat();
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Merchandise",
          style: GoogleFonts.sora(fontWeight: FontWeight.bold),
        ),
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
        centerTitle: true,
        backgroundColor: Colors.transparent,

      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0),
        child: SizedBox(
          height: h(1),
          child:  FutureBuilder(
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
                    final merchas = snap.data as List<Map<String, dynamic>>;
                    return ListView.builder(itemBuilder: (context,position){
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GlassContainer.frostedGlass(height: h(0.3), width: w(0.9),borderRadius: BorderRadius.circular(50),
                          borderColor: Colors.white,
                        child: OutlinedButton(onPressed: (){
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
                                            top: 95,
                                            right: 70,
                                            left: 70,
                                            child: Image.network("https://picsum.photos/200")),
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
                                                        5.0),
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
                                                  Text("Sold",style: GoogleFonts.sora(color: Colors.black,fontSize: 17),)
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: h(0.05),
                                    ),
                                    AutoSizeText(
                                      "About Merch",
                                      style: GoogleFonts.sora(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                    AutoSizeText(
                                      "${merchas[position]['desc']}",
                                      style: GoogleFonts.sora(
                                        fontSize: 17,
                                        color: Colors.white,
                                      ),
                                      maxLines: 8,
                                    ),
                                    SizedBox(
                                      height: h(0.05),
                                    ),
                                    AutoSizeText(
                                      "Sizes Available",
                                      style: GoogleFonts.sora(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                    AutoSizeText(
                                      "${merchas[position]['size']}",
                                      style: GoogleFonts.sora(
                                        fontSize: 17,
                                        color: Colors.white,
                                      ),
                                      maxLines: 8,
                                    ),
                                    SizedBox(
                                      height: h(0.1),
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
                                          onTap: () {showDialog(context: context, builder: (BuildContext bs)=>AlertDialog(
                                            backgroundColor: Colors.black54,
                                            title: Text("Customize your merch",style: GoogleFonts.sora(color: Colors.white,fontSize: 16),),
                                            content: SizedBox(height: h(0.5),
                                              child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Text("Size: ",style: GoogleFonts.sora(color: Colors.white,fontSize: 16),),
                                                      DropdownButton(
                                                        dropdownColor: Colors.black38,
                                                        value: size,
                                                        icon: const Icon(Icons.keyboard_arrow_down),
                                                        iconSize: 24,
                                                        elevation: 16,
                                                        style: const TextStyle(color: Colors.white),
                                                        underline: Container(
                                                          height: 2,
                                                          color: Colors.blueGrey,
                                                        ),
                                                        onChanged: (String? newValue) {
                                                          setState(() {
                                                            size = newValue!;
                                                          });
                                                        },
                                                        items: <String>[
                                                          'Select Size',
                                                          'S',
                                                          'M',
                                                          'L',
                                                          'XL'
                                                        ].map<DropdownMenuItem<String>>(
                                                                (String value) {
                                                              return DropdownMenuItem<String>(
                                                                value: value,
                                                                child: Text(
                                                                  value,
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                    color: Colors.white,
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                      ),
                                                    ],),
                                                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Text("Quantity: ",style: GoogleFonts.sora(color: Colors.white,fontSize: 16),),
                                                      DropdownButton(
                                                        dropdownColor: Colors.black38,
                                                        value: quant,
                                                        icon: const Icon(Icons.keyboard_arrow_down),
                                                        iconSize: 24,
                                                        elevation: 16,
                                                        style: const TextStyle(color: Colors.white),
                                                        underline: Container(
                                                          height: 2,
                                                          color: Colors.blueGrey,
                                                        ),
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            quant = newValue as int;
                                                          });
                                                        },
                                                        items: <int>[1,2,3,4,5
                                                        ].map<DropdownMenuItem<int>>(
                                                                (int value) {
                                                              return DropdownMenuItem<int>(
                                                                value: value,
                                                                child: Text(
                                                                  value.toString(),
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                    color: Colors.white,
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                      ),
                                                    ],),
                                                  Center(
                                                    child: MaterialButton(onPressed: (){cartadd(merchas[position]
                                                    ['eid']
                                                        .toString(),quant,size.toString())
                                                        .whenComplete(() =>
                                                        Navigator.pop(
                                                            context));
                                                    Fluttertoast.showToast(
                                                        msg:
                                                        "Added to Cart",
                                                        toastLength: Toast
                                                            .LENGTH_LONG,
                                                        gravity:
                                                        ToastGravity
                                                            .CENTER,
                                                        fontSize: 17,
                                                        backgroundColor:
                                                        Colors
                                                            .deepPurple,
                                                        textColor:
                                                        Colors.white);
                                                    },color: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),child: Text("Add to Cart",style: GoogleFonts.sora(color: Colors.black,fontSize: 16),),),
                                                  ),
                                                ],),
                                            ),
                                          ));
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
                                  ],
                                );
                              });
                        },
                          child: Row(mainAxisSize: MainAxisSize.min,
                            children: [
                            SizedBox(height: h(0.35),width: w(0.35),child: Image.asset("assets/even_page.png"),),
                            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AutoSizeText("${merchas[position]['name']}",style: GoogleFonts.sora(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),),
                              AutoSizeText("Price: ${merchas[position]['price']}/-",style: GoogleFonts.sora(color: Colors.white,fontSize: 17)),
                              Row(
                                children: [
                                  MaterialButton(onPressed: (){
                                    showDialog(context: context, builder: (BuildContext bs)=>AlertDialog(
                                      backgroundColor: Colors.black54,
                                      title: Text("Customize your merch",style: GoogleFonts.sora(color: Colors.white,fontSize: 16),),
                                      content: SizedBox(height: h(0.5),
                                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text("Size: ",style: GoogleFonts.sora(color: Colors.white,fontSize: 16),),
                                                DropdownButton(
                                                  dropdownColor: Colors.black38,
                                                  value: size,
                                                  icon: const Icon(Icons.keyboard_arrow_down),
                                                  iconSize: 24,
                                                  elevation: 16,
                                                  style: const TextStyle(color: Colors.white),
                                                  underline: Container(
                                                    height: 2,
                                                    color: Colors.blueGrey,
                                                  ),
                                                  onChanged: (String? newValue) {
                                                    setState(() {
                                                      size = newValue!;
                                                    });
                                                  },
                                                  items: <String>[
                                                    'Select Size',
                                                    'S',
                                                    'M',
                                                    'L',
                                                    'XL'
                                                  ].map<DropdownMenuItem<String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<String>(
                                                          value: value,
                                                          child: Text(
                                                            value,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                ),
                                              ],),
                                            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text("Quantity: ",style: GoogleFonts.sora(color: Colors.white,fontSize: 16),),
                                                DropdownButton(
                                                  dropdownColor: Colors.black38,
                                                  value: quant,
                                                  icon: const Icon(Icons.keyboard_arrow_down),
                                                  iconSize: 24,
                                                  elevation: 16,
                                                  style: const TextStyle(color: Colors.white),
                                                  underline: Container(
                                                    height: 2,
                                                    color: Colors.blueGrey,
                                                  ),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      quant = newValue as int;
                                                    });
                                                  },
                                                  items: <int>[1,2,3,4,5
                                                  ].map<DropdownMenuItem<int>>(
                                                          (int value) {
                                                        return DropdownMenuItem<int>(
                                                          value: value,
                                                          child: Text(
                                                            value.toString(),
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                ),
                                              ],),
                                            Center(
                                              child: MaterialButton(onPressed: (){cartadd(merchas[position]
                                              ['eid']
                                                  .toString(),quant,size.toString())
                                                  .whenComplete(() =>
                                                  Navigator.pop(
                                                      context));
                                              Fluttertoast.showToast(
                                                  msg:
                                                  "Added to Cart",
                                                  toastLength: Toast
                                                      .LENGTH_LONG,
                                                  gravity:
                                                  ToastGravity
                                                      .CENTER,
                                                  fontSize: 17,
                                                  backgroundColor:
                                                  Colors
                                                      .deepPurple,
                                                  textColor:
                                                  Colors.white);

                                              },color: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),child: Text("Add to Cart",style: GoogleFonts.sora(color: Colors.black,fontSize: 16),),),
                                            ),
                                          ],),
                                      ),
                                    ));

                                  },color: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),child: Text("Buy",style: GoogleFonts.sora(color: Colors.black,fontSize: 16),),),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(height: 40,width: 40,child: FloatingActionButton(onPressed: (){
                                      showDialog(context: context, builder: (BuildContext bs)=>AlertDialog(
                                        backgroundColor: Colors.black54,
                                        title: Text("Customize your merch",style: GoogleFonts.sora(color: Colors.white,fontSize: 16),),
                                        content: SizedBox(height: h(0.5),
                                          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text("Size: ",style: GoogleFonts.sora(color: Colors.white,fontSize: 16),),
                                              DropdownButton(
                                                dropdownColor: Colors.black38,
                                                value: size,
                                                icon: const Icon(Icons.keyboard_arrow_down),
                                                iconSize: 24,
                                                elevation: 16,
                                                style: const TextStyle(color: Colors.white),
                                                underline: Container(
                                                  height: 2,
                                                  color: Colors.blueGrey,
                                                ),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    size = newValue!;
                                                  });
                                                },
                                                items: <String>[
                                                  'Select Size',
                                                  'S',
                                                  'M',
                                                  'L',
                                                  'XL'
                                                ].map<DropdownMenuItem<String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                              ),
                                            ],),
                                            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text("Quantity: ",style: GoogleFonts.sora(color: Colors.white,fontSize: 16),),
                                                DropdownButton(
                                                  dropdownColor: Colors.black38,
                                                  value: quant,
                                                  icon: const Icon(Icons.keyboard_arrow_down),
                                                  iconSize: 24,
                                                  elevation: 16,
                                                  style: const TextStyle(color: Colors.white),
                                                  underline: Container(
                                                    height: 2,
                                                    color: Colors.blueGrey,
                                                  ),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      quant = newValue as int;
                                                    });
                                                  },
                                                  items: <int>[1,2,3,4,5
                                                  ].map<DropdownMenuItem<int>>(
                                                          (int value) {
                                                        return DropdownMenuItem<int>(
                                                          value: value,
                                                          child: Text(
                                                            value.toString(),
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                ),
                                              ],),
                                              Center(
                                                child: MaterialButton(onPressed: (){cartadd(merchas[position]
                                                ['eid']
                                                    .toString(),quant,size.toString())
                                                    .whenComplete(() =>
                                                    Navigator.pop(
                                                        context));
                                                Fluttertoast.showToast(
                                                    msg:
                                                    "Added to Cart",
                                                    toastLength: Toast
                                                        .LENGTH_LONG,
                                                    gravity:
                                                    ToastGravity
                                                        .CENTER,
                                                    fontSize: 17,
                                                    backgroundColor:
                                                    Colors
                                                        .deepPurple,
                                                    textColor:
                                                    Colors.white);
                                                  },color: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),child: Text("Add to Cart",style: GoogleFonts.sora(color: Colors.black,fontSize: 16),),),
                                              ),
                                            ],),
                                        ),
                                      ));
                                    },backgroundColor: Colors.white,child: Icon(Icons.add_shopping_cart_outlined,color: Colors.black,),)),
                                  )
                                ],
                              )
                            ],)
                          ],),
                        ),),
                      );
                    },
                    itemCount: merchas.length,);
                  }
                }
              }),
        ),
      ),
    );
  }
}
