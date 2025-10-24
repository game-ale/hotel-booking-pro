import 'package:flutter/material.dart';
import '../Services/auth_service.dart';
import 'login.dart';

class ProfilePage extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Custom Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Profile",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () async {
                  await _authService.logout();

                  // ✅ Clear BottomNav and go back to LoginPage
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        ),

        // Profile Content
        const Expanded(
          child: Center(
            child: Text("User Profile Info Here"),
          ),
        ),
      ],
    );
  }
}
