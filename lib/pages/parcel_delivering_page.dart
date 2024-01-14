import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpilot_app/assistantmethods/get_current_location.dart';
import 'package:foodpilot_app/global/global.dart';
import 'package:foodpilot_app/map/maps_utils.dart';
import 'package:foodpilot_app/pages/splash_page.dart';

class ParcelDeliveringPage extends StatefulWidget {
  String? purchaserId;
  String? purchaserAddress;
  double? purchaserLat;
  double? purchaserLng;
  String? sellerId;
  String? getOrderId;

  ParcelDeliveringPage({
    super.key,
    this.purchaserId,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng,
    this.sellerId,
    this.getOrderId,
  });

  @override
  State<ParcelDeliveringPage> createState() => _ParcelDeliveringPageState();
}

class _ParcelDeliveringPageState extends State<ParcelDeliveringPage> {
  String orderTotalAmount = "";

  confirmParelHasBeenDelivered(getOrderId, sellerId, purchaserId,
      purchaserAddress, purchaserLat, purchaserLng) {
    print(confirmParelHasBeenDelivered);
    String riderNewTotalEarningAmount = ((double.parse(previousRiderEarnings)) +
            (double.parse(perParcelDeliveryAmount)))
        .toString();

    FirebaseFirestore.instance.collection("orders").doc(getOrderId).update({
      "status": "ended",
      "address": completeAddress,
      "lat": position!.latitude,
      "lng": position!.longitude,
      // Pay per parcel Delivery amount
      "earning": perParcelDeliveryAmount,
    }).then((value) {
      FirebaseFirestore.instance
          .collection("riders")
          .doc(sharedPreferences!.getString("uid"))
          .update({
        "earning":
            riderNewTotalEarningAmount, //->Tottal earnings amount of rider
      });
    }).then((value) {
      FirebaseFirestore.instance
          .collection("sellers")
          .doc(widget.sellerId)
          .update({
        "earning":
            (double.parse(orderTotalAmount) + (double.parse(previousEarnings)))
                .toString(), //->Tottal earnings amount of seller
      });
    }).then((value) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(purchaserId)
          .collection("orders")
          .doc(getOrderId)
          .update({
        "status": "ended",
        "status": sharedPreferences!.getString("uid"),
      });
    });

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SplashPage()));
  }

// Order Total Amount
  getOrderTotalAmount() {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.getOrderId)
        .get()
        .then((snap) {
      orderTotalAmount = snap.data()!["totalAmount"].toString();
      widget.sellerId = snap.data()!["sellerUID"].toString();
    }).then((value) {
      getSellerData();
    });
  }

  getSellerData() {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.sellerId)
        .get()
        .then((snap) {
      previousEarnings = snap.data()!["earning"].toString();
    });
  }

  @override
  void initState() {
    super.initState();

    // This is riderlocation(UserLocation)
    UserLocation uLocation = UserLocation();
    uLocation.getCurrentLocation();

    getOrderTotalAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/delivery.jpg",
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
                widget.purchaserLat,
                widget.purchaserLng,
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
                  'assets/images/small-cartoon-house.jpg',
                  width: 80,
                ),
                const SizedBox(width: 7),
                const Column(
                  children: [
                    SizedBox(height: 4),
                    Text(
                      "Show delivery drop-of location",
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
                  // This is riderlocation(UserLocation)
                  UserLocation uLocation = UserLocation();
                  uLocation.getCurrentLocation();

                  // Confirmed - that rider has picked parcel from seller
                  confirmParelHasBeenDelivered(
                    widget.getOrderId,
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
                      "Order has been Delivered - Confirm",
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
