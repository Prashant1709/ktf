import 'package:auto_size_text/auto_size_text.dart';
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
                            child: AutoSizeText("Event ${position+1}",style: GoogleFonts.sora(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 21),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: AutoSizeText("Event Description",style: GoogleFonts.sora(
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
                                          height: h(0.45),
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
                                        ],)
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
                                    "499/-",
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
            itemCount: 5,
          ),
        ),
      ),
    );
  }
}
