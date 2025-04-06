import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/patient_model.dart';

class PatientManagementPage extends StatefulWidget {
  const PatientManagementPage({super.key});

  @override
  State<PatientManagementPage> createState() => _PatientManagementPageState();
}

class _PatientManagementPageState extends State<PatientManagementPage> {
  final _storage = const FlutterSecureStorage();
  List<Patient> _patients = [];
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _deviceIdController = TextEditingController();
  final _medicalConditionsController = TextEditingController();
  bool _isAddingPatient = false;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _deviceIdController.dispose();
    _medicalConditionsController.dispose();
    super.dispose();
  }

  Future<void> _fetchPatients() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to view patients')),
        );
        return;
      }

      final response = await http.get(
        Uri.parse('https://sigmacare-backend.onrender.com/api/patients'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _patients = data.map((patient) => Patient.fromJson(patient)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load patients');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _addPatient() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to add patients')),
        );
        return;
      }

      final medicalConditions = _medicalConditionsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final response = await http.post(
        Uri.parse('https://sigmacare-backend.onrender.com/api/patients'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': _nameController.text,
          'age': int.parse(_ageController.text),
          'medical_conditions': medicalConditions,
          if (_deviceIdController.text.isNotEmpty)
            'device_id': _deviceIdController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patient added successfully')),
        );
        _clearForm();
        _fetchPatients();
        setState(() {
          _isAddingPatient = false;
        });
      } else {
        throw Exception('Failed to add patient');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _clearForm() {
    _nameController.clear();
    _ageController.clear();
    _deviceIdController.clear();
    _medicalConditionsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Management'),
        actions: [
          IconButton(
            icon: Icon(_isAddingPatient ? Icons.close : Icons.add),
            onPressed: () {
              setState(() {
                _isAddingPatient = !_isAddingPatient;
                if (!_isAddingPatient) {
                  _clearForm();
                }
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isAddingPatient
              ? _buildAddPatientForm()
              : _buildPatientList(),
    );
  }

  Widget _buildAddPatientForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter patient name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter patient age';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid age';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _deviceIdController,
              decoration: const InputDecoration(
                labelText: 'Device ID (Optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _medicalConditionsController,
              decoration: const InputDecoration(
                labelText: 'Medical Conditions (comma separated)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter at least one medical condition';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _addPatient,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Add Patient',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientList() {
    if (_patients.isEmpty) {
      return const Center(
        child: Text('No patients found'),
      );
    }

    return ListView.builder(
      itemCount: _patients.length,
      itemBuilder: (context, index) {
        final patient = _patients[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(
              patient.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Age: ${patient.age}'),
                Text('Medical Conditions: ${patient.medicalConditions.join(", ")}'),
                if (patient.deviceId != null)
                  Text('Device ID: ${patient.deviceId}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditDialog(patient),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _showDeleteDialog(patient),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditDialog(Patient patient) {
    _nameController.text = patient.name;
    _ageController.text = patient.age.toString();
    _deviceIdController.text = patient.deviceId ?? '';
    _medicalConditionsController.text = patient.medicalConditions.join(', ');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Patient'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter patient name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter patient age';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid age';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _deviceIdController,
                  decoration: const InputDecoration(labelText: 'Device ID'),
                ),
                TextFormField(
                  controller: _medicalConditionsController,
                  decoration: const InputDecoration(
                      labelText: 'Medical Conditions (comma separated)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter at least one medical condition';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearForm();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await _updatePatient(patient.id);
                if (mounted) {
                  Navigator.pop(context);
                  _clearForm();
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _updatePatient(String patientId) async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to update patient')),
        );
        return;
      }

      final medicalConditions = _medicalConditionsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final response = await http.put(
        Uri.parse('https://sigmacare-backend.onrender.com/api/patients/$patientId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': _nameController.text,
          'age': int.parse(_ageController.text),
          'medical_conditions': medicalConditions,
          if (_deviceIdController.text.isNotEmpty)
            'device_id': _deviceIdController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patient updated successfully')),
        );
        _fetchPatients();
      } else {
        throw Exception('Failed to update patient');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showDeleteDialog(Patient patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Patient'),
        content: Text('Are you sure you want to delete ${patient.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _deletePatient(patient.id);
              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePatient(String patientId) async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to delete patient')),
        );
        return;
      }

      final response = await http.delete(
        Uri.parse('https://sigmacare-backend.onrender.com/api/patients/$patientId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patient deleted successfully')),
        );
        _fetchPatients();
      } else {
        throw Exception('Failed to delete patient');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
} 