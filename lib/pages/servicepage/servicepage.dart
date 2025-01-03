import 'package:flutter/material.dart';
import 'package:sigmacare_android_app/pages/servicepage/components/doctorcard.dart';
import 'package:sigmacare_android_app/pages/servicepage/components/hospitalcard.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
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
            //latest appointment details
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
                      primary: Colors.blue, // Button color
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

            // Hospitals Container
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
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        HospitalCard(
                          name: 'Hospital 1',
                          location: 'Kochi',
                          image: 'lib/assets/hospital2.jpg',
                          rating: 4.5,
                        ),
                        SizedBox(width: 10),
                        HospitalCard(
                          name: 'Hospital 2',
                          location: 'Kochi',
                          image: 'lib/assets/hospital2.jpg',
                          rating: 4.5,
                        ),
                        SizedBox(width: 10),
                        HospitalCard(
                          name: 'Hospital 1',
                          location: 'Kochi',
                          image: 'lib/assets/hospital2.jpg',
                          rating: 4.5,
                        ),
                      ],
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

            // Doctors Container (Grid)
            const Text(
              'Top Doctors',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return DoctorCard(
                  name: 'Doctor $index',
                  speciality: 'Speciality $index',
                  image: 'lib/assets/hospital2.jpg',
                  rating: '4.5',
                );
              },
            ),
            const SizedBox(height: 16),

            // "View More" Button
            GestureDetector(
              onTap: () {
                // Handle "View More Doctors" action
                print('View More Doctors');
              },
              child: const Text(
                'View More Doctors',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}