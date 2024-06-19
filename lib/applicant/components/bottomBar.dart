import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {

  final int index;
  final bool organization;

  const BottomBar({
    this.index = 0,
    this.organization = false
  });


  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (int tapIndex) {
        if (tapIndex == index) return;

        if (tapIndex == 0) {
          Navigator.pushReplacementNamed(context, '/applicant_home');
        } else if (tapIndex == 1) {
          // Replace using Navigator
          Navigator.pushReplacementNamed(context, '/search_filters');
        } else if (tapIndex == 2) {
          // Handle find jobs button press
          Navigator.pushReplacementNamed(context, '/job_swipe');
        } else if (tapIndex == 3) {
          // Handle chat button press
          Navigator.pushReplacementNamed(context, '/messaging');
        } else if (tapIndex == 4) {
          // Handle profile button press
          Navigator.pushReplacementNamed(context, '/applicant_profile');
        }
      },
      backgroundColor: Colors.black,
      fixedColor: Colors.green,
      unselectedItemColor: Colors.grey,
      currentIndex: index,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Find Jobs',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ],
    );
  }
}