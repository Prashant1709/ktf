import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:razorpay_flutter/razorpay_flutter.dart';

class events extends StatefulWidget {
  const events({Key? key}) : super(key: key);

  @override
  State<events> createState() => _eventsState();
}
class eve{
  final String? name;
  final String? desct;
  final String? date;
  final String? eid;
  final int? price;
  final String? imgurl;
  const eve({
    required this.name,
    required this.date,
    required this.desct,
    required this.eid,
    required this.imgurl,
    required this.price,
});
  factory eve.fromJson(Map<String, dynamic> json) {
    return eve(
      name: json['name'],
      date: json['eventDate'],
      eid: json['eventID'],
      price: json['price'],
      imgurl: json['imageURL'],
      desct: json['description'],
    );
  }
}
class _eventsState extends State<events> {
  List<Map<String, dynamic>> _events = [];
  final int duration=10;
  late Razorpay _razorpay;
  late Future<List<eve>> eventd;
  Future<List<eve>> fetchDat() async {
    final response = await http
        .get(Uri.parse('https://ktf-backend.herokuapp.com/data/events'),
      headers: <String, String>{
        "content-type": "application/json"
      },);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.statusCode);
      print(response.body);
      for(var i in jsonDecode(response.body)){
        _events.add({
          "name":eve.fromJson(i).name,
          "date":eve.fromJson(i).date,
          "desc":eve.fromJson(i).desct,
          "imgurl":eve.fromJson(i).imgurl,
          "price":eve.fromJson(i).price,
          "eid":eve.fromJson(i).eid,
        });
      }
      return _events[0]['price'];
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
    eventd = fetchDat();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }
  void openCheckout(int price) async {
    var options = {
      'key': 'rzp_test_sF5XHMKvwK6fR1',
      'amount': price,
      'name': 'KTF',
      'description': 'Event Fee',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '9172420601', 'email': 'upadhyay.prashant001@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success Response: ${response.paymentId!} ${response.orderId!}');
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
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
      floatingActionButton: FloatingActionButton(onPressed: (){

      },child: Icon(Icons.qr_code,color: Colors.white,),),
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
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext bs)=>home()));
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
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext bs)=>Profile()));
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
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => cart()));
          }, icon: Icon(Icons.shopping_cart,color: Colors.teal,),color: Colors.grey.shade300,)
        ],
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SizedBox(height: MediaQuery.of(context).size.height * 0.8,
          child: ListView.builder(
            itemBuilder: (context, position) {
              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: Flexible(child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: HexColor("#1B1B1B"),
                  child:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: AutoSizeText("${_events[position]['name']}",style: GoogleFonts.sora(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 21),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: AutoSizeText("${_events[position]['desc']}",style: GoogleFonts.sora(
                                color: Colors.white,
                                fontSize: 13),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                  ),
                                  backgroundColor: Colors.black,
                                    isScrollControlled: true,
                                    context: context, builder: (BuildContext bc){
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Stack(fit:StackFit.passthrough,
                                        children: [
                                        Container(
                                          width: w(1),
                                          height: h(0.47),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(28),
                                            color: Color(0xff2cb67d),
                                          ),
                                        ),
                                          Positioned(
                                            top: 35,
                                            right: 5,
                                            child: IconButton(onPressed: (){}, icon: Icon(Icons.favorite,color: Colors.red,))
                                          ),
                                          Positioned(
                                              top: 35,
                                              left: 5,
                                              child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.black,))
                                          ),
                                          Positioned(
                                              top: 100,
                                              right:70,
                                              left:70,
                                              child: Image.asset("assets/img.png")
                                          ),
                                          Positioned(
                                              top: 280,
                                              right:40,
                                              left:40,
                                              child: Card(color: Colors.white,child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Icon(Icons.people,color: Colors.black,),
                                                  Column(
                                                    children: [
                                                      AutoSizeText("40+",style:GoogleFonts.sora(
                                                        fontSize: 16,
                                                      ),),
                                                      AutoSizeText("People",style: GoogleFonts.sora(
                                                        fontSize: 12,
                                                      ),)
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: SizedBox(
                                                      height: 60,
                                                      width: 60,
                                                      child: Stack(
                                                        children:<Widget>[ Center(
                                                          child: Container(
                                                            child: CircularProgressIndicator(
                                                                    strokeWidth: 5,
                                                                    value: 0.6,
                                                                    backgroundColor: Colors.grey,
                                                                    color: Color.fromRGBO(79, 9, 29,1),

                                                            ),
                                                            width: 60,
                                                            height:60,
                                                          ),
                                                        ),
                                                          Center(child: Row(
                                                            children: [
                                                              Text("\t\t60%",textAlign:TextAlign.center,style: TextStyle(fontSize:20,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
                                                            ],
                                                          )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  CircularCountDownTimer(width: 60, height: 60, duration: duration, fillColor: Colors.grey, ringColor: Colors.green,textStyle: TextStyle(fontSize:20,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),)
                                                ],
                                              ),)
                                          ),
                                        ],),
                                      SizedBox(height: h(0.05),),
                                      AutoSizeText("About Event",style: GoogleFonts.sora(fontSize: 17,color: Colors.white,fontWeight: FontWeight.bold),),
                                      AutoSizeText("${_events[position]['desc']}",style: GoogleFonts.sora(fontSize: 13,color: Colors.white,),maxLines: 8,),
                                      SizedBox(height: h(0.1),),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(onTap:(){
                                            Navigator.pop(context);
                                            Fluttertoast.showToast(
                                              msg: "Added to Cart",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.CENTER,
                                                fontSize: 17,
                                                backgroundColor: Colors.deepPurple,
                                              textColor: Colors.white
                                            );
                                          },
                                            child: Container(
                                              height: h(0.06),
                                              width: h(0.4),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(colors: [
                                                  HexColor("#7F5AF0"),
                                                  HexColor("#481DCB"),
                                                ]),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Add to Cart",
                                                  style: GoogleFonts.sora(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: h(0.01),),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap:(){
                                              Navigator.pop(context);
                                              openCheckout(_events[position]['price']*100);
                                            },
                                            child: Container(
                                              height: h(0.06),
                                              width: h(0.4),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(colors: [
                                                  HexColor("#ffffff"),
                                                  HexColor("#2CB67D"),
                                                ]),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Buy Now!",
                                                  style: GoogleFonts.sora(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
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
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    "${_events[position]['price']}/-",
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
                          height: 125,
                          width: 125,
                          child: Image(image: AssetImage("assets/img.png")))
                    ],
                  ),
                )),
              );
            },
            itemCount: _events.length,
          ),
        ),
      ),
    );
  }
}
