import 'package:flutter/material.dart';
import 'package:hotel_booking/Services/widget_suppiler.dart';
import 'package:hotel_booking/Services/buildHotelCard.dart'; 
import 'package:hotel_booking/Services/new_place.dart'; 
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(150, 255, 255, 255),
      body: SingleChildScrollView( // ✅ Enables vertical scrolling
        child: Column(
          children: [
            // ===========================
            // ✅ HEADER SECTION WITH IMAGE + OVERLAY
            // ===========================
            Stack(
              children: [
                // Background Image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    "images/homepage.png",
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    height: 220,
                  ),
                ),

                // Dark Overlay with Text & Search
                Container(
                  padding: const EdgeInsets.only(top: 40.0, left: 20.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(97, 0, 0, 0),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.blue),
                          const SizedBox(width: 10.0),
                          Text("Adama, Oromia", style: AppWidget.whiteTextStyle(20.0)),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Text('Where are you going next?', style: AppWidget.whiteTextStyle(25.0)),
                      const SizedBox(height: 20.0),

                      // ✅ Search Bar
                      Container(
                        margin: const EdgeInsets.only(right: 20.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(74, 177, 175, 175),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.search, color: Colors.white),
                            hintText: 'Search for hotels, cities, etc',
                            hintStyle: AppWidget.whiteTextStyle(20.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ===========================
            // ✅ POPULAR DESTINATIONS TITLE
            // ===========================
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text("Popular Destinations", style: AppWidget.headlineTextStyle(22.0)),
            ),
            const SizedBox(height: 20),

            // ===========================
            // ✅ HORIZONTAL SCROLLABLE HOTEL CARDS
            // ===========================
            SizedBox(
              height: 250,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 20.0), // ✅ Only one left padding
                children: [
                  HotelCard(
  image: "images/hotel2.png",
  title: "Adama, Hotel Beach",
  price: "\$10",
  location: "Adama, main road",
),
const SizedBox(width: 15),
HotelCard(
  image: "images/hotel3.png",
  title: "Addis Ababa, Hotel Beach",
  price: "\$50",
  location: "Addis Ababa, main road",
),
const SizedBox(width: 15),
HotelCard(
  image: "images/hotel4.png",
  title: "Jimma , Hotel Beach",
  price: "\$20",
  location: "Jimma, main road",
),

                ],
              ),
            ),

        SizedBox(height: 20),
            Padding(

              padding: const EdgeInsets.only(left:2.0),

              child: Text('Discover new Places', style: AppWidget.headlineTextStyle(22.0)),
            ),

            const SizedBox(height: 20),


SizedBox(
  height: 250, 
  child: ListView(
    scrollDirection: Axis.horizontal,
    physics: const BouncingScrollPhysics(),
    children: [
      buildSmallPlaceCard("images/bali.jpg", "Bale", "10 Hotels"),
      buildSmallPlaceCard("images/AA.png", "Addis Ababa", "30 Hotels"),
      buildSmallPlaceCard("images/hawass.png", "Hawass", "12 Hotels"),
    ],
  ),
),

 const SizedBox(height: 30)
          ],
        ),
      ),
    );
  }

  
}
