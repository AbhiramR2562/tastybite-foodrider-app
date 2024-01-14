import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpilot_app/assistantmethods/get_current_location.dart';
import 'package:foodpilot_app/authentication/auth_page.dart';
import 'package:foodpilot_app/global/global.dart';
import 'package:foodpilot_app/pages/earnings_page.dart';
import 'package:foodpilot_app/pages/history_page.dart';
import 'package:foodpilot_app/pages/new_orders_page.dart';
import 'package:foodpilot_app/pages/not_yet__delivered_page.dart';
import 'package:foodpilot_app/pages/parcel_in_progress_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Card makeDashboardItem(String title, IconData iconData, int index) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(8),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.orange,
                      Colors.red,
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              )
            : const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.yellow,
                      Colors.orangeAccent,
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
        child: InkWell(
          onTap: () {
            if (index == 0) {
              // new available order
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewOrdersPage()));
            }
            if (index == 1) {
              // Parcel in progress
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ParcelInProgressPage()));
            }
            if (index == 2) {
              // Not yet delivered
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotYetDeliveredPage()));
            }
            if (index == 3) {
              // History
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HistoryPage()));
            }
            if (index == 4) {
              // Tottal earnings
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EarningsPage()));
            }
            if (index == 5) {
              // Logout
              firebaseAuth.signOut().then((value) => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AuthPage())));
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(height: 50),
              Center(
                child: Icon(
                  iconData,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    UserLocation uLocation = UserLocation();
    uLocation.getCurrentLocation();
    getPerParcelDeliveryAmount();
    getRiderPreviousEarnings();
  }

  getRiderPreviousEarnings() {
    FirebaseFirestore.instance
        .collection("riders")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap) {
      previousRiderEarnings = snap.data()!["earning"].toString();
    });
  }

  getPerParcelDeliveryAmount() {
    FirebaseFirestore.instance
        .collection("perDelivery")
        .doc("tasty159")
        .get()
        .then((snap) {
      perParcelDeliveryAmount = snap.data()!["amount"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
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
        ),
        title: Text(
          "Welcome  " + sharedPreferences!.getString("name")!,
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(2),
          children: [
            makeDashboardItem("New available orders", Icons.assignment, 0),
            makeDashboardItem("Parcel in progress", Icons.airport_shuttle, 1),
            makeDashboardItem("Not yet delivered", Icons.location_history, 2),
            makeDashboardItem("History", Icons.done_all, 3),
            makeDashboardItem("Tottal earning", Icons.monetization_on, 4),
            makeDashboardItem("Logout", Icons.logout, 5),
          ],
        ),
      ),
    );
  }
}
