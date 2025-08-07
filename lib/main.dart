// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'app.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Request permissions on app startup
//   await _requestPermissions();

//   runApp(const VoltargeGoApp());
// }

// Future<void> _requestPermissions() async {
//   // Request location permission
//   if (await Permission.location.request().isGranted) {
//     // Location permission granted
//   } else {
//     // Handle permission denied (e.g., show a dialog)
//   }

//   // Request notification permission
//   if (await Permission.notification.request().isGranted) {
//     // Notification permission granted
//   } else {
//     // Handle permission denied
//   }
// }

import 'package:flutter/material.dart';
import 'app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voltargego_flutter/core/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase'i başlat (URL ve Key'i daha sonra güncelleyeceğiz)
  await Supabase.initialize(
    url: SupabaseService.supabaseUrl,
    anonKey: SupabaseService.supabaseAnonKey,
  );

  runApp(const VoltargeGoApp());
}
