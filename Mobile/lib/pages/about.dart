import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stuntingapp/auth.dart';
import 'package:stuntingapp/pages/add.dart';
import 'package:stuntingapp/pages/chatbot.dart';
import 'package:stuntingapp/pages/home_page2.dart';

class tentang extends StatefulWidget {
  final User? user = Auth().currentUser;

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  @override
  _tentangState createState() => new _tentangState();
}

class _tentangState extends State<tentang> {
  XFile? image;

  final ImagePicker picker = ImagePicker();

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [],
              ),
            ),
          );
        });
  }

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

  List _posts = [];
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("TENTANG"),
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
                          backgroundImage:
                              new NetworkImage(otherProfilePicture)),
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
                  title: new Text("Berita"),
                  trailing: new Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => HomePage2()));
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
        body: new Center(
            child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text("Virtual Assistant Stunting", textScaleFactor: 1.5),
            new Text("STUNTTING APP", textScaleFactor: 1.5),
            Text("OWNER : TEAM SMATECH"),
            SizedBox(
              height: 5,
            ),
            Text("Member :"),
            Text("1. Irfan Triadi Saputra"),
            Text("2. Mokhamad Akbar Wijaya"),
            Text("3. Laeli Nurafiah"),
            Text("4. Koandres"),
            SizedBox(
              height: 5,
            ),
            Text("Teknik Informatika"),
            Text("Politeknik Harapan Bersama"),
          ],
        )));
  }
}
