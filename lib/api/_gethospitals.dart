import 'package:sigmacare_android_app/models/hospital_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<HospitalModel>> fetchHospitalDetails() async {
  final supabase = Supabase.instance.client;
  try {
    // Query the 'hospital' table
    final response = await supabase.from('hospital').select();
    print(response);
    // Extract the data from the response
    // Extract the data from the response
    final data = response as List<dynamic>;
    // Convert the list of data into a list of HospitalModel instances
    List<HospitalModel> hospitals = HospitalModel.fromJsonList(data);
    return hospitals;
  } catch (e) {
    return [];
  }
}
