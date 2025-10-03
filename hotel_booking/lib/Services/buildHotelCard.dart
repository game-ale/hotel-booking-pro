import 'package:flutter/material.dart';
import 'package:hotel_booking/Services/widget_suppiler.dart'; // 🎨 Styles
import "package:hotel_booking/pages/deteil_page.dart"; // 📄 DetailPage

// 🎴 HotelCard: small card widget for home page
class HotelCard extends StatelessWidget {
  final String image; // Hotel image path
  final String title; // Hotel title
  final String price; // Price (string with $)
  final String location; // Location string

  const HotelCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // 👉 Makes the whole card tappable
      onTap: () {
        // Navigate to DetailPage with passed data
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetailPage(
              image: image,
              title: title,
              price: price,
              location: location,
            ),
          ),
        );
      },
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          width: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hotel image with Hero animation
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Hero(
                  tag: image, // 👈 must match DetailPage hero tag
                  child: Image.asset(
                    image,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Title + Price
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppWidget.headlineTextStyle(18.0),
                      ),
                    ),
                    Text(price, style: AppWidget.blackTextStyle(18.0)),
                  ],
                ),
              ),
              // Location row
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.blue, size: 16),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        location,
                        style: AppWidget.blackTextStyle(16.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
