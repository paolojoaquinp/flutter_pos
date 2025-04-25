import 'package:flutter/material.dart';

class NavBarItem extends StatelessWidget {
  final Widget icon;
  final bool isSelected; 
  final VoidCallback onTap;

  const NavBarItem({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Color(0xFF369F6B),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}