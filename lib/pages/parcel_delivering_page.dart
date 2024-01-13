import 'package:flutter/material.dart';

class ParcelDeliveringPage extends StatefulWidget {
  String? purchaserId;
  String? purchaserAddress;
  String? purchaserLat;
  String? purchaserLng;
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
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
