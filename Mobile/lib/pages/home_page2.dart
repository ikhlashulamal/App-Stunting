// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stuntingapp/auth.dart';
import 'package:stuntingapp/pages/about.dart';
import 'package:stuntingapp/pages/add.dart';
import 'package:stuntingapp/pages/chatbot.dart';
import 'package:stuntingapp/pages/profile.dart';
import 'package:stuntingapp/pages/logaktivitas.dart';

import 'package:google_fonts/google_fonts.dart';

class HomePage2 extends StatefulWidget {
  final User? user = Auth().currentUser;

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage2> {
  String mainProfilePicture = "https://randomuser.me/api/portraits/men/44.jpg";
  String otherProfilePicture = "https://randomuser.me/api/portraits/men/47.jpg";

  Future<void> signOut() async {
    await Auth().signOut();
    // Navigator.of(context as BuildContext).push(
    //   MaterialPageRoute(
    //     builder: (context) => const LoginPage(),
    //   ),
    // );
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out'),
    );
  }

  void switchUser() {
    String backupString = mainProfilePicture;
    this.setState(() {
      mainProfilePicture = otherProfilePicture;
      otherProfilePicture = backupString;
    });
  }

  // List _posts = [];

  @override
  // void initState() {
  //   super.initState();
  //   _getData(
  //       "https://newsapi.org/v2/top-headlines?country=id&apiKey=99ea1dbf40e843b8a455af25c3544b83");
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("STUNTING APP"),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Apakah anda yakin akan keluar?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Container(
                            color: Color.fromARGB(255, 255, 255, 255),
                            padding: const EdgeInsets.all(14),
                            child: const Text("Tidak"),
                          ),
                        ),
                        TextButton(
                          onPressed: signOut,
                          child: Container(
                            color: Color.fromARGB(255, 255, 255, 255),
                            padding: const EdgeInsets.all(14),
                            child: const Text("Ya"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Icon(Icons.login),
              )),
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text("Irfan Triadi Saputra"),
                accountEmail: new Text("irfants1710@gmail.com"),
                currentAccountPicture: new GestureDetector(
                  onTap: () => switchUser(),
                  child: new CircleAvatar(
                      backgroundImage: new NetworkImage(mainProfilePicture)),
                ),
                otherAccountsPictures: <Widget>[
                  new GestureDetector(
                    onTap: () => print("this is the other user"),
                    child: new CircleAvatar(
                        backgroundImage: new NetworkImage(otherProfilePicture)),
                  ),
                ],
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new NetworkImage(
                            "https://orig00.deviantart.net/20eb/f/2015/030/6/f/_minflat__dark_material_design_wallpaper__4k__by_dakoder-d8fjqzu.jpg")))),
            new ListTile(
                title: new Text("Chat Konsultasi"),
                trailing: new Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => Chatbot()));
                }),
            new ListTile(
                title: new Text("Diagnosis"),
                trailing: new Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => UploadImage()));
                }),
            new ListTile(
                title: new Text("Log Aktivitas"),
                trailing: new Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => Log()));
                }),
            new ListTile(
                title: new Text("Tentang"),
                trailing: new Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => tentang()));
                }),
            new Divider(),
            new ListTile(
              title: new Text("Close"),
              trailing: new Icon(Icons.cancel),
              onTap: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ProfileBox(),
            SizedBox(
              height: 16,
            ),
            NewsBox(),
            SizedBox(
              height: 16,
            ),
            // NewsListBox(),
            // SizedBox(
            //   height: 16,
            // ),
            // NewsListBox(),
          ],
        ),
      ),
    );
  }
}

class ProfileBox extends StatefulWidget {
  const ProfileBox({super.key});

  @override
  State<ProfileBox> createState() => _ProfileBoxState();
}

class _ProfileBoxState extends State<ProfileBox> {
  String mainProfilePicture = "https://randomuser.me/api/portraits/men/44.jpg";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Profil
        Text(
          'Profil',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6),
        Container(
          width: double.maxFinite,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.5),
            //     spreadRadius: 1,
            //     blurRadius: 5,
            //     offset: Offset(0, 1),
            //   ),
            // ],
            border: Border.all(
              color: Colors.grey,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipOval(
                    child: new CircleAvatar(
                  backgroundImage: new NetworkImage(mainProfilePicture),
                )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang,',
                      style: GoogleFonts.inter(),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'IRFAN TRIADI SAPUTRA',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => ProfilePage()));
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NewsBox extends StatelessWidget {
  const NewsBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Berita',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6),
        Container(
          width: double.maxFinite,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey,
            ),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.5),
            //     spreadRadius: 2,
            //     blurRadius: 5,
            //     offset: Offset(0, 3),
            //   ),
            // ],
          ),
          child: Icon(
            Icons.image,
            size: 56,
          ),
          // child: ClipRRect(
          //   borderRadius: BorderRadius.circular(20), // Image border
          //   child: SizedBox.fromSize(
          //     size: Size.fromRadius(16), // Image radius
          //     child: Image.asset(
          //       'assets/images/no_image.jpg',
          //       fit: BoxFit.fill,
          //     ),
          //   ),
          // ),
        ),
      ],
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List _posts = [];

  @override
  void initState() {
    super.initState();
    _getData(
        "https://newsapi.org/v2/top-headlines?country=id&apiKey=99ea1dbf40e843b8a455af25c3544b83");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              '${_posts[index]['title']}',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: Container(
              height: 100,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey,
                ),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.5),
                //     spreadRadius: 2,
                //     blurRadius: 5,
                //     offset: Offset(0, 3),
                //   ),
                // ],
              ),
              child: _posts[index]['urlToImage'] != null
                  ? Image.network(
                      _posts[index]['urlToImage'],
                      width: 100,
                      fit: BoxFit.cover,
                    )
                  : Center(),
            ),
            subtitle: Text(
              '${_posts[index]['description']}',
              maxLines: 3,
              textAlign: TextAlign.justify,
              style: GoogleFonts.inter(
                fontSize: 14,
                height: 1.5,
              ),
            ),
            onTap: () {},
          );
        },
      ),
    );
  }

  Future _getData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _posts = data['articles'];
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
