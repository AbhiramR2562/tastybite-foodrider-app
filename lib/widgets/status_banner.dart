import 'package:flutter/material.dart';
import 'package:foodpilot_app/pages/home_page.dart';

class StatusBanner extends StatelessWidget {
  final bool? status;
  final String? orderStatus;
  const StatusBanner({super.key, this.status, this.orderStatus});

  @override
  Widget build(BuildContext context) {
    String? message;
    IconData? iconData;

    status! ? iconData = Icons.done : Icons.cancel;
    status! ? message = "Successful" : message = "Unsuccessful";

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Colors.orange,
              Colors.red,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage())),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 20),
          Text(
            orderStatus == "ended"
                ? "Parcel delivered $message"
                : "Order placed $message",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 5),
          CircleAvatar(
            radius: 8,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14,
              ),
            ),
          )
        ],
      ),
    );
  }
}
