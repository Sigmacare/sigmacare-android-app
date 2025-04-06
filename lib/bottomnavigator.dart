import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sigmacare_android_app/pages/homepage/homepage.dart';
import 'package:sigmacare_android_app/pages/booking_page.dart';
import 'package:sigmacare_android_app/pages/servicepage/servicepage.dart';
import 'package:sigmacare_android_app/pages/profile_page.dart';
import 'package:sigmacare_android_app/pages/patient_management_page.dart';
import 'package:sigmacare_android_app/api/_registerDevice.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _selectedIndex = 0;
  final _storage = const FlutterSecureStorage();

  final List<Widget> _pages = [
    const HomePage(),
    const ServicePage(),
    const BookingPage(),
    const PatientManagementPage(),
    const ProfilePage(),
  ];

  final List<String> _appBarTitles = [
    'Home',
    'Services',
    'Book Appointment',
    'Patients',
    'Profile',
  ];

  Future<void> _logout() async {
    await _storage.delete(key: 'auth_token');
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]),
        backgroundColor: Colors.blue[700],
      ),
      body: _pages[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // User Account Section
            UserAccountsDrawerHeader(
              accountName: const Text('User Name'),
              accountEmail: const Text('user@example.com'),
              currentAccountPicture: CircleAvatar(
                radius: 40.0,
                backgroundImage: NetworkImage(
                  'https://www.example.com/path/to/avatar.jpg', // Replace with your image URL
                ),
                backgroundColor: Colors.transparent,
              ),
              decoration: BoxDecoration(
                color: Colors.green[900],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add_circle),
              title: const Text('Add Devices',
                  style: TextStyle(color: Colors.black)),
              onTap: () => _showAddDeviceDialog(context),
            ),
            // Logout Button
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: _logout,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue[700],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Book',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Patients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _showAddDeviceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Device'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Device Code',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Device Secret',
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle device registration
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
