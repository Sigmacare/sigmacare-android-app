import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/doctor_model.dart';

class HospitalDetailsPage extends StatefulWidget {
  final String hospitalId;

  const HospitalDetailsPage({
    Key? key,
    required this.hospitalId,
  }) : super(key: key);

  @override
  State<HospitalDetailsPage> createState() => _HospitalDetailsPageState();
}

class _HospitalDetailsPageState extends State<HospitalDetailsPage> {
  bool _isLoading = true;
  String? _error;
  String _hospitalName = '';
  List<Doctor> doctors = [];

  @override
  void initState() {
    super.initState();
    _fetchHospitalDetails();
  }

  Future<void> _fetchHospitalDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Fetch hospital details
      final hospitalResponse = await http.get(
        Uri.parse(
            'https://sigmacare-backend.onrender.com/api/hospitals/${widget.hospitalId}'),
      );

      if (hospitalResponse.statusCode == 200) {
        final hospitalData = json.decode(hospitalResponse.body);
        setState(() {
          _hospitalName = hospitalData['name'] as String;
        });
      } else {
        setState(() {
          _error = 'Failed to load hospital details';
          _isLoading = false;
        });
        return;
      }

      // Fetch doctors for this hospital
      final doctorsResponse = await http.get(
        Uri.parse(
            'https://sigmacare-backend.onrender.com/api/hospitals/${widget.hospitalId}/doctors'),
      );

      if (doctorsResponse.statusCode == 200) {
        final doctorsList = (json.decode(doctorsResponse.body) as List)
            .map((doctor) => Doctor.fromJson(doctor))
            .toList();

        setState(() {
          doctors = doctorsList;
          _isLoading = false;
        });
      } else if (doctorsResponse.statusCode == 404) {
        setState(() {
          doctors = [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load doctors';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'An error occurred while fetching data';
        _isLoading = false;
      });
    }
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _error ?? 'An error occurred',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.red,
                ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchHospitalDetails,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildDoctorsList() {
    if (doctors.isEmpty) {
      return const Center(child: Text('No doctors available at this hospital'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Text(
                    doctor.name.split(' ').map((e) => e[0]).take(2).join(''),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.work,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${doctor.experience} years experience',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            doctor.contact,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement booking functionality
                  },
                  child: const Text('Book'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_hospitalName), elevation: 0),
      body: _isLoading
          ? _buildLoadingWidget()
          : _error != null
              ? _buildErrorWidget()
              : _buildDoctorsList(),
    );
  }
}
