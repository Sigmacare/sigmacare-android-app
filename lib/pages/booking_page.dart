import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sigmacare_android_app/models/hospital_model.dart';
import 'package:sigmacare_android_app/models/doctor_model.dart';
import 'package:sigmacare_android_app/models/patient_model.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _storage = const FlutterSecureStorage();
  List<HospitalModel> hospitals = [];
  List<Doctor> doctors = [];
  List<Patient> patients = [];
  bool isLoading = true;
  String? selectedHospitalId;
  String? selectedDoctorId;
  String? selectedPatientId;
  DateTime? selectedDate;
  bool showCalendar = false;
  String? _token;

  @override
  void initState() {
    super.initState();
    _fetchTokenAndData();
  }

  Future<void> _fetchTokenAndData() async {
    try {
      _token = await _storage.read(key: 'auth_token');
      if (_token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to book appointments')),
        );
        return;
      }
      await Future.wait([
        _fetchHospitals(),
        _fetchPatients(),
      ]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  Future<void> _fetchHospitals() async {
    try {
      setState(() => isLoading = true);
      const String url = 'https://sigmacare-backend.onrender.com/api/hospitals';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          hospitals = HospitalModel.fromJsonList(data);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load hospitals');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _fetchDoctors(String hospitalId) async {
    try {
      setState(() => isLoading = true);
      final response = await http.get(
        Uri.parse(
            'https://sigmacare-backend.onrender.com/api/hospitals/$hospitalId/doctors'),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          doctors = data.map((doctor) => Doctor.fromJson(doctor)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load doctors');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _fetchPatients() async {
    try {
      final response = await http.get(
        Uri.parse('https://sigmacare-backend.onrender.com/api/patients'),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          patients = data.map((patient) => Patient.fromJson(patient)).toList();
        });
      } else {
        throw Exception('Failed to load patients');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching patients: $e')),
      );
    }
  }

  Future<void> _bookAppointment() async {
    if (_token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to book appointments')),
      );
      return;
    }

    if (selectedHospitalId == null ||
        selectedDoctorId == null ||
        selectedDate == null ||
        selectedPatientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select hospital, doctor, patient and date')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://sigmacare-backend.onrender.com/api/appointment'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'hospitalId': selectedHospitalId,
          'doctorId': selectedDoctorId,
          'patientId': selectedPatientId,
          'date': selectedDate!.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment booked successfully')),
        );
        // Reset selections
        setState(() {
          selectedHospitalId = null;
          selectedDoctorId = null;
          selectedPatientId = null;
          selectedDate = null;
          showCalendar = false;
        });
      } else {
        throw Exception('Failed to book appointment');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        leading: selectedHospitalId != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selectedHospitalId = null;
                    doctors = [];
                  });
                },
              )
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Field
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (selectedHospitalId == null) ...[
              const Text(
                'Select a Hospital',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: hospitals.length,
                        itemBuilder: (context, index) {
                          final hospital = hospitals[index];
                          return HospitalCard(
                            hospitalId: hospital.hospitalId,
                            name: hospital.hospitalName,
                            location:
                                '${hospital.hospitalCity}, ${hospital.hospitalState}',
                            specialization: 'General Hospital',
                            rating: hospital.hospitalRating,
                            imagePath: hospital.hospitalImage.isNotEmpty
                                ? hospital.hospitalImage
                                : 'lib/assets/hospital_placeholder.jpg',
                            onTap: () {
                              setState(() {
                                selectedHospitalId = hospital.hospitalId;
                              });
                              _fetchDoctors(hospital.hospitalId);
                            },
                          );
                        },
                      ),
              ),
            ] else if (selectedDoctorId == null) ...[
              const Text(
                'Select a Doctor',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: doctors.length,
                        itemBuilder: (context, index) {
                          final doctor = doctors[index];
                          return DoctorCard(
                            name: doctor.name,
                            location: '${doctor.experience} years experience',
                            specialization: 'General Practitioner',
                            rating: '4.5',
                            imagePath: 'lib/assets/doctor_placeholder.jpg',
                            isSelected: selectedDoctorId == doctor.id,
                            onTap: () {
                              setState(() {
                                selectedDoctorId = doctor.id;
                              });
                            },
                          );
                        },
                      ),
              ),
            ] else if (selectedPatientId == null) ...[
              const Text(
                'Select a Patient',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: patients.isEmpty
                    ? const Center(child: Text('No patients found'))
                    : ListView.builder(
                        itemCount: patients.length,
                        itemBuilder: (context, index) {
                          final patient = patients[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            color: selectedPatientId == patient.id
                                ? Colors.blue.shade50
                                : null,
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  selectedPatientId = patient.id;
                                  showCalendar = true;
                                });
                              },
                              title: Text(
                                patient.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Age: ${patient.age}'),
                                  Text(
                                      'Medical Conditions: ${patient.medicalConditions.join(", ")}'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ] else if (showCalendar) ...[
              const Text(
                'Select Date',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: selectedDate ?? DateTime.now(),
                selectedDayPredicate: (day) {
                  return isSameDay(selectedDate, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    selectedDate = selectedDay;
                  });
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _bookAppointment,
                  child: const Text('Book Appointment'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class HospitalCard extends StatelessWidget {
  final String hospitalId;
  final String name;
  final String location;
  final String specialization;
  final String rating;
  final String imagePath;
  final VoidCallback onTap;

  const HospitalCard({
    required this.hospitalId,
    required this.name,
    required this.location,
    required this.specialization,
    required this.rating,
    required this.imagePath,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: onTap,
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

class DoctorCard extends StatelessWidget {
  final String name;
  final String location;
  final String specialization;
  final String rating;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const DoctorCard({
    required this.name,
    required this.location,
    required this.specialization,
    required this.rating,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: isSelected ? Colors.blue.shade50 : null,
      child: ListTile(
        onTap: onTap,
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
