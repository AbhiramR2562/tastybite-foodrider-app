import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodpilot_app/models/items.dart';
import 'package:foodpilot_app/pages/order_details_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class OrderCard extends StatelessWidget {
  final int? itemCount;
  final List<DocumentSnapshot>? data;
  final String? orderID;
  final List<String>? separateQuantitiesList;
  const OrderCard(
      {super.key,
      this.itemCount,
      this.data,
      this.orderID,
      this.separateQuantitiesList});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //-> Navigate to OrderDetailsPage
      onTap: () {
        //requestLocationPermission();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderDetailsPage(orderID: orderID)));
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.black12,
                Colors.white54,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        height: itemCount! * 125,
        child: ListView.builder(
          itemCount: itemCount,
          itemBuilder: ((context, index) {
            Items model =
                Items.fromJson(data![index].data()! as Map<String, dynamic>);
            return placedOrderDesignWidget(
              model,
              context,
              separateQuantitiesList![index],
            );
          }),
        ),
      ),
    );
  }
}

Widget placedOrderDesignWidget(
    Items model, BuildContext context, separateQuantitiesList) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 120,
    color: Colors.grey[200],
    child: Row(
      children: [
        Image.network(
          model.thumbnailUrl!,
          width: 120,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      model.title!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "\$",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    model.price.toString(),
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const Text(
                    "x ",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      separateQuantitiesList,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 30,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    ),
  );
}
