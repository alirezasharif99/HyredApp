import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {

  final int index;

  const BottomBar({
    this.index = 0,
  });


  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (int tapIndex) {
        if (tapIndex == index) return;
        
        if (tapIndex == 0) {
          Navigator.pushReplacementNamed(context, '/organization_home');
        } else if (tapIndex == 1) {
          Navigator.pushReplacementNamed(context, '/organization_swipe');
        } else if (tapIndex == 2) {
          // Handle chat button press
          Navigator.pushReplacementNamed(context, '/organization_messaging');
        }
      },
      backgroundColor: Colors.white,
      fixedColor: Colors.green,
      unselectedItemColor: Colors.grey,
      currentIndex: index,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Find Applicants',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Chat',
        ),
      ],
    );
  }
}