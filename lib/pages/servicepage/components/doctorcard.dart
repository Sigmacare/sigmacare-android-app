import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  final String? name;
  final String? speciality;
  final String? image;
  final String? rating;
  const DoctorCard(
      {super.key, this.name, this.speciality, this.image, this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: 150, // Set width to 150 pixels
      height: 150, // Set height to 150 pixels
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(4, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              image ?? 'assets/images/doctor.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Display the doctor's name and speciality
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? 'Unknown Doctor',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    speciality ?? 'Unknown Speciality',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),

              Column(
                children: [
                  Icon(Icons.star, color: Colors.yellow[700], size: 16),
                  Text(
                    rating ?? '0.0',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
