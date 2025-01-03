import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Dummy data
  final String lastDiagnosticDate = "2025-01-01";
  final String bodyStatus = "Running";
  final String location = "123 Main St, Springfield";
  final String batteryStatus = "85%";

  // Function to handle button presses (like diagnostic, details, etc.)
  void _onButtonPress(String buttonName) {
    print("Button pressed: $buttonName");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heart Health Details Card
            Container(
              height: 230,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Heart Image
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 40,
                    height: 210,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      'lib/assets/heart_image.png',
                      fit: BoxFit.cover, // Ensures the image fits the container
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Heart Health Details
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.sizeOf(context).width / 2 - 40,
                    height: 210,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.favorite, color: Colors.red, size: 48),
                        const Text(
                          'Heart Health Details',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Last Diagnostic Date: $lastDiagnosticDate',
                          style: const TextStyle(
                              fontSize: 8, fontWeight: FontWeight.normal),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => _onButtonPress("Diagnostic"),
                          style: ElevatedButton.styleFrom(
                            minimumSize:
                                Size(60, 30), // Width and height of the button
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4), // Inner padding
                            textStyle:
                                const TextStyle(fontSize: 8), // Text font size
                          ),
                          child: const Text('Diagnostic'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Status and Location Cards in a Row (Square Shape)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Status Card
                Container(
                  width: MediaQuery.of(context).size.width / 2 -
                      30.0, // Ensures the card is square
                  height: 200, // Square height
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.directions_run,
                          color: Colors.blue, size: 36), // Status Icon
                      const SizedBox(height: 8),
                      Text(
                        'Current Status: $bodyStatus',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _onButtonPress("Details"),
                        child: const Text('Details'),
                      ),
                    ],
                  ),
                ),

                // Location Card
                Container(
                  width: MediaQuery.of(context).size.width / 2 -
                      30.0, // Ensures the card is square
                  height: 200, // Square height
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on,
                          color: Colors.green, size: 36), // Location Icon
                      const SizedBox(height: 8),
                      Text(
                        'Location: $location',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _onButtonPress("Customize"),
                        child: const Text('Customize'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Battery Tile (More Beautiful)
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                title: const Text('SimaCare Band1',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Connected',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.battery_charging_full,
                              color: Colors.blue, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            'Battery Status: $batteryStatus',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () => _onButtonPress("Battery Details"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
