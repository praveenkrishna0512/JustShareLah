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
  final listingsCollection = FirebaseFirestore.instance.collection('listings');

  Future<String> uploadlisting(
    String title,
    String description,
    Uint8List file,
    String uid,
    String createdByEmail,
    String profImageUrl,
    bool forRent,
    String price,
  ) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String imageUrl =
          await StorageMethods().uploadPicToStorage('listings', file, true);

      // to create uniqud id based on time, won't have the same id
      String listingId = const Uuid().v1(); // creates unique id based on time
      Listing listing = Listing(
        description: description,
        title: title,
        uid: listingId,
        available: true,
        price: price,
        forRent: forRent,
        createdByEmail: createdByEmail,
        usersLiked: [],
        likeCount: 0,
        dateListed: DateTime.now(),
        imageUrl: imageUrl,
        profImageUrl: profImageUrl,
      );

      listingsCollection.doc(listingId).set(listing.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // uid of the users that liked the listing
  Future<String> likelisting(String listingId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains current uid, then remove it (unlike)

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

  // listing comment
  Future<String> listingComment(String listingId, String text, String uid,
      String name, String profilePic) async {
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

  static Stream<QuerySnapshot> getFirestoreChatData(
      String collectionPath, int limit, String? textSearch) {
    if (textSearch?.isNotEmpty == true) {
      return firebaseFirestore
          .collection(collectionPath)
          .limit(limit)
          .where(FirestoreUserKeys.username, isEqualTo: textSearch)
          .snapshots();
    } else {
      return firebaseFirestore
          .collection(collectionPath)
          .limit(limit)
          .snapshots();
    }
  }
}
