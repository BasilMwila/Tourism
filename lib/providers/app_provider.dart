// lib/providers/app_provider.dart - FIXED VERSION
import 'package:afrijourney/services/accommodation_service.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/user_model.dart';
import '../models/attraction_model.dart';
import '../models/accommodation_model.dart';
import '../models/booking_model.dart';
import '../services/auth_service.dart';
import '../services/attraction_service.dart';
import '../services/booking_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';

class AppProvider with ChangeNotifier {
  // User state
  UserModel? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  bool _isInitialized = false; // NEW: Track initialization state

  // Location state
  Position? _currentPosition;
  bool _hasLocationPermission = false;

  // Data state
  List<AttractionModel> _attractions = [];
  List<AccommodationModel> _accommodations = [];
  List<BookingModel> _userBookings = [];
  List<AttractionModel> _favoriteAttractions = [];
  List<AccommodationModel> _favoriteAccommodations = [];

  // UI state
  String _selectedTheme = 'system';
  String _selectedLanguage = 'en';
  bool _isOnboardingCompleted = false;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized; // NEW
  Position? get currentPosition => _currentPosition;
  bool get hasLocationPermission => _hasLocationPermission;
  List<AttractionModel> get attractions => _attractions;
  List<AccommodationModel> get accommodations => _accommodations;
  List<BookingModel> get userBookings => _userBookings;
  List<AttractionModel> get favoriteAttractions => _favoriteAttractions;
  List<AccommodationModel> get favoriteAccommodations =>
      _favoriteAccommodations;
  String get selectedTheme => _selectedTheme;
  String get selectedLanguage => _selectedLanguage;
  bool get isOnboardingCompleted => _isOnboardingCompleted;

  // FIXED: Initialize app state - only called once
  Future<void> initializeApp() async {
    if (_isInitialized) return; // Prevent multiple initializations

    _setLoading(true);

    try {
      // Initialize storage
      await StorageService.init();

      // Load saved preferences
      await _loadPreferences();

      // Check if user is logged in
      await _checkAuthStatus();

      // Get location permission
      await _checkLocationPermission();

      // Load initial data - but don't block initialization
      _loadInitialDataInBackground();

      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing app: $e');
      _isInitialized = true; // Still mark as initialized to prevent loops
    } finally {
      _setLoading(false);
    }
  }

  // NEW: Load data in background without blocking UI
  void _loadInitialDataInBackground() async {
    try {
      await Future.wait([
        loadAttractions(),
        loadAccommodations(),
      ]);

      if (_isLoggedIn) {
        await _loadUserData();
      }
    } catch (e) {
      debugPrint('Error loading initial data: $e');
    }
  }

  // Authentication methods
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      final result = await AuthService.login(email: email, password: password);
      _currentUser = UserModel.fromJson(result['user']);
      _isLoggedIn = true;

      // Load user-specific data
      await _loadUserData();

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(String name, String email, String password,
      {String? phone}) async {
    _setLoading(true);
    try {
      final result = await AuthService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      _currentUser = UserModel.fromJson(result['user']);
      _isLoggedIn = true;

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Register error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await AuthService.logout();
      _currentUser = null;
      _isLoggedIn = false;
      _userBookings.clear();
      _favoriteAttractions.clear();
      _favoriteAccommodations.clear();

      notifyListeners();
    } catch (e) {
      debugPrint('Logout error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Location methods
  Future<void> getCurrentLocation() async {
    try {
      final position = await LocationService.getCurrentPosition();
      if (position != null) {
        _currentPosition = position;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Location error: $e');
    }
  }

  Future<void> requestLocationPermission() async {
    try {
      _hasLocationPermission =
          await LocationService.requestLocationPermissionWithDialog();
      if (_hasLocationPermission) {
        await getCurrentLocation();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Location permission error: $e');
    }
  }

  // FIXED: Data loading methods - better error handling
  Future<void> loadAttractions() async {
    try {
      _attractions = await AttractionService.getAllAttractions();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading attractions: $e');
      // Don't rethrow - use fallback data from service
    }
  }

  Future<void> loadAccommodations() async {
    try {
      _accommodations = await AccommodationService.getAllAccommodations();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading accommodations: $e');
      // Don't rethrow - use fallback data from service
    }
  }

  Future<void> loadUserBookings() async {
    if (!_isLoggedIn) return;

    try {
      final token = await AuthService.getToken();
      _userBookings = await BookingService.getUserBookings(token: token);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user bookings: $e');
    }
  }

  // Rest of the methods remain the same...

  // Booking methods
  Future<bool> createBooking({
    required int itemId,
    required BookingType type,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int adultCount,
    required int childCount,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    String? specialRequests,
  }) async {
    _setLoading(true);
    try {
      final token = await AuthService.getToken();
      final booking = await BookingService.createBooking(
        itemId: itemId,
        type: type,
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
        adultCount: adultCount,
        childCount: childCount,
        customerName: customerName,
        customerEmail: customerEmail,
        customerPhone: customerPhone,
        specialRequests: specialRequests,
        token: token,
      );

      _userBookings.insert(0, booking);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error creating booking: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Favorites methods
  Future<void> toggleAttractionFavorite(int attractionId) async {
    try {
      final token = await AuthService.getToken();
      final isFavorite = _favoriteAttractions.any((a) => a.id == attractionId);

      if (isFavorite) {
        await AttractionService.removeFromFavorites(attractionId, token: token);
        _favoriteAttractions.removeWhere((a) => a.id == attractionId);
        StorageService.removeFavoriteAttraction(attractionId);
      } else {
        await AttractionService.addToFavorites(attractionId, token: token);
        final attraction = _attractions.firstWhere((a) => a.id == attractionId);
        _favoriteAttractions.add(attraction);
        StorageService.addFavoriteAttraction(attractionId);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling attraction favorite: $e');
    }
  }

  Future<void> toggleAccommodationFavorite(int accommodationId) async {
    try {
      final token = await AuthService.getToken();
      final isFavorite =
          _favoriteAccommodations.any((a) => a.id == accommodationId);

      if (isFavorite) {
        await AccommodationService.removeFromFavorites(accommodationId,
            token: token);
        _favoriteAccommodations.removeWhere((a) => a.id == accommodationId);
        StorageService.removeFavoriteAccommodation(accommodationId);
      } else {
        await AccommodationService.addToFavorites(accommodationId,
            token: token);
        final accommodation =
            _accommodations.firstWhere((a) => a.id == accommodationId);
        _favoriteAccommodations.add(accommodation);
        StorageService.addFavoriteAccommodation(accommodationId);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling accommodation favorite: $e');
    }
  }

  bool isAttractionFavorite(int attractionId) {
    return _favoriteAttractions.any((a) => a.id == attractionId);
  }

  bool isAccommodationFavorite(int accommodationId) {
    return _favoriteAccommodations.any((a) => a.id == accommodationId);
  }

  // Settings methods
  Future<void> updateTheme(String theme) async {
    _selectedTheme = theme;
    await StorageService.saveThemeMode(theme);
    notifyListeners();
  }

  Future<void> updateLanguage(String language) async {
    _selectedLanguage = language;
    await StorageService.saveLanguage(language);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _isOnboardingCompleted = true;
    await StorageService.setOnboardingCompleted();
    notifyListeners();
  }

  // Search methods
  Future<List<AttractionModel>> searchAttractions(String query) async {
    try {
      StorageService.addToSearchHistory(query);
      return await AttractionService.searchAttractions(query);
    } catch (e) {
      debugPrint('Error searching attractions: $e');
      return [];
    }
  }

  Future<List<AccommodationModel>> searchAccommodations(String query) async {
    try {
      StorageService.addToSearchHistory(query);
      return await AccommodationService.searchAccommodations(query);
    } catch (e) {
      debugPrint('Error searching accommodations: $e');
      return [];
    }
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> _loadPreferences() async {
    _selectedTheme = StorageService.getThemeMode();
    _selectedLanguage = StorageService.getLanguage();
    _isOnboardingCompleted = StorageService.isOnboardingCompleted();
  }

  Future<void> _checkAuthStatus() async {
    _isLoggedIn = await AuthService.isLoggedIn();
    if (_isLoggedIn) {
      _currentUser = await AuthService.getCurrentUser();
    }
  }

  Future<void> _checkLocationPermission() async {
    _hasLocationPermission = await LocationService.hasLocationPermission();
    if (_hasLocationPermission) {
      await getCurrentLocation();
    }
  }

  Future<void> _loadUserData() async {
    await Future.wait([
      loadUserBookings(),
      _loadFavorites(),
    ]);
  }

  Future<void> _loadFavorites() async {
    // Load from local storage first
    final favoriteAttractionIds = StorageService.getFavoriteAttractions();
    final favoriteAccommodationIds = StorageService.getFavoriteAccommodations();

    _favoriteAttractions = _attractions
        .where((a) => favoriteAttractionIds.contains(a.id.toString()))
        .toList();

    _favoriteAccommodations = _accommodations
        .where((a) => favoriteAccommodationIds.contains(a.id.toString()))
        .toList();
  }
}
