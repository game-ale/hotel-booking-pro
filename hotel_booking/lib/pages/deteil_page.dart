import 'package:flutter/material.dart';
import 'package:hotel_booking/Services/widget_suppiler.dart';

// 🏨 DetailPage: shows full info of a hotel (image, offers, booking form)
class DetailPage extends StatefulWidget {
  final String image;    // Hotel image path
  final String title;    // Hotel name/title
  final String price;    // Hotel price (e.g. "$10")
  final String location; // Hotel location string

  const DetailPage({
    Key? key,
    required this.image,
    required this.title,
    required this.price,
    required this.location,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // --- Booking state ---
  DateTime? _checkIn;    // Selected check-in date
  DateTime? _checkOut;   // Selected check-out date
  int _guests = 1;       // Number of guests

  // --- Helpers to calculate nights & price ---
  double get _perNight {
    // Extract number from widget.price (removes "$")
    final cleaned = widget.price.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  int get _nights {
    // If both dates chosen and valid, calculate difference in days
    if (_checkIn != null && _checkOut != null && _checkOut!.isAfter(_checkIn!)) {
      return _checkOut!.difference(_checkIn!).inDays;
    }
    return 1; // Default minimum 1 night
  }

  double get _totalPrice => _perNight * _nights;

  // Format DateTime → readable string
  String _formatDate(DateTime? dt) {
    if (dt == null) return 'Select';
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${dt.day.toString().padLeft(2, '0')}, ${months[dt.month - 1]} ${dt.year}';
  }

  // Date picker dialog
  Future<void> _pickDate({required bool isCheckIn}) async {
    final initial = isCheckIn ? (_checkIn ?? DateTime.now()) : (_checkOut ?? DateTime.now().add(const Duration(days: 1)));
    final firstDate = DateTime.now();
    final lastDate = DateTime.now().add(const Duration(days: 365));

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkIn = picked;
          if (_checkOut != null && !_checkOut!.isAfter(_checkIn!)) {
            _checkOut = _checkIn!.add(const Duration(days: 1));
          }
        } else {
          _checkOut = picked;
          if (_checkIn != null && !_checkOut!.isAfter(_checkIn!)) {
            _checkOut = _checkIn!.add(const Duration(days: 1));
          }
        }
      });
    }
  }

  // Row for hotel features (wifi, tv, etc.)
  Widget _featureRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 8),
        Text(text, style: AppWidget.blackTextStyle(16.0)),
      ],
    );
  }

  // Book Now button action (currently placeholder)
  void _onBookNow() {
    if (_checkIn == null || _checkOut == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select check-in and check-out dates.')),
      );
      return;
    }

    // Shows a confirmation popup (later connect to Firebase/backend)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: Text(
          '${widget.title}\n'
          '$_nights night(s) • $_guests guest(s)\n'
          'Total: \$${_totalPrice.toStringAsFixed(2)}',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking flow is a placeholder — implement backend next.')),
              );
            },
            child: const Text('Confirm'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView( // makes page scrollable
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Top image with back button ---
              Stack(
                children: [
                  Hero( // Smooth transition animation from HotelCard
                    tag: widget.image,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                      child: Image.asset(
                        widget.image,
                        height: 260,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    top: 12,
                    child: CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black87),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // --- Title + Price ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(child: Text(widget.title, style: AppWidget.headlineTextStyle(18.0))),
                    Text(widget.price, style: AppWidget.blackTextStyle(18.0)),
                  ],
                ),
              ),

              // --- Location ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.blue, size: 16),
                    const SizedBox(width: 6),
                    Expanded(child: Text(widget.location, style: AppWidget.blackTextStyle(14.0))),
                  ],
                ),
              ),

              const Divider(),

              // --- What this place offers ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('What this place offers', style: AppWidget.headlineTextStyle(16.0)),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _featureRow(Icons.wifi, 'WiFi'),
                    _featureRow(Icons.tv, 'HDTV'),
                    _featureRow(Icons.kitchen, 'Kitchen'),
                    _featureRow(Icons.bathtub, 'Bathroom'),
                  ],
                ),
              ),

              const Divider(),

              // --- About section ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('About this place', style: AppWidget.headlineTextStyle(16.0)),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Lorem Ipsum is simply dummy text ... Replace with backend description',
                  style: AppWidget.blackTextStyle(14.0),
                ),
              ),

              // --- Booking card ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        // Price summary
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('\$${_totalPrice.toStringAsFixed(0)} for $_nights nights',
                                style: AppWidget.headlineTextStyle(16.0)),
                            Text(widget.price + ' / night', style: AppWidget.blackTextStyle(14.0)),
                          ],
                        ),

                        // Check-in / Check-out date pickers
                        ListTile(
                          leading: const Icon(Icons.calendar_today, color: Colors.blue),
                          title: const Text('Check-in Date'),
                          subtitle: Text(_formatDate(_checkIn)),
                          onTap: () => _pickDate(isCheckIn: true),
                        ),
                        ListTile(
                          leading: const Icon(Icons.calendar_today, color: Colors.blue),
                          title: const Text('Check-out Date'),
                          subtitle: Text(_formatDate(_checkOut)),
                          onTap: () => _pickDate(isCheckIn: false),
                        ),

                        // Guests selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.person, color: Colors.blue),
                            const Text('Number of Guests'),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => setState(() {
                                    if (_guests > 1) _guests--;
                                  }),
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                Text('$_guests', style: AppWidget.headlineTextStyle(16.0)),
                                IconButton(
                                  onPressed: () => setState(() {
                                    _guests++;
                                  }),
                                  icon: const Icon(Icons.add_circle_outline),
                                ),
                              ],
                            )
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Book Now button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _onBookNow,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14.0),
                              child: Text('Book Now'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),
            ],
          ),
        ),
      ),
    );
  }
}
