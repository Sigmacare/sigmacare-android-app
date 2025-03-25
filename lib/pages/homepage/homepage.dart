import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sigmacare_android_app/models/sensor_data.dart';
import 'dart:async';
import 'dart:math';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Patient data
  String lastDiagnosticDate = "2025-03-21";
  String bodyStatus = "Walking";
  String location = "123 Main St, Springfield";
  String batteryStatus = "85%";

  // Vitals
  int heartRate = 78;
  int oxygenLevel = 98;
  String motionStatus = "Walking";

  // Battery level
  double batteryLevel = 0.85;

  // WebSocket variables
  WebSocketChannel? _channel;

  @override
  void initState() {
    super.initState();
    _initWebSocket();
  }

  /// Initialize WebSocket connection and handle errors.
  void _initWebSocket() {
    try {
      // Replace with your actual WebSocket server URL
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://172.20.10.3:8080'),
      );
      //send message to subscribe

      // Send message to subscribe
      final subscriptionMessage = jsonEncode({
        'type': 'subscribe',
        'device_id': '1', // Replace with actual device_id
      });
      _channel!.sink.add(subscriptionMessage);

      _channel!.stream.listen(
        (message) {
          //Parse json message
          final data = jsonDecode(message);
          print(data["heartRate"]);
          final sensorData = SensorData.fromJson(data);
          setState(() {
            heartRate = sensorData.heartRate;
            oxygenLevel = sensorData.oxygen;
            motionStatus = sensorData.accelX > 0.5 ? "Running" : "Walking";
          });
        },
      );
    } catch (e) {
      setState(() {
        print(e);
      });
    }
  }

  /// Cleanly close the WebSocket connection.
  void _closeWebSocket() {
    _channel?.sink.close(status.normalClosure);
    _channel = null;
  }

  /// Retry the connection.
  void _retryConnection() {
    _closeWebSocket();
    _initWebSocket();
  }

  // Function to handle button presses in UI.
  void _onButtonPress(String buttonName) {
    print("Button pressed: $buttonName");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$buttonName view requested")),
    );
  }

  @override
  void dispose() {
    _closeWebSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Monitor'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Heart Health Card
              _buildHealthCard(
                title: "Cardiac Monitor",
                icon: Icons.favorite,
                iconColor: Colors.red,
                bgColor: Colors.red[50]!,
                value: "$heartRate BPM",
                subtitle: "Heart Rate",
                details: "Last updated: Just now",
                onViewDetails: () => _onButtonPress("Heart Rate Details"),
                chart: _buildHeartRateChart(),
              ),
              const SizedBox(height: 16),
              // Oxygen Level Card
              _buildHealthCard(
                title: "Oxygen Saturation",
                icon: Icons.air,
                iconColor: Colors.blue,
                bgColor: Colors.blue[50]!,
                value: "$oxygenLevel%",
                subtitle: "SpO₂",
                details: "Normal range: 95-100%",
                onViewDetails: () => _onButtonPress("Oxygen Level Details"),
                chart: _buildOxygenLevelChart(),
              ),
              const SizedBox(height: 16),
              // Status and Location Cards in a Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusCard(
                    title: "Motion Status",
                    icon: _getMotionIcon(motionStatus),
                    value: motionStatus,
                    bgColor: Colors.green[50]!,
                    iconColor: Colors.green,
                    onViewDetails: () => _onButtonPress("Motion Details"),
                  ),
                  _buildStatusCard(
                    title: "Location",
                    icon: Icons.location_on,
                    value: location,
                    bgColor: Colors.amber[50]!,
                    iconColor: Colors.amber,
                    onViewDetails: () => _onButtonPress("Location Details"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Battery and Device Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.watch,
                        color: Colors.teal,
                        size: 36,
                      ),
                      title: const Text(
                        'SimaCare Band1',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text(
                        'Connected',
                        style: TextStyle(fontSize: 14, color: Colors.green),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () => _onButtonPress("Device Settings"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _getBatteryIcon(batteryLevel),
                              const SizedBox(width: 8),
                              Text(
                                'Battery: $batteryStatus',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: batteryLevel,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getBatteryColor(batteryLevel),
                            ),
                            minHeight: 10,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlinedButton.icon(
                                icon: const Icon(Icons.refresh),
                                label: const Text('Sync Data'),
                                onPressed: () =>
                                    _onButtonPress("Sync Device Data"),
                              ),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.info_outline),
                                label: const Text('Device Info'),
                                onPressed: () =>
                                    _onButtonPress("Device Information"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Diagnostic Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.health_and_safety),
                  label: const Text('Run Full Diagnostic'),
                  onPressed: () => _onButtonPress("Full Diagnostic"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for health cards (heart rate, oxygen saturation)
  Widget _buildHealthCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String value,
    required String subtitle,
    required String details,
    required VoidCallback onViewDetails,
    required Widget chart,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 32),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      details,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: chart,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: iconColor,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: onViewDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: iconColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('View Details'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget for status cards (motion, location)
  Widget _buildStatusCard({
    required String title,
    required IconData icon,
    required String value,
    required Color bgColor,
    required Color iconColor,
    required VoidCallback onViewDetails,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 24,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 40),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onViewDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: iconColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Details'),
            ),
          ),
        ],
      ),
    );
  }

  // Get appropriate motion icon based on status.
  IconData _getMotionIcon(String status) {
    switch (status.toLowerCase()) {
      case 'walking':
        return Icons.directions_walk;
      case 'running':
        return Icons.directions_run;
      case 'standing':
        return Icons.accessibility_new;
      case 'sitting':
        return Icons.chair;
      case 'sleeping':
        return Icons.hotel;
      default:
        return Icons.accessibility;
    }
  }

  // Get appropriate battery icon based on level.
  Widget _getBatteryIcon(double level) {
    IconData icon;
    if (level > 0.8) {
      icon = Icons.battery_full;
    } else if (level > 0.6) {
      icon = Icons.battery_6_bar;
    } else if (level > 0.4) {
      icon = Icons.battery_4_bar;
    } else if (level > 0.2) {
      icon = Icons.battery_2_bar;
    } else {
      icon = Icons.battery_alert;
    }
    return Icon(
      icon,
      color: _getBatteryColor(level),
      size: 24,
    );
  }

  // Get appropriate battery color based on level.
  Color _getBatteryColor(double level) {
    if (level > 0.5) {
      return Colors.green;
    } else if (level > 0.2) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  // Simple heart rate chart visualization.
  Widget _buildHeartRateChart() {
    return Container(
      height: 80,
      padding: const EdgeInsets.only(top: 8),
      child: CustomPaint(
        size: const Size(double.infinity, 80),
        painter: HeartRateChartPainter(heartRate: heartRate),
      ),
    );
  }

  // Simple oxygen level chart visualization.
  Widget _buildOxygenLevelChart() {
    return Container(
      height: 80,
      padding: const EdgeInsets.only(top: 8),
      child: CustomPaint(
        size: const Size(double.infinity, 80),
        painter: OxygenLevelChartPainter(oxygenLevel: oxygenLevel),
      ),
    );
  }
}

// Custom painter for heart rate chart.
class HeartRateChartPainter extends CustomPainter {
  final int heartRate;
  HeartRateChartPainter({required this.heartRate});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final amplitude = 20.0;
    final frequency = 0.05 + (heartRate - 60) / 200;
    path.moveTo(0, size.height / 2);

    for (double x = 0; x < size.width; x++) {
      final random = Random().nextDouble() * 4 - 2;
      final spikeX = (x / size.width * 10).floor();
      final spike =
          spikeX % 2 == 0 && (x % (size.width / 10) < 10) ? 15.0 : 0.0;
      final y =
          size.height / 2 + sin(x * frequency) * amplitude + spike + random;
      path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom painter for oxygen level chart.
class OxygenLevelChartPainter extends CustomPainter {
  final int oxygenLevel;
  OxygenLevelChartPainter({required this.oxygenLevel});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final baseHeight = size.height - (oxygenLevel - 90) * (size.height / 10);
    path.moveTo(0, baseHeight);

    for (double x = 0; x < size.width; x++) {
      final random = Random().nextDouble() * 2 - 1;
      final y = baseHeight + sin(x * 0.02) * 5 + random;
      path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);

    final normalRangePaint = Paint()
      ..color = Colors.green.withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final normalRange = Path();
    normalRange.moveTo(0, size.height * 0.2);
    normalRange.lineTo(size.width, size.height * 0.2);
    canvas.drawPath(normalRange, normalRangePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
