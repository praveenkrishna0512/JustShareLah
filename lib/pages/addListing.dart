import 'dart:ffi';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:justsharelah_v1/firebase/firestore_methods.dart';
import 'package:justsharelah_v1/models/user_data.dart';
import 'package:justsharelah_v1/utils/bottom_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justsharelah_v1/utils/appbar.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/utils/image_picker.dart';
import 'package:justsharelah_v1/provider/user_provider.dart';

class AddListingPage extends StatefulWidget {
  const AddListingPage({Key? key}) : super(key: key);

  @override
  State<AddListingPage> createState() => _AddListingPageState();
}

class _AddListingPageState extends State<AddListingPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _listingTypeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  //listing image
  Uint8List? _image;
  final listingsCollection = FirebaseFirestore.instance.collection('listings');
  final currentUser = FirebaseAuth.instance.currentUser;
  late String? userEmail;
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  late UserData userData = UserData.defaultUserData();
  var parseUserData;
  // for rent or borrow dropdown
  String dropdownValue = 'Lending';
  List<String> listingTypes = ['Lending', 'Renting'];

  // ================ User Information =============================

  @override
  void initState() {
    userEmail = currentUser?.email;
    _getUserData().then((data) {
      UserData parseUserData = UserData(
        uid: currentUser?.uid,
        userName: data["username"],
        firstName: data["first_name"],
        lastName: data["last_name"],
        email: userEmail,
        phoneNumber: data["phone_number"],
        about: data["about"],
        imageUrl: data["imageUrl"],
        listings: data["listings"],
        reviews: data["reviews"],
        shareCredits: data["share_credits"],
      );
      if (mounted) {
        setState(() {
          userData = parseUserData;
        });
      }
    });
    super.initState();
  }

  Future<Map<String, dynamic>> _getUserData() async {
    Map<String, dynamic> userData = <String, dynamic>{};
    await usersCollection.where('email', isEqualTo: userEmail).get().then(
      (res) {
        print("userData query successful");
        userData = res.docs.first.data();
      },
      onError: (e) => print("Error completing: $e"),
    );

    return userData;
  }

  // ================ ImagePickers =============================
  void selectImageGallery() async {
    final Uint8List? pickedImage = await pickImage(ImageSource.gallery);
    if (mounted) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  void selectImageCamera() async {
    final Uint8List? pickedImage = await pickImage(ImageSource.camera);
    if (mounted) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  // ================ Image Diaglogue ====================

  // pick image from gallery
  // Implementing the image picker

  // make call the pickImage from the image_picker.dart utils
  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List imagePicked = await pickImage(ImageSource.camera);
                  if (mounted) {
                    setState(() {
                      _image = imagePicked;
                    });
                  }
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List imagePicked = await pickImage(ImageSource.gallery);
                  if (mounted) {
                    setState(() {
                      _image = imagePicked;
                    });
                  }
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  // ================ Firebase interface =============

  void addListing(String uid, String profImgUrl, String email) async {
    if (userEmail == null) {
      showSnackBar(context, "Error fetching user, unable to add listing");

      return;
    }
    if (dropdownValue != 'Lending' && dropdownValue != 'Renting') {
      showSnackBar(
          context, 'Choose a proper listing type, unable to add listing');
      return;
    }

    bool forRent = dropdownValue == 'Renting' ? true : false;

    try {
      // upload to both storage and 'listing' collection
      String res = await FireStoreMethods().uploadlisting(
          _titleController.text,
          _descriptionController.text,
          _image!,
          uid,
          email,
          profImgUrl,
          forRent,
          _priceController.text);
      if (res == "success") {
        showSnackBar(context, 'Posted!');
        clearImage();
      }
    } catch (err) {
      print(err);
      // showSnackBar(context, err.toString());
    }
  }

  void clearImage() {
    if (mounted) {
      setState(() {
        _image = null;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _listingTypeController.dispose();
  }

  // ================ Widgets =============================

  ElevatedButton buildButtonField(
      String text, Color color, double length, void Function()? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: length),
          primary: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 15, letterSpacing: 2.5, color: Colors.black),
      ),
    );
  }

  Expanded buildFormField(String hintText, TextEditingController controller) {
    return Expanded(
      child: Container(
          padding: EdgeInsets.only(top: 20, right: 20, left: 20),
          child: SizedBox(
            width: 100,
            height: 40.0,
            child: TextField(
              onChanged: (value) => print(value),
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
              ),
            ),
          )),
    );
  }

  // create class for dropdown menu items
  DropdownButtonFormField<String> buildRentOrBorrowDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
        Radius.circular(30.0),
      ))),
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward_rounded),
      elevation: 2,
      style: const TextStyle(color: Colors.grey, fontSize: 17),
      onChanged: (String? newValue) {
        if (mounted) {
          setState(() {
            dropdownValue = newValue!;
          });
        }
      },
      items: listingTypes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Container buildFormTitle(String text) {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Text(
        text,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  // void _addListing() {
  // var addedListing = {
  //   'imageUrl': _image!,
  //   'title': _titleController.text,
  //   'price': _priceController.text,
  //   'for_rent': forRent,
  //   'description': _descriptionController.text,
  //   'available': true,
  //   'created_by_email': userEmail,
  //   'likeCount': 0,
  // };
  // listingsCollection
  //     .add(addedListing)
  //     .then((value) => print('Listing Added'))
  //     .catchError((err) => print('Failed to add listing: $err'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          MyAppBar().buildAppBar(const Text("Add Listing"), context, '/feed'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Stack(
              // circular widget to accept and show selected image
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 70, backgroundImage: MemoryImage(_image!))
                    : CircleAvatar(
                        radius: 70,
                        backgroundColor: Color.fromARGB(255, 226, 224, 224),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset('images/gallery.png',
                              width: 100, height: 120),
                        ),
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: () {
                      _selectImage(context);
                    },
                    icon: const Icon(
                      Icons.add_a_photo,
                    ),
                  ),
                ),
              ],
            ),
            Row(children: <Widget>[
              buildFormTitle("Listing Title"),
              const SizedBox(
                width: 10.0,
              ),
              buildFormField("Enter Listing Details", _titleController),
            ]),
            const SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                buildFormTitle("Listing Type"),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(child: buildRentOrBorrowDropdown()),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(children: <Widget>[
              buildFormTitle("Price"),
              const SizedBox(
                width: 10.0,
              ),
              buildFormField("Enter Price of Listing ", _priceController),
            ]),
            // const SizedBox(height: 10.0),
            // Row(children: <Widget>[
            //   buildFormTitle("Brand"),
            //   const SizedBox(
            //     width: 10.0,
            //   ),
            //   buildFormField("Enter Brand of Listing ", _brandController),
            // ]),
            const SizedBox(height: 10.0),
            Row(children: <Widget>[
              buildFormTitle("Description"),
              const SizedBox(
                width: 10.0,
              ),
              buildFormField("Give us a brief description of your listing",
                  _descriptionController),
            ]),
            const SizedBox(height: 10.0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              buildButtonField("CANCEL", Colors.red, 20.0, () {
                Navigator.pop(context);
              }),
              const SizedBox(width: 60),
              buildButtonField("ADD LISTING", Colors.green, 30.0, () {
                addListing(
                  userData.uid!,
                  userData.imageUrl!,
                  userData.email!,
                );
                Navigator.pop(context);
              }),
            ]),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavBar().buildBottomNavBar(context),
    );
  }
}
