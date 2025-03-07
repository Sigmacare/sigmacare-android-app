import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sigmacare_android_app/pages/homepage/homepage.dart';
import 'package:sigmacare_android_app/pages/booking_page.dart';
import 'package:sigmacare_android_app/pages/user-registration/registrationpage.dart';
import 'package:sigmacare_android_app/api/_registerDevice.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    BookingPage(), // Tapping on "Appointment" now goes to BookingPage
    const Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Settings Page', style: TextStyle(fontSize: 24))),
  ];

  final List<String> _appBarTitles = [
    'Home',
    'Appointments',
    'Profile',
    'Settings',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Logout functionality: clear the secure storage and navigate to the main page.
  Future<void> _logout() async {
    // Clear the auth token from secure storage.
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'auth_token');

    // Navigate to the main page. (Assuming your AppInitializer is set up in main.dart.)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const RegistrationPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]),
        backgroundColor: Colors.green[900],
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[900],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

void _showAddDeviceDialog(BuildContext context) {
  final deviceCodeController = TextEditingController();
  final deviceSecretController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Add Device"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: deviceCodeController,
              decoration: const InputDecoration(labelText: "Device Code"),
            ),
            TextField(
              controller: deviceSecretController,
              decoration: const InputDecoration(labelText: "Device Secret"),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              registerDevice(
                deviceCodeController.text,
                deviceSecretController.text,
                context,
              );
            },
            child: const Text("Register"),
          ),
        ],
      );
    },
  );
}
