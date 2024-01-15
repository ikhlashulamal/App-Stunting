import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stunting/camera_page.dart';
import 'package:stunting/colors.dart';
import 'package:stunting/login_camera_page.dart';
import 'package:stunting/product_screen.dart';

class HomeScreen extends StatelessWidget {

  List<String> categories = [
    "Jenis Kelamin",
    "Umur",
    "Tinggi Badan",
    "Berat Badan",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.whiteClr,
      // backgroundColor: Colors.redAccent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                const Text("Stunting Indonesia",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black12,
                    ),
                  ),
                  child: const Icon(
                      Icons.search,
                  color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                child: Stack(
                  children: [
                    Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: colors.grnClr,
                      ),
                    ),
                    Container(
                      height: 110,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "30% Stunting",
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "02 - 23 July",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54
                                ),
                              ),
                            ],
                          ),
                          Image.asset('assets/anak.png',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: index == 1 ? Colors.black : Colors.black26,
                      )
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: index == 1 ? Colors.black : Colors.black26,
                      ),
                      ),
                    ),
                  );
                },),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: SizedBox(
                  height: 350,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              right: 15, top: 5, left: 5, bottom: 5),
                          width: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: colors.gryClr,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 2,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 280,
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => ProductScreen(),
                                            ));
                                          },
                                          child: Image.asset('assets/dokter.png')),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white,
                                    ),
                                    child: Text("Stunting",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: colors.blClr,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colors.blClr,
                                    ),
                                    child: Icon(
                                      Icons.favorite_outline,
                                      color: Colors.white38,)
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  },),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: colors.gryClr,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(CupertinoIcons.home,
                color: Colors.black54,
              ),
              Icon(Icons.favorite_outline,
                color: Colors.black54,
              ),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.blClr,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      spreadRadius: 1,
                    )
                  ]
                ),
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => MyApp(),
                    ));
                  },
                  child: Icon(CupertinoIcons.camera,
                    color: Colors.white54,
                  ),
                ),
              ),
              Icon(Icons.history,
                color: Colors.black54,
              ),
              Icon(CupertinoIcons.person,
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

