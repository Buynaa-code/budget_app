import 'dart:io';
import 'package:flutter/foundation.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// A utility class to initialize the database appropriately for different platforms.
class DatabaseInitializer {
  /// Initialize the appropriate database factory based on the current platform.
  static Future<void> initialize() async {
    try {
      if (!kIsWeb) {
        // For desktop platforms (Windows, Linux, macOS)
        if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
          print('Mock database initialized for ${Platform.operatingSystem}');
        } else {
          // For mobile platforms, the default factory works fine
          print('Mock database initialized for ${Platform.operatingSystem}');
        }
      } else {
        // Web platform doesn't support SQLite natively
        print('Mock database initialized for web platform');
      }
    } catch (e) {
      print('Failed to initialize database: $e');
      rethrow;
    }
  }
}
