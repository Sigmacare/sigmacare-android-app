import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sigmacare_android_app/models/hospital_model.dart';

Future<List<HospitalModel>> fetchHospitalDetails() async {
  const String url = 'https://sigmacare-backend.onrender.com/api/hospitals';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      // Convert the JSON list into a list of HospitalModel instances.
      List<HospitalModel> hospitals = HospitalModel.fromJsonList(data);
      print(hospitals);
      return hospitals;
    } else {
      print('Error fetching hospitals: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Exception fetching hospitals: $e');
    return [];
  }
}
