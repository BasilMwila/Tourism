// lib/main.dart - Updated with backend integration
// ignore_for_file: depend_on_referenced_packages, deprecated_member_use, await_only_futures, unused_element, unused_local_variable, unused_field, prefer_final_fields, use_build_context_synchronously, prefer_typing_uninitialized_variables, unnecessary_import

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:afrijourney/tourist_attractions.dart';
import 'package:afrijourney/accommodation.dart';
import 'package:logger/logger.dart';
import 'package:yandex_maps_mapkit_lite/init.dart' as init;
import 'package:yandex_maps_mapkit_lite/mapkit.dart' as yandex_mapkit;
import 'package:yandex_maps_mapkit_lite/mapkit_factory.dart';
import 'package:yandex_maps_mapkit_lite/yandex_map.dart';

// Import new backend services and providers
import 'providers/app_provider.dart';
import 'services/storage_service.dart';
import 'constants/app_constants.dart';
import 'screens/auth/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await _initializeServices();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ZambiaApp());
}

Future<void> _initializeServices() async {
  try {
    // Initialize local storage
    await StorageService.init();

    // Initialize Yandex Maps
    init.initMapkit(apiKey: 'c679853d-68dd-4eda-9e3d-6492db67f98d');

    // Initialize other services as needed
    debugPrint('Services initialized successfully');
  } catch (e) {
    debugPrint('Error initializing services: $e');
  }
}

class ZambiaApp extends StatelessWidget {
  const ZambiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: _buildTheme(appProvider.selectedTheme),
            home: _buildInitialScreen(appProvider),
            routes: {
              '/home': (context) => const HomePage(),
              '/login': (context) => const LoginScreen(),
              '/onboarding': (context) => const OnboardingScreen(),
            },
          );
        },
      ),
    );
  }

  ThemeData _buildTheme(String themeMode) {
    final isDark = themeMode == 'dark' ||
        (themeMode == 'system' &&
            WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark);

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      primarySwatch: Colors.green,
      primaryColor: Colors.green[700],
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildInitialScreen(AppProvider appProvider) {
    return FutureBuilder(
      future: appProvider.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        if (!appProvider.isOnboardingCompleted) {
          return const OnboardingScreen();
        }

        if (!appProvider.isLoggedIn) {
          return const LoginScreen();
        }

        return const HomePage();
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo or app icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.landscape,
                size: 60,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              AppConstants.appDescription,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                  ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<Widget> _pages = [
    const HomeScreen(),
    AttractionsPage(),
    const AccommodationPage(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: AppConstants.shortAnimationDuration,
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attractions),
            label: 'Attractions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hotel),
            label: 'Stays',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: [
            // App Bar with user greeting
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: Colors.green[700],
              flexibleSpace: FlexibleSpaceBar(
                title: Consumer<AppProvider>(
                  builder: (context, provider, child) {
                    final user = provider.currentUser;
                    return Text(
                      user != null
                          ? 'Hello, ${user.name.split(' ').first}!'
                          : 'Welcome!',
                      style: const TextStyle(color: Colors.white),
                    );
                  },
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.green[700]!,
                        Colors.green[600]!,
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.landscape,
                      size: 80,
                      color: Colors.white24,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Discover the hidden gem of Africa with stunning landscapes, diverse wildlife, and rich cultural heritage.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSearchBar(context),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Trending Events'),
                    const SizedBox(height: 12),
                    _buildTrendingEventsSection(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Popular Accommodations'),
                    const SizedBox(height: 12),
                    _buildHotelsSection(context),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Exciting Activities'),
                    const SizedBox(height: 12),
                    _buildActivitiesSection(),
                    const SizedBox(height: 70),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showYandexMap(context);
        },
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.map, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search destinations, activities, etc.',
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.green[700]),
        ),
        onSubmitted: (query) {
          // Handle search
          if (query.isNotEmpty) {
            context.read<AppProvider>().searchAttractions(query);
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'See All',
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingEventsSection() {
    final List<Map<String, dynamic>> events = [
      {
        'name': 'Kuomboka Ceremony',
        'image': 'assets/kuomboka.jpg',
        'description': 'Annual traditional ceremony of the Lozi people',
        'date': 'April 2025'
      },
      {
        'name': 'Nc\'wala Ceremony',
        'image': 'assets/ncwala.jpg',
        'description': 'Traditional harvest festival of the Ngoni people',
        'date': 'February 2025'
      },
      {
        'name': 'Lwiindi Ceremony',
        'image': 'assets/lwiindi.jpg',
        'description': 'Cultural ceremony of the Tonga people',
        'date': 'July 2025'
      },
    ];

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        itemBuilder: (context, index) {
          return Container(
            width: 250,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    events[index]['image'],
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(12)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        events[index]['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        events[index]['description'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 14, color: Colors.green[700]),
                          const SizedBox(width: 4),
                          Text(
                            events[index]['date'],
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHotelsSection(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final accommodations = provider.accommodations.take(4).toList();

        if (accommodations.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: accommodations.length,
            itemBuilder: (context, index) {
              final accommodation = accommodations[index];
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(
                        accommodation.imagePath,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(12)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            accommodation.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  accommodation.location,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'From \$${accommodation.price.toStringAsFixed(0)}/night',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildActivitiesSection() {
    final List<Map<String, dynamic>> activities = [
      {
        'name': 'Victoria Falls Bungee Jumping',
        'image': 'assets/bungee_jumping.jpg',
        'price': '\$120',
        'duration': '1 hour',
      },
      {
        'name': 'Zip Lining',
        'image': 'assets/zip_lining.jpg',
        'price': '\$80',
        'duration': '2 hours',
      },
      {
        'name': 'Safari Game Drive',
        'image': 'assets/safari_drive.jpg',
        'price': '\$150',
        'duration': '4 hours',
      },
      {
        'name': 'White Water Rafting',
        'image': 'assets/rafting.jpg',
        'price': '\$95',
        'duration': '3 hours',
      },
    ];

    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: activities.length,
        itemBuilder: (context, index) {
          return Container(
            width: 220,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    activities[index]['image'],
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(12)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activities[index]['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            activities[index]['duration'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            activities[index]['price'],
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          minimumSize: const Size(double.infinity, 32),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showYandexMap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const YandexMapView(),
    );
  }
}

// Profile Screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final user = provider.currentUser;

          if (user == null) {
            return const Center(
              child: Text('Please log in to view your profile'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // User info section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.green[700],
                          child: Text(
                            user.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (user.phone != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            user.phone!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Menu items
                _buildMenuItem(
                  icon: Icons.book,
                  title: 'My Bookings',
                  subtitle: '${provider.userBookings.length} bookings',
                  onTap: () {
                    // Navigate to bookings
                  },
                ),
                _buildMenuItem(
                  icon: Icons.favorite,
                  title: 'Favorites',
                  subtitle:
                      '${provider.favoriteAttractions.length + provider.favoriteAccommodations.length} items',
                  onTap: () {
                    // Navigate to favorites
                  },
                ),
                _buildMenuItem(
                  icon: Icons.history,
                  title: 'Booking History',
                  subtitle: 'View past trips',
                  onTap: () {
                    // Navigate to booking history
                  },
                ),
                _buildMenuItem(
                  icon: Icons.support,
                  title: 'Support',
                  subtitle: 'Get help and support',
                  onTap: () {
                    // Navigate to support
                  },
                ),
                _buildMenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  subtitle: 'Sign out of your account',
                  onTap: () async {
                    await provider.logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login',
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.green[700]),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

// Yandex Map View
class YandexMapView extends StatefulWidget {
  const YandexMapView({super.key});

  @override
  State<YandexMapView> createState() => _YandexMapViewState();
}

class _YandexMapViewState extends State<YandexMapView>
    with WidgetsBindingObserver {
  bool _isFullScreen = false;
  var _mapWindow;
  final _mapObjects = <yandex_mapkit.MapObject>[];
  final _logger = Logger();

  final yandex_mapkit.Point _zambiaCenter =
      const yandex_mapkit.Point(latitude: -15.4167, longitude: 28.2833);
  double _zoom = 10.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    mapkit.onStart();
  }

  @override
  void dispose() {
    mapkit.onStop();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      mapkit.onStart();
    } else if (state == AppLifecycleState.paused) {
      mapkit.onStop();
    }
  }

  void _onMapCreated(mapWindow) {
    setState(() {
      _mapWindow = mapWindow;
    });
    _addZambiaAttractions();
  }

  void _zoomIn() {
    if (_mapWindow != null) {
      setState(() {
        _zoom = (_zoom + 1).clamp(3.0, 20.0);
      });

      try {
        final currentTarget = _mapWindow.map.cameraPosition.target;
        _mapWindow.map.move(yandex_mapkit.CameraPosition(currentTarget,
            zoom: _zoom, azimuth: 0, tilt: 0));
      } catch (e) {
        _logger.e('Error zooming in: $e');
      }
    }
  }

  void _zoomOut() {
    if (_mapWindow != null) {
      setState(() {
        _zoom = (_zoom - 1).clamp(3.0, 20.0);
      });

      try {
        final currentTarget = _mapWindow.map.cameraPosition.target;
        _mapWindow.map.move(yandex_mapkit.CameraPosition(currentTarget,
            zoom: _zoom, azimuth: 0, tilt: 0));
      } catch (e) {
        _logger.e('Error zooming out: $e');
      }
    }
  }

  Future<void> _addZambiaAttractions() async {
    // Add markers for popular Zambian attractions
    final attractions = [
      {
        'name': 'Victoria Falls',
        'lat': -17.9243,
        'lng': 25.8572,
        'description': 'One of the largest waterfalls in the world'
      },
      {
        'name': 'South Luangwa National Park',
        'lat': -13.0864,
        'lng': 31.8656,
        'description': 'Premier wildlife destination'
      },
      {
        'name': 'Kafue National Park',
        'lat': -15.5,
        'lng': 26.0,
        'description': 'Largest national park in Zambia'
      },
      {
        'name': 'Lower Zambezi National Park',
        'lat': -15.75,
        'lng': 29.25,
        'description': 'Scenic park along the Zambezi River'
      },
    ];

    // This is a simplified version - you would implement proper marker addition here
    debugPrint('Adding ${attractions.length} attraction markers to map');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppConstants.shortAnimationDuration,
      height: _isFullScreen
          ? MediaQuery.of(context).size.height
          : MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildMapHeader(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: YandexMap(
                      onMapCreated: _onMapCreated,
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 100,
                    child: Column(
                      children: [
                        _mapControlButton(Icons.add, _zoomIn),
                        const SizedBox(height: 8),
                        _mapControlButton(Icons.remove, _zoomOut),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildLocationSearch(),
        ],
      ),
    );
  }

  Widget _buildMapHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Explore Map',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                    _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                onPressed: () {
                  setState(() {
                    _isFullScreen = !_isFullScreen;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSearch() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search locations in Zambia',
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.green[700]),
              ),
              onSubmitted: (value) {
                // Handle location search
                debugPrint('Searching for: $value');
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickFilterButton('Attractions', Icons.attractions),
              _buildQuickFilterButton('Hotels', Icons.hotel),
              _buildQuickFilterButton('Restaurants', Icons.restaurant),
              _buildQuickFilterButton('Events', Icons.event),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildQuickFilterButton(String label, IconData icon) {
    return GestureDetector(
      onTap: () {
        debugPrint('Filter tapped: $label');
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green[100],
            radius: 20,
            child: Icon(icon, color: Colors.green[700], size: 20),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.green[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapControlButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.green[700]),
        onPressed: onPressed,
        constraints: const BoxConstraints(
          minHeight: 36,
          minWidth: 36,
          maxHeight: 36,
          maxWidth: 36,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
