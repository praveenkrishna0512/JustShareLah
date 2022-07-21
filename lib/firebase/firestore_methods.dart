import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/firebase/firestore_keys.dart';
import 'package:justsharelah_v1/firebase/storage_methods.dart';
import 'package:justsharelah_v1/models/listings.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  // listings folder in firebase
  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static final listingsCollection =
      FirebaseFirestore.instance.collection('listings');
  static final usersCollection = FirebaseFirestore.instance.collection('Users');

  Future<String> uploadlisting(
    String title,
    String description,
    Uint8List file,
    String uid,
    String createdByEmail,
    String profImageUrl,
    bool forRent,
    String price,
    String shareCredits,
    double longitude,
    double latitude,
    String location,
  ) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";

    try {
      String imageUrl =
          await StorageMethods().uploadPicToStorage('listings', file, true);
      List<String> splitTitle = title.split(' ');
      List<String> indexTitle = [];

      // for each word
      for (int i = 0; i < splitTitle.length; i++) {
        for (int j = 0; j < splitTitle[i].length + 1; j++) {
          indexTitle.add(splitTitle[i].substring(0, j).toLowerCase());
        }
      }

      // for words with spaces
      for (int i = 0; i < title.length + 1; i++) {
        if (indexTitle.contains(title.substring(0, i)) == false) {
          indexTitle.add(title.substring(0, i).toLowerCase());
        }
      }

      // to create uniqud id based on time, won't have the same id
      String listingId = const Uuid().v1(); // creates unique id based on time
      Listing listing = Listing(
          description: description,
          title: title,
          uid: listingId,
          available: true,
          price: price,
          shareCredits: shareCredits,
          forRent: forRent,
          createdByEmail: createdByEmail,
          usersLiked: [],
          likeCount: 0,
          dateListed: DateTime.now(),
          imageUrl: imageUrl,
          searchIndex: indexTitle,
          GeoLocation: GeoPoint(latitude, longitude),
          location: location);

      listingsCollection.doc(listingId).set(listing.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  static Future<Map<String, dynamic>> getListingData(String listingId) async {
    Map<String, dynamic> listingData = <String, dynamic>{};
    // get data where 'email' field is = email argument field
    await usersCollection.doc(listingId).get().then(
      (res) {
        print("listingData query successful");
        listingData = res.data()!;
      },
      onError: (e) => print("Error completing: $e"),
    );

    return listingData;
  }

  // uid of the users that liked the listing
  Future<String> likelisting(
      String listingId, String? uid, List<dynamic> likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains current users' uid, then remove it (unlike)

        await listingsCollection.doc(listingId).update({
          'usersLiked': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        await listingsCollection.doc(listingId).update({
          'usersLiked': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<bool> editListing(
      String uid,
      String title,
      String price,
      String description,
      bool forRent,
      bool avail,
      String location,
      GeoPoint geoLocation) async {
    Map<String, dynamic>? listingData;
    String? docID;
    await listingsCollection.where("uid", isEqualTo: uid).get().then(
      (res) {
        print("listingsData query successful");
        listingData = res.docs.first.data();
        docID = res.docs.first.id;
      },
      onError: (e) => print("Error completing: $e"),
    );

    if (uid == null || uid == null) {
      return false;
    }

    // if empty, remains the same, else take the controller variable
    listingData!["title"] = title.isEmpty ? listingData!["title"] : title;
    listingData!["price"] = price.isEmpty ? listingData!["price"] : price;
    listingData!["description"] =
        description.isEmpty ? listingData!["description"] : description;
    listingData!["forRent"] = forRent;
    listingData!["available"] = avail;

    listingData!["location"] =
        location.isEmpty ? listingData!["location"] : location;
    listingData!["GeoLocation"] = geoLocation;

    listingsCollection
        .doc(docID)
        .update(listingData!)
        .then((value) => print('Edited Profile'))
        .catchError((err) => print('Failed to edit profile: $err'));
    return true;
  }

  // update the location of users
  Future<void> updateLocation(
      double longitude, double latitude, String? uid) async {
    CollectionReference users = FirebaseFirestore.instance.collection("Users");
    return await users
        .doc(uid)
        .update({"location": GeoPoint(latitude, longitude)});
  }

  // update location of the listing
  Future<void> updateListingLocation(
      double longitude, double latitude, String? listingId) async {
    CollectionReference listings =
        FirebaseFirestore.instance.collection("listings");
    return await listings
        .doc(listingId)
        .update({"location": GeoPoint(latitude, longitude)});
  }

  // searching for listing
  searchListing(String listingTitle) async {
    return await listingsCollection
        .where("title", isEqualTo: listingTitle)
        .get();
  }

  // listing comment
  String listingComment(String listingId, String text, String uid, String name,
      String profilePic) {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        listingsCollection
            .doc(listingId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'dateCreated': Timestamp.fromDate(DateTime.now()),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete listing
  Future<String> deletelisting(String listingId) async {
    String res = "Some error occurred";
    try {
      await listingsCollection.doc(listingId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  static Future<void> updateFirestoreData(
      String collectionPath, String path, Map<String, dynamic> updateData) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(updateData);
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getListingDataStreamFromId(String uid) {
    return listingsCollection.doc(uid).snapshots();
  }

  static Future<Map<String, dynamic>> getUserData(String email) async {
    Map<String, dynamic> userData = <String, dynamic>{};
    // get data where 'email' field is = email argument field
    await usersCollection.where('email', isEqualTo: email).get().then(
      (res) {
        print("userData query successful");
        userData = res.docs.first.data();
      },
      onError: (e) => print("Error completing: $e"),
    );

    return userData;
  }

}
