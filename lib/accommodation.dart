// File: accommodation.dart
// ignore_for_file: use_super_parameters, prefer_interpolation_to_compose_strings, sort_child_properties_last, use_build_context_synchronously, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:afrijourney/booking.dart';
import 'package:url_launcher/url_launcher.dart';

class Accommodation {
  final String name;
  final String location;
  final String description;
  final String imagePath;
  final double rating;
  final double price;
  final List<String> amenities;
  final String type; // hotel, lodge, etc.

  Accommodation({
    required this.name,
    required this.location,
    required this.description,
    required this.imagePath,
    required this.rating,
    required this.price,
    required this.amenities,
    required this.type,
  });
}

class AccommodationPage extends StatefulWidget {
  const AccommodationPage({Key? key}) : super(key: key);

  @override
  State<AccommodationPage> createState() => _AccommodationPageState();
}

class _AccommodationPageState extends State<AccommodationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _filters = [
    'All',
    'Hotels',
    'Lodges',
    'Resorts',
    'Camping'
  ];
  String _selectedFilter = 'All';

  final List<Accommodation> accommodations = [
    Accommodation(
      name: 'Royal Livingstone Hotel',
      location: 'Livingstone',
      description:
          'Luxury hotel situated on the banks of the Zambezi River with stunning views of Victoria Falls.',
      imagePath: 'assets/royal_livingstone.jpg',
      rating: 4.8,
      price: 350.0,
      amenities: ['Pool', 'Spa', 'Free WiFi', 'Restaurant', 'Bar'],
      type: 'Hotels',
    ),
    Accommodation(
      name: 'Tongabezi Lodge',
      location: 'Livingstone',
      description:
          'Award-winning luxury lodge with private houses and cottages on the banks of the Zambezi River.',
      imagePath: 'assets/tongabezi.jpg',
      rating: 4.9,
      price: 420.0,
      amenities: ['Pool', 'Spa', 'Free WiFi', 'Restaurant', 'River views'],
      type: 'Lodges',
    ),
    Accommodation(
      name: 'Mfuwe Lodge',
      location: 'South Luangwa',
      description:
          'Safari lodge located inside South Luangwa National Park, known for elephants walking through reception.',
      imagePath: 'assets/mfuwe_lodge.jpg',
      rating: 4.7,
      price: 280.0,
      amenities: [
        'Pool',
        'Game drives',
        'Restaurant',
        'Bar',
        'Wildlife viewing'
      ],
      type: 'Lodges',
    ),
    Accommodation(
      name: 'Avani Victoria Falls Resort',
      location: 'Livingstone',
      description:
          'Family-friendly resort with free access to Victoria Falls and African-themed architecture.',
      imagePath: 'assets/avani_resort.jpg',
      rating: 4.5,
      price: 220.0,
      amenities: ['Pool', 'Free WiFi', 'Restaurant', 'Bar', 'Falls access'],
      type: 'Resorts',
    ),
    Accommodation(
      name: 'Mukambi Safari Lodge',
      location: 'Kafue National Park',
      description:
          'Safari lodge on the banks of the Kafue River offering excellent wildlife viewing.',
      imagePath: 'assets/mukambi_lodge.jpg',
      rating: 4.6,
      price: 250.0,
      amenities: ['Pool', 'Game drives', 'Restaurant', 'Bar', 'River views'],
      type: 'Lodges',
    ),
    Accommodation(
      name: 'Pioneer Camp',
      location: 'Lusaka',
      description:
          'Rustic camping experience just outside Lusaka with comfortable tents and basic amenities.',
      imagePath: 'assets/pioneer_camp.jpg',
      rating: 4.2,
      price: 85.0,
      amenities: ['Restaurant', 'Bar', 'Campfire', 'Nature walks'],
      type: 'Camping',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _filters.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedFilter = _filters[_tabController.index];
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Accommodation> get filteredAccommodations {
    return _selectedFilter == 'All'
        ? accommodations
        : accommodations.where((item) => item.type == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accommodations'),
        backgroundColor: Colors.green[700],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          tabs: _filters.map((filter) => Tab(text: filter)).toList(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search accommodations...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredAccommodations.length,
              itemBuilder: (context, index) {
                final accommodation = filteredAccommodations[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccommodationDetailPage(
                          accommodation: accommodation,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: Image.asset(
                                accommodation.imagePath,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      accommodation.rating.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      accommodation.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '\$${accommodation.price.toStringAsFixed(0)}/night',
                                    style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.location_on,
                                      size: 16, color: Colors.grey[600]),
                                  const SizedBox(width: 4),
                                  Text(
                                    accommodation.location,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                accommodation.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: accommodation.amenities
                                    .map(
                                      (amenity) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          amenity,
                                          style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
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
          ),
        ],
      ),
    );
  }
}

class AccommodationDetailPage extends StatelessWidget {
  final Accommodation accommodation;

  const AccommodationDetailPage({Key? key, required this.accommodation})
      : super(key: key);

  void _showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('View ${accommodation.name} Location'),
          content: Text(
            'Would you like to view this location on Yandex Maps?\n\n${accommodation.location}, Zambia',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  final String query =
                      Uri.encodeComponent('${accommodation.location}, Zambia');
                  final Uri uri =
                      Uri.parse('https://yandex.com/maps/?text=$query');
                  final success = await launchUrl(uri,
                      mode: LaunchMode.externalApplication);
                  if (!success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Could not open Yandex Maps')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('View'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Map button pressed');
          _showLocationDialog(context);
        },
        backgroundColor: Colors.green[700],
        tooltip: 'View Location',
        child: const Icon(
          Icons.map,
          color: Colors.white,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(accommodation.name),
              background: Image.asset(
                accommodation.imagePath,
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
                              accommodation.location,
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
                                accommodation.rating.toString(),
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
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          '\$${accommodation.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          '/night',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
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
                      accommodation.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Amenities',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: accommodation.amenities
                          .map(
                            (amenity) => _buildAmenityItem(amenity),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Photos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 150,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage(accommodation.imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Select Dates',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Check-in',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              suffixIcon: Icon(Icons.calendar_today,
                                  color: Colors.green[700]),
                            ),
                            readOnly: true,
                            onTap: () {
                              // Show date picker
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Check-out',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              suffixIcon: Icon(Icons.calendar_today,
                                  color: Colors.green[700]),
                            ),
                            readOnly: true,
                            onTap: () {
                              // Show date picker
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to booking page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingPage(
                              attraction: null,
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

  Widget _buildAmenityItem(String amenity) {
    IconData iconData;

    switch (amenity.toLowerCase()) {
      case 'pool':
        iconData = Icons.pool;
        break;
      case 'spa':
        iconData = Icons.spa;
        break;
      case 'free wifi':
        iconData = Icons.wifi;
        break;
      case 'restaurant':
        iconData = Icons.restaurant;
        break;
      case 'bar':
        iconData = Icons.local_bar;
        break;
      case 'game drives':
        iconData = Icons.directions_car;
        break;
      case 'river views':
        iconData = Icons.landscape;
        break;
      case 'falls access':
        iconData = Icons.water;
        break;
      case 'wildlife viewing':
        iconData = Icons.visibility;
        break;
      case 'campfire':
        iconData = Icons.local_fire_department;
        break;
      case 'nature walks':
        iconData = Icons.directions_walk;
        break;
      default:
        iconData = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: 16, color: Colors.green[700]),
          const SizedBox(width: 8),
          Text(amenity),
        ],
      ),
    );
  }
}
