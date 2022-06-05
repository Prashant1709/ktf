import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ktf/home.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swipeable/swipeable.dart';
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
  final bool cc;
  final List<dynamic> items;
  final List<Map<String, dynamic>> iob;
  const eve({
    required this.price,
    required this.pno,
    required this.cc,
    required this.items,
    required this.iob,
  });

  factory eve.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> temp = [];
    for (var i in json['cart']['items']) {
      temp.add(i);
    }
    return eve(
        price: json['cart']['amount'],
        cc: json['cart']['couponApplied'],
        items: json['cart']['items'],
        iob: temp,
        pno: json['phoneNumber']);
  }
}

class _cartState extends State<cart> {
  late Razorpay _razorpay;
  int amt = 0;
  bool leftSelected=false;
  bool rightSelected=false;
  int pno = 0;
  String em = "";
  late Future<eve> futureeve;
  Future<eve> fetchDat() async {
    final String id =
        await FirebaseAuth.instance.currentUser!.getIdToken(false);
    final response = await http.get(
      Uri.parse('https://ktf-backend.herokuapp.com/data/user'),
      headers: <String, String>{
        "Authorization": "Bearer $id",
        "content-type": "application/json"
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.statusCode);
      //print(response.body);
      return eve.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load data');
    }
  }
  Future<eve> deleteCart(String elid) async {
    final String id =
    await FirebaseAuth.instance.currentUser!.getIdToken(false);
    final http.Response response = await http.delete(
      Uri.parse('https://ktf-backend.herokuapp.com/cart/remove/$elid'),
      headers: <String, String>{
        "Authorization": "Bearer $id",
        "content-type": "application/json"
      },
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Deleted",
          toastLength: Toast.LENGTH_SHORT);
      print(response.body);
      return eve.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a "200 OK response",
      // then throw an exception.
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to delete album.');
    }
  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Are you sure?',style: GoogleFonts.sora(color: Colors.white,fontSize: 17),),
        content: Text('Do you want to exit cart',style: GoogleFonts.sora(color: Colors.white,fontSize: 17),),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(false), //<-- SEE HERE
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (BuildContext bs)=>const Home())), // <-- SEE HERE
            child: const Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }


  double h(double height) {
    return MediaQuery.of(context).size.height * height;
  }

  double w(double width) {
    return MediaQuery.of(context).size.width * width;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Cart",
              style: GoogleFonts.sora(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.black,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                child: SizedBox(
                  height: h(0.43),
                  child: Center(
                    child: FutureBuilder<eve>(
                      future: futureeve,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final merchas = snapshot.data!.iob;
                          //print(merchas[0].containsValue("Event-2"));
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              return merchas[index].containsValue("event")
                                  ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: //GlassContainer.frostedGlass(
                                Container(
                                  height: 90,
                                  width: 50,
                                  decoration: const BoxDecoration(
                                    color: Color(0xffF1b1b1b),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                  ),
                                  //borderColor: Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(30, 10, 10, 0),

                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [

                                            AutoSizeText(
                                              "${merchas[index]['name']}",
                                              style: GoogleFonts.sora(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    deleteCart(merchas[index]['id'].toString()).whenComplete(() => Navigator.push(context, MaterialPageRoute(builder: (BuildContext bs)=>const cart())));
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                  ),
                                                  color: Colors
                                                      .tealAccent.shade400,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 5, 30, 5),
                                        child: AutoSizeText(
                                          "${merchas[index]['price']}",
                                          style: GoogleFonts.sora(
                                              color: Colors.teal,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: //GlassContainer.frostedGlass(
                                      Container(
                                        height: 90,
                                        width: 50,
                                        decoration: const BoxDecoration(
                                          color: Color(0xffF1b1b1b),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.0),
                                          ),
                                        ),
                                        //borderColor: Colors.white,
                                        child: Row(
                                          mainAxisAlignment:
                                           MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(30, 10, 10, 0),

                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                children: [

                                                  AutoSizeText(
                                                    "${merchas[index]['name']}",
                                                    style: GoogleFonts.sora(
                                                        color: Colors.white,
                                                        fontSize: 17),
                                                  ),
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                         // openCheckout(merchas[index]['price']*100);
                                                        },
                                                        icon: const Icon(
                                                          Icons.edit,
                                                          color: Colors.white,
                                                        ),
                                                        color: Colors.tealAccent
                                                            .shade400,
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          deleteCart(merchas[index]['id'].toString()).whenComplete(() => Navigator.push(context, MaterialPageRoute(builder: (BuildContext bs)=>const cart())));
                                                        },
                                                        icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.white,
                                                        ),
                                                        color: Colors
                                                            .tealAccent.shade400,
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 5, 30, 5),
                                              child: AutoSizeText(
                                                "${merchas[index]['price']}",
                                                style: GoogleFonts.sora(
                                                    color: Colors.teal,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                            },
                            itemCount: merchas.length,
                          );
                        } else if (snapshot.hasError) {
                          //print('${snapshot.error}');
                          return const Text('Error Connecting to Servers');
                        }
                        // By default, show a loading spinner.
                        return const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 1,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AutoSizeText(
                    "Subtotal",
                    style: GoogleFonts.sora(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  FutureBuilder<eve>(
                    future: futureeve,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final merchas =
                            snapshot.data!.iob as List<Map<String, dynamic>>;
                        print(merchas[0].containsValue("Event-2"));
                        amt = snapshot.data!.price;
                        return Text(
                          "${snapshot.data!.price}/-",
                          style:
                              GoogleFonts.sora(fontSize: 18, color: Colors.white),
                        );
                      } else if (snapshot.hasError) {
                        print('${snapshot.error}');
                        return const Text('snapshot.error');
                      }

                      // By default, show a loading spinner.
                      return const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 1,
                      );
                    },
                  ),
                ],
              ),
              Center(
                child: SizedBox(
                  height: h(0.2),
                  width: w(0.8),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: HexColor("#1B1B1B"),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Coupon Code",
                            style: GoogleFonts.sora(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(5)),
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width * 0.9,
                            padding: const EdgeInsets.only(left: 4),
                            child: TextFormField(
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
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
              Container(
                margin: const EdgeInsets.fromLTRB(20, 5, 20,5),
                child: Swipeable(
                  threshold: 60.0,
                  onSwipeLeft: () {
                    Navigator.pop(context);
                    setState(() {
                      rightSelected = true;
                      leftSelected = false;
                    });
                  },
                  onSwipeRight: () {
                    openCheckout(amt);
                    setState(() {
                      rightSelected = false;
                      leftSelected = true;
                    });
                  },
                  background: Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        color: Colors.green[500]),
                    child: ListTile(
                      leading: Container(
                        width: 82.0,
                        height: 82.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.green[500],
                        ),
                      ),
                      trailing: Container(
                        width: 82.0,
                        height: 82.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.green[500],
                        ),
                      ),
                    ),
                  ),
                  child: Container(
                    decoration:const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        color: Colors.greenAccent),
                    child: const ListTile(
                      title: Text("Swipe >> to buy"),
                      textColor: Colors.white,
                      trailing: Text("Exit<<"),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    futureeve = fetchDat();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(int price) async {
    var options = {
      'key': 'rzp_test_sF5XHMKvwK6fR1',
      'amount': price * 100,
      'name': 'KTF',
      'description': 'Event Fee',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': '9172420601',
        'email': 'upadhyay.prashant001@gmail.com'
      },
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
