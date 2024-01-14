import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpilot_app/assistantmethods/assistant_method.dart';
import 'package:foodpilot_app/global/global.dart';
import 'package:foodpilot_app/widgets/order_card.dart';
import 'package:foodpilot_app/widgets/simple_app_bar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(
          title: "History",
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .where("riderUID", isEqualTo: sharedPreferences!.getString("uid"))
              .where("status", isEqualTo: "ended")
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (c, index) {
                      return FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection("items")
                              .where("itemID",
                                  whereIn: separateOrdersItemIDs((snapshot
                                          .data!.docs[index]
                                          .data()!
                                      as Map<String, dynamic>)["productIDs"]))
                              .orderBy("publishedDate", descending: true)
                              .get(),
                          builder: (c, snap) {
                            return snap.hasData
                                ? OrderCard(
                                    itemCount: snap.data!.docs.length,
                                    data: snap.data!.docs,
                                    orderID: snapshot.data!.docs[index].id,
                                    separateQuantitiesList:
                                        separateOrderItemQuantities(
                                            (snapshot.data!.docs[index].data()!
                                                    as Map<String, dynamic>)[
                                                "productIDs"]),
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  );
                          });
                    },
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
