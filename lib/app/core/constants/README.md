# API Constants

This directory contains constants and utility functions for API endpoints and URLs used throughout the application.

## ApiConstants

The `ApiConstants` class provides a centralized place to define and manage all API endpoints and URLs. This improves maintainability and consistency across the application.

### Usage

Import the class:

```dart
import 'package:apptiket/app/core/constants/api_constants.dart';
```

#### Base URLs

```dart
// Base API URL
ApiConstants.baseUrl        // https://flexy.my.id/api
// Storage URL
ApiConstants.storageUrl     // https://flexy.my.id/storage
// Main site URL
ApiConstants.mainUrl        // https://flexy.my.id
```

#### API Endpoints

```dart
// Endpoints (without leading slash)
ApiConstants.products       // /products
ApiConstants.tikets         // /tikets
ApiConstants.orderItems     // /order_items
ApiConstants.orders         // /orders
ApiConstants.stores         // /stores
ApiConstants.users          // /user
ApiConstants.login          // /login
ApiConstants.register       // /register
ApiConstants.changePassword // /change-password
```

#### Helper Methods

```dart
// Get a full API URL
ApiConstants.getFullUrl(ApiConstants.products)
// Result: https://flexy.my.id/api/products

// Get a storage URL
ApiConstants.getStorageUrl(ApiConstants.productImages + 'image.jpg')
// Result: https://flexy.my.id/storage/products/image.jpg

// Get a main site URL
ApiConstants.getMainUrl('some/path')
// Result: https://flexy.my.id/some/path
```

### Examples

#### Making API Requests

```dart
// GET request
final response = await http.get(
  Uri.parse(ApiConstants.getFullUrl(ApiConstants.products)),
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  },
);

// POST request
final response = await http.post(
  Uri.parse(ApiConstants.getFullUrl(ApiConstants.login)),
  headers: {
    'Content-Type': 'application/json',
  },
  body: jsonEncode({
    'email': email,
    'password': password,
  }),
);
```

#### With Query Parameters

```dart
// With query parameters
final userId = box.read('user_id');
final response = await http.get(
  Uri.parse('${ApiConstants.baseUrl}/orders?user_id=$userId'),
  headers: {'Authorization': 'Bearer $token'},
);
```

### Best Practices

1. Always import ApiConstants in controller files
2. Use the helper methods like `getFullUrl()` for consistent path handling
3. Add new endpoints to the ApiConstants class rather than hardcoding URLs
4. For custom query parameters, use string interpolation with ApiConstants.baseUrl
