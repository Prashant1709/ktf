import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}
class Ord{
  final List<dynamic> items;
  final List<Map<String, dynamic>> iob;
  const Ord({
    required this.items,
    required this.iob,
});
  factory Ord.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> temp = [];
    for (var i in json['eventRegistered']) {
      temp.add(i);
    }
    return Ord(
        items: json['eventRegistered'],
        iob: temp,);
  }
}
class _OrdersState extends State<Orders> {
  @override
  void initState() {
    super.initState();
    futureeve = fetchDat();
    future=fetch();
  }
  late Future<Ord> futureeve;
  Future<Ord> fetchDat() async {
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
      return Ord.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }
  late Future<Ord> future;
  Future<Ord> fetch() async {
    final String id =
    await FirebaseAuth.instance.currentUser!.getIdToken(false);
    final response = await http.get(
      Uri.parse('https://ktf-backend.herokuapp.com/data/my-orders'),
      headers: <String, String>{
        "Authorization": "Bearer $id",
        "content-type": "application/json"
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      return Ord.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
        title: Text("Your Orders",style: GoogleFonts.sora(color: Colors.white,fontSize: 16),),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [],
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text("Events"),
              ),
            ],
            indicatorColor: Colors.white,
          ),
      ),
        backgroundColor: Colors.black,
        body: SafeArea(
          child: TabBarView(
            children:[
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(
                    child: FutureBuilder<Ord>(
                      future: futureeve,
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          final merchas = snapshot.data!.iob;
                          return ListView.builder(
                              itemCount: merchas.length,
                              itemBuilder: (context, index){
                                return merchas.isNotEmpty?Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: //GlassContainer.frostedGlass(
                                  Container(
                                    height: 90,
                                    width: 50,
                                    decoration: const BoxDecoration(
                                      color: Color(0xfff1b1b1b),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                    ),
                                    //borderColor: Colors.white,
                                    child: OutlinedButton(onPressed: (){
                                      showModalBottomSheet(isScrollControlled: true,backgroundColor: Colors.black54,context: context, builder: (BuildContext bs)=>Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Center(child: Text("Your Receipt will be available soon",style: GoogleFonts.sora(color: Colors.white,fontSize: 18),),)
                                        ],
                                      ));
                                    },
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
                                                AutoSizeText(
                                                  "Date: ${merchas[index]['eventDate']}",
                                                  style: GoogleFonts.sora(
                                                      color: Colors.white,
                                                      fontSize: 17),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 5, 30, 5),
                                            child: merchas[index]['checkedIn']?CircleAvatar(backgroundColor: Colors.green.shade300,radius: 7,):CircleAvatar(radius: 7,backgroundColor: Colors.red.shade700,)
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ):Center(child: Text("Nothing to show",style: GoogleFonts.sora(color: Colors.white),));
                              });
                        }
                        else if (snapshot.hasError) {
                          //print('${snapshot.error}');
                          return Text('Error Connecting to Servers',style: GoogleFonts.sora(color: Colors.white,fontSize: 17),);
                        }// By default, show a loading spinner.
                        return const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 1,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
