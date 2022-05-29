import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:number_to_words/number_to_words.dart';
class cart extends StatefulWidget {
  const cart({Key? key}) : super(key: key);

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {
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
            child: ListView.builder(itemBuilder: (context,position){
              return Padding(padding: EdgeInsets.all(6.0),
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
                        AutoSizeText("Event ${position+1}",style: GoogleFonts.sora(fontSize: 16,color: Colors.white),),
                        SizedBox(width: w(0.5),),
                        AutoSizeText("499/-",style: GoogleFonts.sora(fontSize: 16,color: Colors.green),)
                      ],
                    ),
                  ),
                ),
              ),);
            },itemCount: 5,),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AutoSizeText("Subtotal",style: GoogleFonts.sora(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),),
            SizedBox(width: w(0.2),),
            AutoSizeText("20,560",style: GoogleFonts.sora(color: Colors.green,fontSize: 16,fontWeight: FontWeight.bold),)
          ],
        ),
        Center(
          child: Container(height: h(0.2),
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
                      padding: EdgeInsets.only(left: 4),
                      child: TextFormField(
                        style: TextStyle(fontSize: 18, color: Colors.white),
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
}
