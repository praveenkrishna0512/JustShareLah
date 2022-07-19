import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/models/ListingCard.dart';
import 'package:justsharelah_v1/models/enlarged_listing.dart';

// class _AllBorrowingState extends State<Favourites> {
class Favourites extends StatefulWidget {
  Favourites({
    Key? key,
  }) : super(key: key);

  // get current user
  final String? currUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  String searchListingText = "";

  // Future<Iterable<Listing>> borrowingData =
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body:
            ListView(padding: const EdgeInsets.all(defaultPadding), children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_outline_sharp,
                  size: 30,
                  color: Colors.redAccent,
                ),
                SizedBox(width: 10),
                Text(
                  "Your Favourites",
                  textAlign: TextAlign.start,
                  style: kJustShareLahStyle.copyWith(
                      fontSize: 35, fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.favorite_outline_sharp,
                  size: 30,
                  color: Colors.redAccent,
                ),
              ],
            ),
            Center(
              child: const Text(
                'Listings You Have Liked',
                style: TextStyle(fontSize: 15.0, color: Colors.blueGrey),
              ),
            ),
            const SizedBox(height: defaultPadding),
          ]),
          StreamBuilder(
            // only show those whereby usersLiked array contains current user's uid
            stream: FirebaseFirestore.instance
                .collection("listings")
                .where("usersLiked",
                    arrayContains: FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData) {
                return const Text("Awaiting result...");
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return const Text("Error Loading Borrowing Items");
              }

              // Iterable<Listing>? listingDataIterable = snapshot.data!;
              // if (listingDataIterable == null ||
              //     listingDataIterable.isEmpty) {
              //   return const Text("No such listings :(");
              // }
              // List<Listing> listingData = listingDataIterable.toList();
              return SizedBox(
                height: 500,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    // docs method gives us list of document id of the listings
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => Container(
                          alignment: Alignment.center,
                          child: ListingCard(
                            // collect the data for each indiviudal document at the index
                            snap: snapshot.data!.docs[index].data(),
                            // image: listingData[index].imageUrl,
                            // title: listingData[index].title,
                            // price: listingData[index].price,
                            press: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EnlargedScreen(
                                        snap:
                                            snapshot.data!.docs[index].data()),
                                  ));
                            },
                          ),
                        )),
              );

              // // print("going to cast listing data");

              // // return Row(
              // //     crossAxisAlignment: CrossAxisAlignment.start,
              // //     children: List.generate(
              // //       listingData.length,
              // //       (index) => Padding(
              // //         padding: const EdgeInsets.only(right: defaultPadding),
              // //         child: ListingCard(
              // //           image: listingData[index].imageUrl,
              // //           title: listingData[index].title,
              // //           price: listingData[index].price,
              // //           press: () {
              // //             Navigator.push(
              // //                 context,
              // //                 MaterialPageRoute(
              // //                   builder: (context) => EnlargedScreen(
              // //                       listing: listingData[index]),
              // //                 ));
              // //           },
              //         ),
              //       ),
              //     ));
            },
          )
        ]));
  }
}
