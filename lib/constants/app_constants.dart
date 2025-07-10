// lib/constants/app_constants.dart
class AppConstants {
  // App Information
  static const String appName = 'AfriJourney';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Discover the Beauty of Zambia';
  
  // API Configuration
  static const String baseUrl = 'https://your-backend-url.com/api';
  static const String apiVersion = 'v1';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Database Configuration
  static const String databaseName = 'zambia_tourism.db';
  static const int databaseVersion = 1;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Map Configuration
  static const double defaultLatitude = -15.4167; // Lusaka
  static const double defaultLongitude = 28.2833; // Lusaka
  static const double defaultZoom = 10.0;
  static const double maxZoom = 20.0;
  static const double minZoom = 3.0;
  
  // Search Configuration
  static const int maxSearchHistory = 20;
  static const int maxRecentlyViewed = 50;
  static const Duration searchDebounceTime = Duration(milliseconds: 500);
  
  // Booking Configuration
  static const int maxAdultCount = 10;
  static const int maxChildCount = 10;
  static const int minBookingDays = 1;
  static const int maxBookingDays = 365;
  
  // Image Configuration
  static const double maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);
  
  // Cache Configuration
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB
  
  // Notification Configuration
  static const String notificationChannelId = 'zambia_tourism_channel';
  static const String notificationChannelName = 'Zambia Tourism';
  static const String notificationChannelDescription = 'Notifications for bookings and updates';
  
  // File Paths
  static const String imageCachePath = 'image_cache';
  static const String offlineDataPath = 'offline_data';
  
  // Default Values
  static const String defaultCurrency = 'USD';
  static const String defaultLanguage = 'en';
  static const String defaultCountry = 'ZM';
  
  // Rating Configuration
  static const double minRating = 1.0;
  static const double maxRating = 5.0;
  static const double defaultRating = 4.0;
  
  // Location Configuration
  static const double nearbyRadius = 50.0; // kilometers
  static const Duration locationUpdateInterval = Duration(seconds: 30);
  
  // Error Messages
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Please check your internet connection.';
  static const String locationErrorMessage = 'Unable to get your location.';
  static const String authErrorMessage = 'Please login to continue.';
  
  // Success Messages
  static const String bookingSuccessMessage = 'Your booking has been confirmed!';
  static const String profileUpdateSuccessMessage = 'Profile updated successfully!';
  static const String favoriteAddedMessage = 'Added to favorites!';
  static const String favoriteRemovedMessage = 'Removed from favorites!';
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,};
  static const String phoneRegex = r'^\+?[1-9]\d{1,14};
  
  // Social Media Links
  static const String facebookUrl = 'https://facebook.com/zambiatourism';
  static const String twitterUrl = 'https://twitter.com/zambiatourism';
  static const String instagramUrl = 'https://instagram.com/zambiatourism';
  static const String websiteUrl = 'https://zambiatourism.com';
  
  // Contact Information
  static const String supportEmail = 'support@zambiatourism.com';
  static const String emergencyPhone = '+260-xxx-xxxx';
  
  // App Store Links
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.example.tourism';
  static const String appStoreUrl = 'https://apps.apple.com/app/zambia-tourism/id123456789';
  
  // Terms and Privacy
  static const String termsOfServiceUrl = 'https://zambiatourism.com/terms';
  static const String privacyPolicyUrl = 'https://zambiatourism.com/privacy';
  
  // Default Images
  static const String defaultProfileImage = 'assets/default_profile.png';
  static const String placeholderImage = 'assets/placeholder_image.png';
  static const String noImageAvailable = 'assets/no_image_available.png';
  static const String logoImage = 'assets/logo.png';
}