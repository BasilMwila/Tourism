// File: tourist_attractions.dart
// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:afrijourney/booking.dart';

class TouristAttraction {
  final String name;
  final String location;
  final String description;
  final String imagePath;
  final double rating;
  final double price;

  TouristAttraction({
    required this.name,
    required this.location,
    required this.description,
    required this.imagePath,
    required this.rating,
    required this.price,
  });
}

class AttractionsPage extends StatelessWidget {
  AttractionsPage({Key? key}) : super(key: key);

  final List<TouristAttraction> attractions = [
    TouristAttraction(
      name: 'Victoria Falls',
      location: 'Livingstone',
      description:
          'One of the Seven Natural Wonders of the World, locally known as "Mosi-oa-Tunya" (The Smoke That Thunders).',
      imagePath: 'assets/victoria_falls.jpg',
      rating: 4.9,
      price: 20.0,
    ),
    TouristAttraction(
      name: 'South Luangwa National Park',
      location: 'Eastern Province',
      description:
          'Known for its abundant wildlife and walking safaris. Home to over 400 bird species and 60 different animal species.',
      imagePath: 'assets/south_luangwa.jpg',
      rating: 4.8,
      price: 25.0,
    ),
    TouristAttraction(
      name: 'Lower Zambezi National Park',
      location: 'Southern Province',
      description:
          'Offers exceptional game viewing along the Zambezi River with canoeing and fishing experiences.',
      imagePath: 'assets/lower_zambezi.jpg',
      rating: 4.7,
      price: 25.0,
    ),
    TouristAttraction(
      name: 'Kafue National Park',
      location: 'Central Zambia',
      description:
          'Zambia\'s oldest and largest national park with diverse landscapes and wildlife.',
      imagePath: 'assets/kafue_park.jpg',
      rating: 4.6,
      price: 20.0,
    ),
    TouristAttraction(
      name: 'Livingstone Museum',
      location: 'Livingstone',
      description:
          'Zambia\'s largest and oldest museum, featuring exhibits on David Livingstone and local culture.',
      imagePath: 'assets/livingstone_museum.jpg',
      rating: 4.3,
      price: 5.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tourist Attractions'),
        backgroundColor: Colors.green[700],
      ),
      body: ListView.builder(
        itemCount: attractions.length,
        itemBuilder: (context, index) {
          final attraction = attractions[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AttractionDetailPage(attraction: attraction),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      attraction.imagePath,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              attraction.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    attraction.rating.toString(),
                                    style: TextStyle(
                                      color: Colors.green[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                color: Colors.grey[600], size: 16),
                            const SizedBox(width: 4),
                            Text(
                              attraction.location,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const Spacer(),
                            Text(
                              '\$${attraction.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.green[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          attraction.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AttractionDetailPage extends StatelessWidget {
  final TouristAttraction attraction;

  const AttractionDetailPage({Key? key, required this.attraction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(attraction.name),
              background: Image.asset(
                attraction.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Text(
                              attraction.location,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                attraction.rating.toString(),
                                style: TextStyle(
                                  color: Colors.green[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'About',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      attraction.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Activities',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildActivityItem(
                        Icons.hiking, 'Hiking Trails', '8 available'),
                    _buildActivityItem(
                        Icons.camera_alt, 'Photography Spots', '12 available'),
                    _buildActivityItem(
                        Icons.restaurant, 'Local Cuisine', '5 restaurants'),
                    _buildActivityItem(
                        Icons.directions_boat, 'Boat Tours', '3 available'),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to booking page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingPage(
                              attraction: attraction,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Book Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.green[700]),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
