import 'package:codecard/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:codecard/pages/dashboard_page.dart';

class LeftSideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      decoration: BoxDecoration(
        color: Color(0xFFFF2c293a),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Color.fromARGB(255, 141, 134, 134),
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/images/Logo.png',
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10),
          IconButton(
            icon: Icon(Icons.home_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DashboardPage()),
              );
            },
          ),
          SizedBox(height: 10),
          Spacer(),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}