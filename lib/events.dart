import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
class events extends StatefulWidget {
  const events({Key? key}) : super(key: key);

  @override
  State<events> createState() => _eventsState();
}

class _eventsState extends State<events> {
  @override
  Widget build(BuildContext context) {
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
        title: Text(
          "Events",
          style: GoogleFonts.sora(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.shopping_cart,color: Colors.teal,),color: Colors.grey.shade300,)
        ],
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SizedBox(height: MediaQuery.of(context).size.height * 0.8,
          child: ListView.separated(
            itemBuilder: (context, position) {
              return Flexible(child: Card(
                color: HexColor("#1B1B1B"),
                child:Row(
                  children: [
                    Column(
                      children: [

                      ],
                    )
                  ],
                ),
              ));
            },
            separatorBuilder: (context, position) {
              return Divider(color: Colors.grey,endIndent: 30,indent: 30,thickness: 1,);
            },
            itemCount: 20,
          ),
        ),
      ),
    );
  }
}
