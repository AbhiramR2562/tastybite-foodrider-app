import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpilot_app/global/global.dart';
import 'package:foodpilot_app/models/address.dart';
import 'package:foodpilot_app/widgets/shipment_address_design.dart';
import 'package:foodpilot_app/widgets/status_banner.dart';
import 'package:intl/intl.dart';

class OrderDetailsPage extends StatefulWidget {
  final String? orderID;
  const OrderDetailsPage({super.key, this.orderID});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  String orderStatus = "";
  String orderByUser = "";
  String sellerId = "";

  getOrderInfo() {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderID)
        .get()
        .then((DocumentSnapshot) {
      orderStatus = DocumentSnapshot.data()!["status"].toString();
      orderByUser = DocumentSnapshot.data()!["orderBy"].toString();
      sellerId = DocumentSnapshot.data()!["sellerUID"].toString();
    });
  }

  @override
  void initState() {
    super.initState();

    getOrderInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("orders")
              .doc(widget.orderID)
              .get(),
          builder: (context, snapshot) {
            Map? dataMap;
            if (snapshot.hasData) {
              dataMap = snapshot.data!.data() as Map<String, dynamic>;
              orderStatus = dataMap["status"].toString();
            }
            return snapshot.hasData
                ? Container(
                    child: Column(
                      children: [
                        StatusBanner(
                          status: dataMap!["isSuccess"],
                          orderStatus: orderStatus,
                        ),
                        const SizedBox(height: 10),

                        //-> Tottal Amount
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Tottal: " +
                                  "\$" +
                                  dataMap["totalAmount"].toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        //-> Order Id
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Order Id: " + widget.orderID!,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),

                        //-> Order at (time)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Order at: " +
                                DateFormat("dd MMMM, yyyy - hh:mm aa").format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(dataMap["orderTime"]))),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const Divider(thickness: 4),
                        orderStatus == "ended"
                            ? Column(
                                children: [
                                  const SizedBox(height: 5),
                                  const Text(
                                    "Delivered",
                                    style: TextStyle(
                                      fontSize: 35,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Image.asset(
                                      "assets/images/pngtree-green-approved.png"),
                                ],
                              )
                            : Image.asset("assets/images/delivery-ongoing.jpg"),
                        const Divider(thickness: 4),
                        FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection("users")
                              .doc(orderByUser)
                              .collection("userAddress")
                              .doc(dataMap["addressID"])
                              .get(),
                          builder: ((context, snapshot) {
                            return snapshot.hasData
                                ? ShipmentAddressDesign(
                                    model: Address.fromJson(snapshot.data!
                                        .data()! as Map<String, dynamic>),
                                    orderStatus: orderStatus,
                                    orderId: widget.orderID,
                                    sellerId: sellerId,
                                    orderByUser: orderByUser,
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  );
                          }),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}
