import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class cart extends StatefulWidget {
  const cart({Key? key}) : super(key: key);

  @override
  State<cart> createState() => _cartState();
}
class eve {
  final int price;
  final int pno;
  final String? ename;
  final int? eprice;
  const eve({
    required this.price,
    required this.pno,
    required this.ename,
    required this.eprice,
  });

  factory eve.fromJson(Map<String, dynamic> json) {
    return eve(
      price: json['cart']['amount'],
      pno: json['phoneNumber'],
      ename: json['cart']['items']['name'],
      eprice: json['cart']['items']['price'],
    );
  }
}
class _cartState extends State<cart> {
  late Razorpay _razorpay;
  int amt=0;
  int pno=0;
  String em="";
  late List<Map<String, dynamic>> itemsd;
  Future<List<Map<String, dynamic>>> fetchDat() async {
    List<Map<String, dynamic>> _items = [];
    final String id= await FirebaseAuth.instance.currentUser!.getIdToken(false);
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
      for (var i in jsonDecode(response.body)) {
        _items.add({
          "name": eve.fromJson(i).ename,
          "price": eve.fromJson(i).price,
        });
        print(itemsd[0]['name']);
      }
      //print("price is${eve.fromJson(jsonDecode(response.body)).price}");
      pno=eve.fromJson(jsonDecode(response.body)).pno;
      return _items;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load data');
    }
  }
  double h(double height) {
    return MediaQuery.of(context).size.height * height;
  }

  double w(double width) {
    return MediaQuery.of(context).size.width * width;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cart",
          style: GoogleFonts.sora(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body:Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          child: SizedBox(
            height: h(0.43),
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

                      return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ListView.builder(itemBuilder: (context,position){
                            return Padding(padding: const EdgeInsets.all(6.0),
                              child: Flexible(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: HexColor("#1B1B1B"),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        AutoSizeText("${itemsd[position]['name']}",style: GoogleFonts.sora(fontSize: 16,color: Colors.white),),
                                        SizedBox(width: w(0.5),),
                                        AutoSizeText("${itemsd[position]['price']}/-",style: GoogleFonts.sora(fontSize: 16,color: Colors.green),)
                                      ],
                                    ),
                                  ),
                                ),
                              ),);
                          },itemCount: itemsd.length,),
                        ],
                      );
                    }
                  }
                }),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AutoSizeText("Subtotal",style: GoogleFonts.sora(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),),
          AutoSizeText("$amt",style: GoogleFonts.sora(color: Colors.white,fontSize: 17),)
        ],),
        Center(
          child: SizedBox(height: h(0.2),
            width: w(0.8),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: HexColor("#1B1B1B"),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Coupon Code",style: GoogleFonts.sora(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.white),),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(5)),
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding:const EdgeInsets.only(left: 4),
                      child: TextFormField(
                        style:const TextStyle(fontSize: 18, color: Colors.white),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Your Coupon Code",
                            hintStyle: TextStyle(color: Colors.grey[700])),
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap:(){
                openCheckout(amt);
                //Navigator.pop(context);
                //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => cart()));
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
                    "Buy 5 items",
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
      )
      );
  }
  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    Future.delayed(const Duration(seconds: 0)).then((e) async {
      itemsd = await fetchDat();
    });
  }
  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }
  void openCheckout(int price) async {
    var options = {
      'key': 'rzp_test_sF5XHMKvwK6fR1',
      'amount': price*100,
      'name': 'KTF',
      'description': 'Event Fee',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact':'9172420601', 'email': 'upadhyay.prashant001@gmail.com'},
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
        msg: "SUCCESS: ${response.paymentId!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
     Fluttertoast.showToast(
        msg: "ERROR: ${response.code} - ${response.message!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
     Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: ${response.walletName!}",
        toastLength: Toast.LENGTH_SHORT);
  }
}
