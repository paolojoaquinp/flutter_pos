import 'package:flutter/material.dart';
import 'package:flutter_pos/features/home_screen/presentation/widgets/stats_card_widget.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  // Define the highlighted spot index
  final List<FlSpot> mainLineSpots = [
    const FlSpot(0, 1),
    const FlSpot(0.5, 1.5),
    const FlSpot(1, 3),  // Higher peak
    const FlSpot(1.5, 2), 
    const FlSpot(2, 2.5),
    const FlSpot(2.5, 3), // Small peak
    const FlSpot(3, 2.5),
    const FlSpot(3.5, 3),
    const FlSpot(4.2, 2.5), 
    const FlSpot(4.8, 8), // Main peak (right side highlighted point)
    const FlSpot(5.5, 4),
    const FlSpot(6, 3),
  ];

  // Secondary line data
  final List<FlSpot> secondaryLineSpots = [
    const FlSpot(0, 0.5),
    const FlSpot(0.5, 1),
    const FlSpot(1, 2),
    const FlSpot(1.5, 1.5),
    const FlSpot(2, 2),
    const FlSpot(2.5, 2.5),
    const FlSpot(3, 2),
    const FlSpot(3.5, 2.5),
    const FlSpot(4, 2),
    const FlSpot(4.5, 3),
    const FlSpot(5, 2.5),
    const FlSpot(5.5, 2),
    const FlSpot(6, 1.5),
  ];

  // Day names
  final List<String> dayNames = ['Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa', 'Do'];
  
  // Default selected day (Friday = 4)
  int selectedDayIndex = 4;
  
  // Active tooltip position
  Offset? tooltipPosition;
  double currentValue = 8.0; // Default value for tooltip (from the highest point)
  
  // For animation
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller for chart loading animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    // Initial tooltip position for Friday (4th day)
    tooltipPosition = const Offset(4.8, 8.0);
    
    // Start animation
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Inicio',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 34,),
              // Stats Cards Row
              const SizedBox(
                height: 135,
                child: Row(
                  children: [
                    // En Venta Card
                    Expanded(
                      child: MainStatsCardWidget(
                        label: 'en Venta',
                        quantity: '3027',
                        backgroundColor: Color(0xFF1E88E5),
                      ),
                    ),
                    SizedBox(width: 16),
                    // Vendidos Card
                    Expanded(
                      child: MainStatsCardWidget(
                        backgroundColor: Color(0xFF00BCD4),
                        label: 'Vendidos',
                        quantity: '2698',
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Date selector row
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildDateButton('1D', true),
                  _buildDateButton('1M', false),
                  _buildDateButton('3M', false),
                  _buildDateButton('6M', false),
                  _buildDateButton('1A', false),
                ],
              ),

              const SizedBox(height: 24),

              // Ingresos section
              const Text(
                'Ingresos',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 8),

              // Money value with growth
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    r'$27,003.98',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '+7.6%',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF388E3C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Graph area
              Expanded(
                child: Stack(
                  children: [
                    // Chart
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return LineChart(
                            LineChartData(
                              lineTouchData: LineTouchData(
                                enabled: true,
                                touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                                  if (event is FlPanEndEvent || event is FlTapUpEvent) {
                                    if (touchResponse?.lineBarSpots != null && 
                                        touchResponse!.lineBarSpots!.isNotEmpty) {
                                      // Get closest day index
                                      final touchedSpot = touchResponse.lineBarSpots!.first;
                                      final dayIndex = (touchedSpot.x / 6 * 6).round();
                                      if (dayIndex >= 0 && dayIndex < 7) {
                                        setState(() {
                                          selectedDayIndex = dayIndex;
                                          tooltipPosition = Offset(touchedSpot.x, touchedSpot.y);
                                          currentValue = touchedSpot.y;
                                        });
                                      }
                                    }
                                  }
                                },
                                handleBuiltInTouches: false,
                              ),
                              gridData: FlGridData(
                                show: false,
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              minX: 0,
                              maxX: 6,
                              minY: 0,
                              maxY: 10,
                              lineBarsData: [
                                // Main blue line with animation
                                LineChartBarData(
                                  spots: mainLineSpots.map((spot) => 
                                    FlSpot(spot.x, spot.y * _animation.value)
                                  ).toList(),
                                  isCurved: true,
                                  color: const Color(0xFF2196F3),
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter: (spot, percent, barData, index) {
                                      if (tooltipPosition != null && 
                                          (spot.x - tooltipPosition!.dx).abs() < 0.1 &&
                                          (spot.y - tooltipPosition!.dy).abs() < 0.1) {
                                        return FlDotCirclePainter(
                                          radius: 6,
                                          color: Colors.white,
                                          strokeWidth: 3,
                                          strokeColor: const Color(0xFF2196F3),
                                        );
                                      }
                                      return FlDotCirclePainter(
                                        radius: 0,
                                        color: Colors.transparent,
                                        strokeWidth: 0,
                                        strokeColor: Colors.transparent,
                                      );
                                    },
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFF2196F3).withOpacity(0.3 * _animation.value),
                                        const Color(0xFF2196F3).withOpacity(0.05 * _animation.value),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                                // Secondary lighter line (gray) with animation
                                LineChartBarData(
                                  spots: secondaryLineSpots.map((spot) => 
                                    FlSpot(spot.x, spot.y * _animation.value)
                                  ).toList(),
                                  isCurved: true,
                                  color: Colors.grey.withOpacity(0.5),
                                  barWidth: 2,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(
                                    show: false,
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.grey.withOpacity(0.3 * _animation.value),
                                        Colors.grey.withOpacity(0.05 * _animation.value),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Custom tooltip
                    if (tooltipPosition != null)
                      Positioned(
                        top: 30,
                        right: 50,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '\$${(currentValue * 300 + 1000).toInt()}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.black87,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 25,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                      ),

                    // Days of week indicators at bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(dayNames.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDayIndex = index;
                                
                                // Find spot closest to the selected day index
                                final double x = index * 6 / 6; // Map to 0-6 range
                                
                                // Find the closest spot to this x position
                                double closestDistance = double.maxFinite;
                                FlSpot closestSpot = mainLineSpots.first;
                                
                                for (final spot in mainLineSpots) {
                                  final distance = (spot.x - x).abs();
                                  if (distance < closestDistance) {
                                    closestDistance = distance;
                                    closestSpot = spot;
                                  }
                                }
                                
                                tooltipPosition = Offset(closestSpot.x, closestSpot.y);
                                currentValue = closestSpot.y;
                              });
                            },
                            child: _buildDayIndicator(dayNames[index], index == selectedDayIndex),
                          );
                        }),
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

  Widget _buildDateButton(String text, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1976D2) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDayIndicator(String day, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2196F3).withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        day,
        style: TextStyle(
          color: isSelected ? const Color(0xFF2196F3) : Colors.black45,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
