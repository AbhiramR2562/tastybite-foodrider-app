import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpilot_app/assistantmethods/get_current_location.dart';
import 'package:foodpilot_app/global/global.dart';
import 'package:foodpilot_app/map/maps_utils.dart';
import 'package:foodpilot_app/pages/parcel_delivering_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ParcelPickingPage extends StatefulWidget {
  String? purchaserId;
  String? sellerId;
  String? getOrderID;
  String? purchaserAddress;
  double? purchaserLat;
  double? purchaserLng;

  ParcelPickingPage({
    super.key,
    this.purchaserId,
    this.sellerId,
    this.getOrderID,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng,
  });

  @override
  State<ParcelPickingPage> createState() => _ParcelPickingPageState();
}

class _ParcelPickingPageState extends State<ParcelPickingPage> {
  double? sellerLat, sellerLng;

  getSellerData() async {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.sellerId)
        .get()
        .then((DocumentSnapshot) {
      sellerLat = DocumentSnapshot.data()!["lat"];
      sellerLng = DocumentSnapshot.data()!["lng"];
    });
  }

  @override
  void initState() {
    super.initState();
    getSellerData();
  }

  confirmParelHasBeenPicked(getOrderId, sellerId, purchaserId, purchaserAddress,
      purchaserLat, purchaserLng) {
    FirebaseFirestore.instance.collection("orders").doc(getOrderId).update({
      "status": "delivering",
      "address": completeAddress,
      "lat": position!.latitude,
      "lng": position!.longitude,
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ParcelDeliveringPage(
                  purchaserId: purchaserId,
                  purchaserAddress: purchaserAddress,
                  purchaserLat: purchaserLat,
                  purchaserLng: purchaserLng,
                  sellerId: sellerId,
                  getOrderId: getOrderId,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/delivery-ongoing.jpg",
            width: 350,
          ),
          const SizedBox(height: 5),

          //Button
          GestureDetector(
            onTap: () {
              // Show location from rider current location to cafe
              MapUtils.launchMapFromSourceToDestination(
                position!.latitude,
                position!.longitude,
                sellerLat,
                sellerLng,
              );
              // // Assuming you have a position variable representing the user's current location
              // double userLat = position!
              //     .latitude; // Replace with the actual variable storing user's latitude
              // double userLng = position!
              //     .longitude; // Replace with the actual variable storing user's longitude

              // // Construct the map URL
              // String mapUrl =
              //     "https://www.google.com/maps?saddr=$userLat,$userLng&daddr=$sellerLat,$sellerLng&dir_action=navigate";

              // // Launch the map with the specified package name
              // launch(mapUrl, forceSafariVC: false);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/small-business-store-shop-design-restaurants-vector-44930113-removebg-preview.png',
                  width: 60,
                ),
                const SizedBox(width: 7),
                const Column(
                  children: [
                    SizedBox(height: 4),
                    Text(
                      "Show Cafe/Resturant location",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Order has been picked - Confirmed
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: InkWell(
                onTap: () {
                  UserLocation uLocation = UserLocation();
                  uLocation.getCurrentLocation();

                  // Confirmed - that rider has picked parcel from seller
                  confirmParelHasBeenPicked(
                    widget.getOrderID,
                    widget.sellerId,
                    widget.purchaserId,
                    widget.purchaserAddress,
                    widget.purchaserLat,
                    widget.purchaserLng,
                  );
                },
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.lightBlue,
                          Colors.green,
                        ],
                        begin: FractionalOffset(0.0, 0.0),
                        end: FractionalOffset(1.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: MediaQuery.of(context).size.width - 90,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Order has been picked - Confirmed",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
