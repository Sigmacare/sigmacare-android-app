import 'package:flutter/material.dart';
import 'package:sigmacare_android_app/api/_getHospitals.dart';
import 'package:sigmacare_android_app/models/hospital_model.dart';
import 'package:sigmacare_android_app/pages/servicepage/components/doctorcard.dart';
import 'package:sigmacare_android_app/pages/servicepage/components/hospitalcard.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  late Future<List<HospitalModel>> _hospitals;

  @override
  void initState() {
    super.initState();
    _hospitals = fetchHospitalDetails(); // Fetch hospital details from the API
    // Debugging message
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final String hospitalName = "Amrita Hospital";
    final String doctorName = "Sigma Madhav";
    final DateTime appointmentDate = DateTime(2025, 2, 31);

    final currentDate = DateTime.now();
    final daysRemaining = appointmentDate.difference(currentDate).inDays;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Latest appointment details
            Container(
              width: screenWidth,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.event, color: Colors.blue, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Next Appointment:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blue, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Date: ${appointmentDate.toLocal().toString().split(' ')[0]}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.local_hospital, color: Colors.blue, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Hospital: $hospitalName',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.blue, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Doctor: Dr. $doctorName',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.green, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        '$daysRemaining days remaining',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Handle Details action
                      print('Show appointment details');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Details',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Search Bar with Filters
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for services...',
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: PopupMenuButton<String>(
                    onSelected: (value) {
                      // Handle filter selection
                      print('Selected filter: $value');
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem(
                            value: 'Government', child: Text('Government')),
                        const PopupMenuItem(
                            value: 'Private', child: Text('Private')),
                        const PopupMenuItem(
                            value: 'Cardiology', child: Text('Cardiology')),
                      ];
                    },
                    icon: const Icon(Icons.filter_list),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Hospitals Container - Using FutureBuilder to display hospitals
            Container(
              height: screenHeight * 0.4 - 20, // 20% of screen height
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nearby Hospitals',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: FutureBuilder<List<HospitalModel>>(
                      future: _hospitals,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No hospitals available.'));
                        } else {
                          final hospitals = snapshot.data!;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: hospitals.length,
                            itemBuilder: (context, index) {
                              final hospital = hospitals[index];

                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: HospitalCard(
                                  name: hospital.hospitalName,
                                  location: hospital.hospitalCity,
                                  image: hospital.hospitalImage
                                      .toString(), // Ensure your model has this property
                                  rating: double.parse(hospital.hospitalRating),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      // Handle "View All" action
                      print('View All Hospitals');
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
