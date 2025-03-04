import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('lib/assets/doctor3.jpg'),
              ),
              SizedBox(height: 10),
              Text(
                'John Doe',
                style: GoogleFonts.lato(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Professional Consultant',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 18),
                  Text(' 6.7', style: TextStyle(fontSize: 16)),
                  Text(' (12 Reviews)', style: TextStyle(color: Colors.grey)),
                  SizedBox(width: 10),
                  Icon(Icons.report, color: Colors.red, size: 18),
                  Text(' Complaint', style: TextStyle(color: Colors.red)),
                ],
              ),
              SizedBox(height: 20),
              _infoRow('Availability', 'Available', true),
              _infoRow('Location', 'Kochi, Kerala', false),
              _infoRow('Years of Experience', '3+ years', false),
              _infoRow('Contact Number', '+91 9876094675', false),
              _infoRow('Email Id', 'abcdefg@gmail.com', false),
              _infoRow('Languages known', 'English, Malayalam, Hindi', false),
              SizedBox(height: 20),
              _detailsSection(),
              SizedBox(height: 20),
              BookingButton(),
              SizedBox(height: 20),
              Text('Services Offered',
                  style: GoogleFonts.lato(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              HorizontalCardList(),
              SizedBox(height: 20),
              Text('Related to your search...',
                  style: GoogleFonts.lato(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _relatedDoctorsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value, bool isAvailable) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.lato(fontSize: 16)),
          Row(
            children: [
              Text(value,
                  style: GoogleFonts.lato(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              if (isAvailable)
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Icon(Icons.circle, color: Colors.green, size: 14),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailsSection() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'Personable and responsible home health aide with over 4 years of experience performing tasks for elderly patients.',
        style: GoogleFonts.lato(fontSize: 16),
      ),
    );
  }

  Widget _bookNowButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
      ),
      onPressed: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('BOOK NOW',
              style: GoogleFonts.lato(fontSize: 18, color: Colors.white)),
          SizedBox(width: 10),
          Icon(Icons.arrow_forward, color: Colors.white),
        ],
      ),
    );
  }

  Widget _relatedDoctorsList() {
    return Column(
      children: List.generate(4, (index) => _relatedDoctorTile()),
    );
  }

  Widget _relatedDoctorTile() {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/doctor.jpg'),
      ),
      title: Text('Ranjana Maheshwari',
          style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold)),
      subtitle: Text(
          'Senior Consultant \nMental health and behavioural sciences, psychiatry'),
      trailing: Icon(Icons.chat, color: Colors.teal),
    );
  }
}

class BookingButton extends StatelessWidget {
  const BookingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0), // 10px above the bottom
        child: GestureDetector(
          onTap: () {
            // Add your button action here
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade400,
                  Colors.blue.shade800,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.5),
                  blurRadius: 10.0,
                  offset: Offset(0, 5), // Shadow direction: bottom
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Book Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_sharp, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HorizontalCardList extends StatelessWidget {
  const HorizontalCardList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> serviceNames = [
      'General Gastrointestinal Consultation',
      'Dietary & Nutritional Counseling',
      'Acid Reflux & GERD Management',
      'IBS & IBD Treatment',
    ];
    final List<Color> solidColors = [
      Colors.cyan.shade300,
      Colors.cyan.shade400,
      Colors.teal.shade300,
      Colors.blue.shade300
    ];

    return SizedBox(
      height: 200, // Height of the card list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: solidColors.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              width: 130, // Width of each card
              decoration: BoxDecoration(
                color: solidColors[index], // Solid color
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: solidColors[index].withOpacity(0.5),
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Card ${serviceNames[index]}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
