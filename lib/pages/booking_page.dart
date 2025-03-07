import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sigmacare_android_app/models/hospital_model.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  bool isDoctorSelected = true;

  // Dummy data for doctors remains unchanged.
  final List<Map<String, String>> doctors = [
    {
      'name': 'Ranjana Maheshwari',
      'location': 'Kochi, Kerala',
      'specialization': 'Mental health and behavioural sciences, psychiatry',
      'rating': '6.7',
      'image': 'lib/assets/doctor1.jpg',
    },
    {
      'name': 'Lalitha Digambhar',
      'location': 'Kochi, Kerala',
      'specialization': 'Mental health and behavioural sciences, psychiatry',
      'rating': '6.7',
      'image': 'lib/assets/doctor2.jpg',
    },
    {
      'name': 'John Doe',
      'location': 'Kochi, Kerala',
      'specialization': 'Gastroenterologist',
      'rating': '5.7',
      'image': 'lib/assets/doctor3.jpg',
    },
  ];

  // Fetch hospital details from your API endpoint and convert them using HospitalModel.
  Future<List<HospitalModel>> fetchHospitalDetails() async {
    const String url = 'https://sigmacare-backend.onrender.com/api/hospitals';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // Use your model's static method to convert JSON list to HospitalModel list.
        return HospitalModel.fromJsonList(data);
      } else {
        throw Exception(
            "Failed to load hospitals (status code: ${response.statusCode})");
      }
    } catch (e) {
      throw Exception("Error fetching hospitals: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Field
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.filter_list),
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Header row with title and sliding toggle button
            Row(
              children: [
                Text(
                  isDoctorSelected ? 'Doctors' : 'Hospitals',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                SlidingButton(
                  isOption1Selected: isDoctorSelected,
                  onToggle: (selected) {
                    setState(() {
                      isDoctorSelected = selected;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isDoctorSelected
                  ? 'Consult our experts...'
                  : 'Find the best hospitals...',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            // Display the list of doctors or hospitals
            Expanded(
              child: isDoctorSelected
                  ? ListView.builder(
                      itemCount: doctors.length,
                      itemBuilder: (context, index) {
                        final doctor = doctors[index];
                        return DoctorCard(
                          name: doctor['name']!,
                          location: doctor['location']!,
                          specialization: doctor['specialization']!,
                          rating: doctor['rating']!,
                          imagePath: doctor['image']!,
                        );
                      },
                    )
                  : FutureBuilder<List<HospitalModel>>(
                      future: fetchHospitalDetails(),
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
                              child: Text('No hospitals found.'));
                        }
                        final hospitalList = snapshot.data!;
                        return ListView.builder(
                          itemCount: hospitalList.length,
                          itemBuilder: (context, index) {
                            final hospital = hospitalList[index];
                            return HospitalCard(
                              name: hospital.hospitalName,
                              // Combining city and state as location.
                              location:
                                  '${hospital.hospitalCity}, ${hospital.hospitalState}',
                              // Use a default specialization if needed.
                              specialization: 'General Hospital',
                              rating: hospital.hospitalRating,
                              // Use hospitalImage; if empty, consider a placeholder.
                              imagePath: hospital.hospitalImage.isNotEmpty
                                  ? hospital.hospitalImage
                                  : 'lib/assets/hospital1.jpg',
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// DoctorCard widget remains unchanged.
class DoctorCard extends StatelessWidget {
  final String name;
  final String location;
  final String specialization;
  final String rating;
  final String imagePath;

  const DoctorCard({
    required this.name,
    required this.location,
    required this.specialization,
    required this.rating,
    required this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(imagePath),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(location),
            Text(specialization, style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.amber),
            Text(rating),
          ],
        ),
      ),
    );
  }
}

// HospitalCard widget uses fields from HospitalModel.
class HospitalCard extends StatelessWidget {
  final String name;
  final String location;
  final String specialization;
  final String rating;
  final String imagePath;

  const HospitalCard({
    required this.name,
    required this.location,
    required this.specialization,
    required this.rating,
    required this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(imagePath),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(location),
            Text(specialization, style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.amber),
            Text(rating),
          ],
        ),
      ),
    );
  }
}

// SlidingButton widget with callback support remains unchanged.
class SlidingButton extends StatefulWidget {
  final bool isOption1Selected;
  final ValueChanged<bool> onToggle;

  const SlidingButton({
    super.key,
    required this.isOption1Selected,
    required this.onToggle,
  });

  @override
  _SlidingButtonState createState() => _SlidingButtonState();
}

class _SlidingButtonState extends State<SlidingButton> {
  late bool isOption1Selected;

  @override
  void initState() {
    super.initState();
    isOption1Selected = widget.isOption1Selected;
  }

  void _toggleSelection() {
    setState(() {
      isOption1Selected = !isOption1Selected;
      widget.onToggle(isOption1Selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleSelection,
      child: Container(
        width: 160,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Animated sliding effect for the selection indicator
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: isOption1Selected
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            // Row to hold the option labels with reduced padding
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Doctor',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Hospital',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
