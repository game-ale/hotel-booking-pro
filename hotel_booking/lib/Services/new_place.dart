import 'package:flutter/material.dart';
import 'package:hotel_booking/Services/widget_suppiler.dart';

Widget buildSmallPlaceCard(String image, String city, String hotels) {
  return Container(
    width: 180,
    margin: const EdgeInsets.only(left: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(image, height: 170, width: 180, fit: BoxFit.cover),
        ),
        const SizedBox(height: 5),
        Text(city, style: AppWidget.headlineTextStyle(16)),
        Text(hotels, style: AppWidget.blackTextStyle(14)),
      ],
    ),
  );
}
