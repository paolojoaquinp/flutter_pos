import 'package:flutter/material.dart';

class MainStatsCardWidget extends StatelessWidget {
  final String label;
  final String quantity;
  final Color backgroundColor;

  const MainStatsCardWidget({
    super.key,
    required this.label,
    required this.quantity,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pie chart icon
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pie_chart,
              color: Colors.white,
              size: 16,
            ),
          ),
          const Spacer(),
          // Value
          Text(
            quantity,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          // Label
          Text(
            label,
            style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
