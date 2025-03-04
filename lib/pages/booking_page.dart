import 'package:flutter/material.dart';

class BookingPage extends StatelessWidget {
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
      'specialization': 'Gastroentrologist',
      'rating': '5.7',
      'image': 'lib/assets/doctor3.jpg',
    },
    {
      'name': 'Ranjana Maheshwari',
      'location': 'Kochi, Kerala',
      'specialization': 'Mental health and behavioural sciences, psychiatry',
      'rating': '5.7',
      'image': 'lib/assets/doctor1.jpg',
    },
    {
      'name': 'Lalitha Digambhar',
      'location': 'Kochi, Kerala',
      'specialization': 'Mental health and behavioural sciences, psychiatry',
      'rating': '5.7',
      'image': 'lib/assets/doctor1.jpg',
    },
    {
      'name': 'John Doe',
      'location': 'Kochi, Kerala',
      'specialization': 'Gastroentrologist',
      'rating': '5.7',
      'image': 'lib/assets/doctor3.jpg',
    }
  ];

  BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Booking'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.filter_list),
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Doctors',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 100.0),
                    child: SlidingButton())
              ],
            ),
            Text('Consult our experts...'),
            Expanded(
              child: ListView.builder(
                itemCount: doctors.length, // Repeating the doctors
                itemBuilder: (context, index) {
                  final doctor = doctors[index % doctors.length];
                  return DoctorCard(
                    name: doctor['name']!,
                    location: doctor['location']!,
                    specialization: doctor['specialization']!,
                    rating: doctor['rating']!,
                    imagePath: doctor['image']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Appointment'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

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
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(imagePath),
        ),
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(location),
            Text(specialization, style: TextStyle(fontSize: 12)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: Colors.amber),
            Text(rating),
          ],
        ),
      ),
    );
  }
}

class SlidingButton extends StatefulWidget {
  const SlidingButton({super.key});

  @override
  _SlidingButtonState createState() => _SlidingButtonState();
}

class _SlidingButtonState extends State<SlidingButton> {
  bool isOption1Selected = true;

  void _toggleSelection() {
    setState(() {
      isOption1Selected = !isOption1Selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleSelection,
      child: Container(
        width: 160, // Fixed width
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[300], // Background color
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Sliding effect
            AnimatedAlign(
              duration: Duration(milliseconds: 200),
              alignment: isOption1Selected
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue, // Active selection color
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            // Option labels
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'Doctor',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: Text(
                  'Hospital',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
