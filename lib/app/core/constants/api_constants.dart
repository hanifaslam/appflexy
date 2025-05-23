/// ApiConstants adalah class yang mengatur semua URL API yang digunakan dalam aplikasi.
/// Gunakan class ini untuk mengakses URL API yang konsisten di seluruh aplikasi.
///
/// Contoh penggunaan:
/// ```dart
/// // Mendapatkan URL API lengkap
/// Uri.parse(ApiConstants.getFullUrl(ApiConstants.products));
///
/// // Mendapatkan URL gambar dari storage
/// Uri.parse(ApiConstants.getStorageUrl(ApiConstants.productImages + fileName));
///
/// // Mendapatkan URL utama dengan path
/// Uri.parse(ApiConstants.getMainUrl('path/to/resource'));
/// ```
class ApiConstants {
  // Base URLs
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  static const String storageUrl = 'http://10.0.2.2:8000/storage';
  static const String mainUrl = 'http://127.0.0.1:8000';
  // API endpoints
  static const String products = '/products';
  static const String tikets = '/tikets';
  static const String orderItems = '/order_items';
  static const String orders = '/orders';
  static const String stores = '/stores';
  static const String users = '/user';  
  static const String login = '/login';
  static const String register = '/register';
  static const String changePassword = '/change-password';
  static const String transaction = '/payment/create-transaction';

  // Storage paths
  static const String productImages = '/products/';

  /// Menggabungkan baseUrl dengan endpoint yang diberikan.
  ///
  /// Jika endpoint dimulai dengan '/', slash akan dihapus untuk menghindari double slash.
  ///
  /// @param endpoint Endpoint API yang akan digabungkan dengan baseUrl
  /// @return URL API lengkap
  static String getFullUrl(String endpoint) {
    // Remove leading slash if present to avoid double slashes
    if (endpoint.startsWith('/')) {
      endpoint = endpoint.substring(1);
    }
    return '$baseUrl/$endpoint';
  }

  /// Menggabungkan storageUrl dengan path yang diberikan.
  ///
  /// Jika path dimulai dengan '/', slash akan dihapus untuk menghindari double slash.
  ///
  /// @param path Path storage yang akan digabungkan dengan storageUrl
  /// @return URL storage lengkap
  static String getStorageUrl(String path) {
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    return '$storageUrl/$path';
  }

  /// Menggabungkan mainUrl dengan path yang diberikan.
  ///
  /// Jika path dimulai dengan '/', slash akan dihapus untuk menghindari double slash.
  ///
  /// @param path Path yang akan digabungkan dengan mainUrl
  /// @return URL utama lengkap
  static String getMainUrl(String path) {
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    return '$mainUrl/$path';
  }
}
