import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  XFile? image;
  ImagePicker picker = ImagePicker();

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
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  Text(""),
                  Text("atau"),
                  Text(""),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
              height: 200,
              color: Colors.red,
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                        shape: BoxShape.circle,

                        //image: Image.file(file)
                        // image: DecorationImage(
                        //   fit: BoxFit.cover,
                        //   image: ImageProvider.(File(image!.path)),
                        // ),
                      ),
                      child: image == null
                          ? Container()
                          : CircleAvatar(
                            
                              child: Image.file(
                                File(image!.path),
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 4, color: Colors.white),
                            color: Colors.red),
                        child: IconButton(
                          onPressed: () async {
                            image = await picker.pickImage(
                                source: ImageSource.gallery);
                            setState(() {
                              //update UI
                            });
                          },
                          icon: Icon(Icons.edit),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          ListTile(
            title: Text('Username'),
            subtitle: Text('irfantriadis'),
          ),
          ListTile(
            title: Text('Email'),
            subtitle: Text('john.doe@example.com'),
          ),
          ListTile(
            title: Text('Location'),
            subtitle: Text('San Francisco, CA'),
          ),
          ListTile(
            title: Text('Bio'),
            subtitle: Text('Software engineer and Flutter enthusiast'),
          ),
        ],
      ),
    );
  }
}
