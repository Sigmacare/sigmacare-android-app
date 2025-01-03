import 'package:flutter/material.dart';

class HospitalCard extends StatefulWidget {
  final String? name;
  final String? location;
  final String? image;
  final double? rating;

  const HospitalCard(
      {super.key, this.name, this.location, this.image, this.rating});

  @override
  State<HospitalCard> createState() => _HospitalCardState();
}

class _HospitalCardState extends State<HospitalCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      //margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFA5D6A7),
            blurRadius: 8,
            offset: Offset(4, 4),
          ),
        ],
        color: Colors.white, // Background color to enhance visibility
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: widget.image != null
                ? Image.network(
                    widget.image!,
                    width: 180,
                    height: 120,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null
                                  : null),
                        );
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 180,
                        height: 120,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  )
                : Container(
                    width: 180,
                    height: 120,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.name ?? 'Unknown Hospital',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.location ?? 'location-unknown', // Static location for now
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 18,
                ),
                Text(
                  widget.rating != null ? '${widget.rating}' : 'N/A',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.location_on,
                  color: Colors.grey,
                  size: 18,
                ),
                const Text(
                  '2.5 km', // Static distance for now
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
